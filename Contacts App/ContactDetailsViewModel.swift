//
//  AddContactViewModel.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

class ContactDetailsViewModel {
    var contact: Contact?
    
    init(contact: Contact? = nil) {
        self.contact = contact
    }
    
    func saveContact(name: String?, surname: String?, phoneNumber: String?, note: String?) throws {
        guard let contactName = name,
            let contactSurname = surname,
            let contactPhone = phoneNumber
        else {
            let error = NSError(domain: "contacts domain", code: 1, userInfo: [NSLocalizedDescriptionKey:
                "Required fields are not filled"])
            throw error
        }
        if let existingContact = contact {
            DataBase.editExistingContact(contact: existingContact, name: contactName, surname: contactSurname, phoneNumber: contactPhone, note: note)            
        } else {
            let newContact = Contact(name: contactName, surname: contactSurname, phoneNumber: contactPhone, note: note)
            DataBase.addNewContact(contact: newContact)
        }
    }
    
    func deleteContact() {
        guard let contact = contact else {
            return
        }
        DataBase.deleteContact(contact: contact)
    }
}

