//
//  Contact.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Contact: Object {
    dynamic var name = String()
    dynamic var surname = String()
    dynamic var phoneNumber = String()
    dynamic var note: String?
    
    init(name: String, surname: String, phoneNumber: String, note: String?) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.note = note
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}


extension Contact {
    func fullName() -> String {
        return String(surname + " " + name)
    }
}
