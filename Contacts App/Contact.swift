//
//  Contact.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import RealmSwift
import Realm

class Contact: Object {
    dynamic var name = String()
    dynamic var surname: String?
    dynamic var phone = String()
    dynamic var ringtone: String?
    dynamic var note: String?
    dynamic var imageName: String?
    
    init(name: String, surname: String?, phone: String, ringtone: String?, note: String?, imageName: String?) {
        self.name = name
        self.surname = surname
        self.phone = phone
        self.note = note
        self.ringtone = ringtone
        self.imageName = imageName
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
        guard let surname = self.surname else {
            return String(name)
        }
        return String(surname + " " + name)
    }
}
