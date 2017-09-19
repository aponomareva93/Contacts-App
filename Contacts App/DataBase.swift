//
//  DataBase.swift
//  Contacts App
//
//  Created by anna on 19.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import RealmSwift

class DataBase {
    class func loadAllContacts() -> [Contact] {
        let realm = try! Realm()
        let contacts = realm.objects(Contact.self).toArray()
        return contacts
    }
    
    class func addNewContact(contact: Contact) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(contact)
        }
    }
    
    class func editExistingContact(contact: Contact, name: String, surname: String, phoneNumber: String, note: String?) {
        let realm = try! Realm()
        try! realm.write {
            contact.name = name
            contact.surname = surname
            contact.phoneNumber = phoneNumber
            contact.note = note
        }
    }
    
    class func deleteContact(contact: Contact) {
        let realm = try! Realm()
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
