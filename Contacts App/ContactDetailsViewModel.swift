//
//  ContactDetailsViewModel.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class ContactDetailsViewModel {
    fileprivate var contact: Contact?
    
    var contactHasImage: Bool
    
    init(contact: Contact? = nil) {
        self.contact = contact
        if contact?.imageName != nil {
            contactHasImage = true
        } else {
            contactHasImage = false
        }
    }
    
    func saveContact(name: String?,
                     surname: String?,
                     phone: String?,
                     ringtone: String?,
                     note: String?,
                     image: UIImage?) throws {
        guard let name = name,
            let phone = phone
        else {
            let error = NSError(domain: Constants.requiredFieldsAreEmptyError.domain,
                                code: Constants.requiredFieldsAreEmptyError.code,
                                userInfo: Constants.requiredFieldsAreEmptyError.userInfo)
            throw error
        }
        
        var imageName: String? = nil
        if contactHasImage,
            let image = image {
            imageName = String(Int(Date().timeIntervalSince1970)) + "_newImage.png"
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let documentsPath = documentsPath,
                let imageName = imageName {
                let destinationPath = documentsPath.appending( "/" + imageName)
                do {
                    try UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: destinationPath))
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("ContactDetailsViewModel::saveContact: Cannot find path for saving image")
                imageName = nil
            }
        }
        
        if let existingContact = contact {
            DataBaseManager.editExistingContact(contact: existingContact,
                                                name: name,
                                                surname: surname,
                                                phone: phone,
                                                ringtone: ringtone,
                                                note: note,
                                                imageName: imageName)
        } else {
            let newContact = Contact(name: name,
                                     surname: surname,
                                     phone: phone,
                                     ringtone: ringtone,
                                     note: note,
                                     imageName: imageName)
            DataBaseManager.addNewContact(contact: newContact)
        }
    }
    
    func deleteContact() {
        guard let contact = contact else {
            return
        }
        DataBaseManager.deleteContact(contact: contact)
    }
}

extension ContactDetailsViewModel {
    
    var isNewContact: Bool {
        return contact == nil
    }
    
    var contactName: String? {
        return contact?.name
    }
    
    var contactSurname: String? {
        return contact?.surname
    }
    
    var contactPhone: String? {
        return contact?.phone
    }
    
    var contactRingtone: String? {
        return contact?.ringtone
    }
    
    var contactNote: String? {
        return contact?.note
    }
    
    var viewTitle: String {
        guard let contact = contact else {
            return Constants.defaultContactDetailsViewTitle
        }
        return contact.name
    }
    
    var contactImage: UIImage? {
        guard let imageName = contact?.imageName else {
            return placeholderImage
        }
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let path = path {
            let imagePath = path.appending("/" + imageName)
            return UIImage(named: imagePath)
        }
        print("ContactDetailsViewModel::contactImage: Cannot find path for loading image")
        return nil
    }
    
    var placeholderImage: UIImage? {
        return UIImage(named: Constants.placeholderImageName)
    }
}

fileprivate extension Constants {
    static let defaultContactDetailsViewTitle = "New Contact"    
    static let placeholderImageName = "Portrait_placeholder.png"
    
    static let requiredFieldsAreEmptyError = (domain: "contacts domain",
                                              code: 1,
                                              userInfo: [NSLocalizedDescriptionKey:
                                                "Required fields Name and Phone are not filled"])
}
