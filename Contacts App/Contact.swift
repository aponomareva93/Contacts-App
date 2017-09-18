//
//  Contact.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    dynamic var name = String()
    dynamic var surname = String()
    dynamic var phoneNumber = String()
    dynamic var ringtoneName = String()
    dynamic var note: String?
    
    /*init(name: String, surname: String, telephoneNumber: String, ringtoneName: String, note: String?) {
        self.name = name
        self.surname = surname
        self.telephoneNumber = telephoneNumber
        self.ringtoneName = ringtoneName
        self.note = note
    }*/
}
