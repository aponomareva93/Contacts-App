//
//  DataBaseManager.swift
//  Contacts App
//
//  Created by anna on 19.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import RealmSwift

class DataBaseManager {
    private static let realm: Realm? = try? Realm()
    
    class func loadAllContacts() -> [Contact]? {
        if let realm = realm {
            let contacts = realm.objects(Contact.self).toArray()
            return contacts
        } else {
            print("DataBaseManager:Realm() init error")
            return nil
        }
    }
    
    class func addNewContact(contact: Contact) {
        if let realm = realm {
            do {
                try realm.write {
                    realm.add(contact)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Realm() init error")
        }
    }
    
    class func editExistingContact(contact: Contact,
                                   name: String,
                                   surname: String?,
                                   phone: String,
                                   ringtone: String?,
                                   note: String?,
                                   imageName: String?) {
        if let realm = realm {
            do {
                try realm.write {
                    contact.name = name
                    contact.surname = surname
                    contact.phone = phone
                    contact.note = note
                    contact.ringtone = ringtone
                    contact.imageName = imageName
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Realm() init error")
        }
    }
    
    class func deleteContact(contact: Contact) {
        if let realm = realm {
            do {
                try realm.write {
                    realm.delete(contact)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Realm() init error")
        }
    }
}

extension Results {
    func toArray() -> [T] {
        return self.map {$0}
    }
}
