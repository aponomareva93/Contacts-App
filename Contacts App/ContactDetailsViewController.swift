//
//  ContactDetaulsViewController.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Eureka
import ImageRow

protocol ContactDetailsViewControllerDelegate: class {
    func contactDetailsViewControllerDidTapClose(_ contactDetailsViewController: ContactDetailsViewController?)
}

class ContactDetailsViewController: FormViewController {
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        return cancelBarButtonItem
    }()
    
    lazy var saveBarButtonItem: UIBarButtonItem = {
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        return saveBarButtonItem
    }()

    weak var delegate: ContactDetailsViewControllerDelegate?
    
    fileprivate var viewModel: ContactDetailsViewModel
    
    var newImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.rowHeight = Constants.contactDetailsTableRowHeight
    }
    
    init(viewModel: ContactDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.viewTitle
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        form +++ Section(Constants.contactDetailsTableTitle)
            
            <<< ImageRow() { row in
                row.tag = Constants.imageRowTag
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                row.clearAction = .yes(style: .destructive)
                row.value = viewModel.contactImage                
                row.onChange { [weak self] row in
                    if row.value == nil {
                        row.value = self?.viewModel.placeholderImage
                        self?.viewModel.contactHasImage = false
                    } else {
                        self?.viewModel.contactHasImage = true
                    }
                }
                }.cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    
            }
            <<< TextRow(){ row in
                row.title = Constants.nameRowTitle
                row.tag = Constants.nameRowTag
                row.value = viewModel.contactName
            }
            <<< TextRow(){ row in
                row.title = Constants.surnameRowTitle
                row.tag = Constants.surnameRowTag
                row.value = viewModel.contactSurname
            }
            <<< PhoneRow(){ row in
                row.title = Constants.phoneRowTitle
                row.tag = Constants.phoneRowTag
                row.value = viewModel.contactPhone
            }
            <<< RingtoneRow(){ row in
                row.title = Constants.ringtoneRowTitle
                row.tag = Constants.ringtoneRowTag
                row.value = viewModel.contactRingtone
            }
            <<< TextAreaRow(){ row in
                row.placeholder = Constants.noteRowTag
                row.tag = Constants.noteRowTag
                row.value = viewModel.contactNote
            }
        if viewModel.isNewContact {
            form +++ ButtonRow() { button in
                button.title = Constants.seleteButtonTitle
                button.tag = Constants.deleteButtonTag
                button.onCellSelection(deleteButtonTapped)
                }
                .cellUpdate { cell, row in
                    cell.textLabel?.textColor = .red
                }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelButtonTapped(sender: UIBarButtonItem) {
        delegate?.contactDetailsViewControllerDidTapClose(self)
    }
    
    func saveButtonTapped(sender: UIBarButtonItem) {
        let layouts = form.values()
        do {
            try viewModel.saveContact(name: layouts[Constants.nameRowTag] as? String, surname: layouts[Constants.surnameRowTag] as? String, phone: layouts[Constants.phoneRowTag] as? String, ringtone: layouts[Constants.ringtoneRowTag] as? String, note: layouts[Constants.noteRowTag] as? String, image: layouts[Constants.imageRowTag] as? UIImage)
            showAlert(withTitle: "Success", message: "Contact saved", okButtonTapped: { [weak self] in
                self?.delegate?.contactDetailsViewControllerDidTapClose(self)
            })
        } catch {
            showAlert(withTitle: "Error", message: error.localizedDescription)
        }
    }
    
    func deleteButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        let alert = UIAlertController(title: "Delete contact", message: "Do you really want to delete this contact?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.viewModel.deleteContact()
            self?.delegate?.contactDetailsViewControllerDidTapClose(self)
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, message: String, okButtonTapped: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okButtonTapped?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension Constants {
    static let contactDetailsTableRowHeight: CGFloat = 45.0
    
    static let contactDetailsTableTitle = "Contact Details"
    static let imageRowTag = "ImageRow"
    static let nameRowTag = "NameRow"
    static let surnameRowTag = "SurnameRow"
    static let phoneRowTag = "PhoneRow"
    static let ringtoneRowTag = "RingtoneRow"
    static let noteRowTag = "NoteRow"
    static let deleteButtonTag = "DeleteButton"
    
    static let nameRowTitle = "Name"
    static let surnameRowTitle = "Surname"
    static let phoneRowTitle = "Phone Number"
    static let ringtoneRowTitle = "Ringtone"
    static let seleteButtonTitle = "Delete Contact"
    static let noteRowPlaceholder = "Note"
}
