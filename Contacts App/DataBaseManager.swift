//
//  DataBaseManager.swift
//  Contacts App
//
//  Created by anna on 19.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseManager {
    private static let realm = try! Realm()
    
    class func loadAllContacts() -> [Contact] {
        let contacts = realm.objects(Contact.self).toArray()
        return contacts
    }
    
    class func addNewContact(contact: Contact) {
        try! realm.write {
            realm.add(contact)
        }
    }
    
    class func editExistingContact(contact: Contact, name: String, surname: String?, phone: String, ringtone: String?, note: String?, imageName: String?) {
        try! realm.write {
            contact.name = name
            contact.surname = surname
            contact.phone = phone
            contact.note = note
            contact.ringtone = ringtone
            contact.imageName = imageName
        }
    }
    
    class func deleteContact(contact: Contact) {
        try! realm.write {
            realm.delete(contact)
        }
    }
}

extension Results {
    func toArray() -> [T] {
        return self.map{$0}
    }
}
