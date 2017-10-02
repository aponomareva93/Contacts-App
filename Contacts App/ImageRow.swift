//
//  ImageRow.swift
//  Contacts App
//
//  Created by anna on 29.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import Eureka

struct ImageRowSourceTypes: OptionSet {
    var rawValue: Int
    var imagePickerControllerSourceTypeRawValue: Int { return self.rawValue >> 1 }
    
    init(rawValue: Int) { self.rawValue = rawValue }
    init(_ sourceType: UIImagePickerControllerSourceType) { self.init(rawValue: 1 << sourceType.rawValue) }
    
    static let PhotoLibrary  = ImageRowSourceTypes(.photoLibrary)
    static let Camera  = ImageRowSourceTypes(.camera)
    static let SavedPhotosAlbum = ImageRowSourceTypes(.savedPhotosAlbum)
    static let All: ImageRowSourceTypes = [Camera, PhotoLibrary, SavedPhotosAlbum]
}

extension ImageRowSourceTypes {
    
    // MARK: Helpers
    
    var localizedString: String {
        switch self {
        case ImageRowSourceTypes.Camera:
            return "Take photo"
        case ImageRowSourceTypes.PhotoLibrary:
            return "Photo Library"
        case ImageRowSourceTypes.SavedPhotosAlbum:
            return "Saved Photos"
        default:
            return ""
        }
    }
}

enum ImageClearAction {
    case no
    case yes(style: UIAlertActionStyle)
}

// MARK: Row
class ImageRowPrototype<Cell: CellType>: OptionsRow<Cell>, PresenterRowType where Cell: BaseCell, Cell.Value == UIImage {
    
    typealias PresenterRow = ImagePickerController
    
    /// Defines how the view controller will be presented, pushed, etc.
    var presentationMode: PresentationMode<PresenterRow>?
    
    /// Will be called before the presentation occurs.
    var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?
    
    var sourceTypes: ImageRowSourceTypes
    internal(set) var imageURL: URL?
    var placeholderImageName: String?
    var clearAction = ImageClearAction.yes(style: .destructive)
    
    private var _sourceType: UIImagePickerControllerSourceType = .camera
    
    required init(tag: String?) {
        sourceTypes = .All
        super.init(tag: tag)
        presentationMode = .presentModally(controllerProvider: ControllerProvider.callback { return ImagePickerController() },
                                           onDismiss: { [weak self] viewController in
                                            self?.select()
                                            viewController.dismiss(animated: true)
        })
        self.displayValueFor = nil
    }
    
    // copy over the existing logic from the SelectorRow
    func displayImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {
        if let presentationMode = presentationMode, !isDisabled {
            if let controller = presentationMode.makeController() {
                controller.row = self
                controller.sourceType = sourceType
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: cell.formViewController()!)
            } else {
                _sourceType = sourceType
                presentationMode.present(nil, row: self, presentingController: cell.formViewController()!)
            }
        }
    }
    
    /// Extends `didSelect` method
    /// Selecting the Image Row cell will open a popup to choose where to source the photo from,
    /// based on the `sourceTypes` configured and the available sources.
    override func customDidSelect() {
        guard !isDisabled else {
            super.customDidSelect()
            return
        }
        deselect()
        
        var availableSources: ImageRowSourceTypes = []
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let _ = availableSources.insert(.PhotoLibrary)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let _ = availableSources.insert(.Camera)
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let _ = availableSources.insert(.SavedPhotosAlbum)
        }
        
        sourceTypes.formIntersection(availableSources)
        
        if sourceTypes.isEmpty {
            super.customDidSelect()
            guard let presentationMode = presentationMode else { return }
            if let controller = presentationMode.makeController() {
                controller.row = self
                controller.title = selectorTitle ?? controller.title
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
            } else {
                presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
            }
            return
        }
        
        // Now that we know the number of sources aren't empty, let the user select the source
        let sourceActionSheet = UIAlertController(title: nil, message: selectorTitle, preferredStyle: .actionSheet)
        guard let tableView = cell.formViewController()?.tableView  else { fatalError() }
        if let popView = sourceActionSheet.popoverPresentationController {
            popView.sourceView = tableView
            popView.sourceRect = tableView.convert(cell.accessoryView?.frame ?? cell.contentView.frame, from: cell)
        }
        createOptionsForAlertController(sourceActionSheet)
        if case .yes(let style) = clearAction, value != nil {
            let clearPhotoOption = UIAlertAction(title: NSLocalizedString("Clear Photo", comment: ""),
                                                 style: style,
                                                 handler: { [weak self] _ in
                                                    self?.value = nil
                                                    self?.imageURL = nil
                                                    self?.updateCell()
            })
            sourceActionSheet.addAction(clearPhotoOption)
        }
        if sourceActionSheet.actions.count == 1 {
            if let imagePickerSourceType = UIImagePickerControllerSourceType(rawValue:
                sourceTypes.imagePickerControllerSourceTypeRawValue) {
                displayImagePickerController(imagePickerSourceType)
            }
        } else {
            let cancelOption = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:nil)
            sourceActionSheet.addAction(cancelOption)
            if let presentingViewController = cell.formViewController() {
                presentingViewController.present(sourceActionSheet, animated: true)
            }
        }
    }
    
    /**
     Prepares the pushed row setting its title and completion callback.
     */
    override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        guard let rowVC = segue.destination as? PresenterRow else { return }
        rowVC.title = selectorTitle ?? rowVC.title
        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
        onPresentCallback?(cell.formViewController()!, rowVC)
        rowVC.row = self
        rowVC.sourceType = _sourceType
    }
    
    override func customUpdateCell() {
        super.customUpdateCell()
        
        cell.accessoryType = .none
        cell.editingAccessoryView = .none
        
        var currentImage: UIImage?
        
        if let image = self.value {
            currentImage = image
        } else if let placeholderImageName = placeholderImageName {
            currentImage = UIImage(named: placeholderImageName)
        }
        
        if let image = currentImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            imageView.clipsToBounds = true
            
            cell.accessoryView = imageView
            cell.editingAccessoryView = imageView
        } else {
            cell.accessoryView = nil
            cell.editingAccessoryView = nil
        }
    }
}

extension ImageRowPrototype {
    
    // MARK: Helpers
    
    func createOptionForAlertController(_ alertController: UIAlertController, sourceType: ImageRowSourceTypes) {
        guard let pickerSourceType = UIImagePickerControllerSourceType(
            rawValue: sourceType.imagePickerControllerSourceTypeRawValue),
            sourceTypes.contains(sourceType)
            else { return }
        let option = UIAlertAction(title: NSLocalizedString(sourceType.localizedString, comment: ""),
                                   style: .default,
                                   handler: { [weak self] _ in
                                    self?.displayImagePickerController(pickerSourceType)
        })
        alertController.addAction(option)
    }
    
    func createOptionsForAlertController(_ alertController: UIAlertController) {
        createOptionForAlertController(alertController, sourceType: .Camera)
        createOptionForAlertController(alertController, sourceType: .PhotoLibrary)
        createOptionForAlertController(alertController, sourceType: .SavedPhotosAlbum)
    }
}

/// A selector row where the user can pick an image
final class ImageRow: ImageRowPrototype<PushSelectorCell<UIImage>>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
    }
}
