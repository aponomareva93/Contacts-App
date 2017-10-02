//
//  ImagePickerController.swift
//  Contacts App
//
//  Created by anna on 29.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import Eureka

/// Selector Controller used to pick an image
class ImagePickerController: UIImagePickerController,
    TypedRowControllerType,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    /// The row that pushed or presented this controller
    var row: RowOf<UIImage>!
    
    /// A closure to be called when the controller disappears.
    var onDismissCallback: ((UIViewController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        (row as? ImageRow)?.imageURL = info[UIImagePickerControllerReferenceURL] as? URL
        row.value = info[UIImagePickerControllerOriginalImage] as? UIImage
        onDismissCallback?(self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        onDismissCallback?(self)
    }
}
