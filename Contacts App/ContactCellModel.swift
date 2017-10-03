//
//  ContactCellModel.swift
//  Contacts App
//
//  Created by anna on 19.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

class ContactCellModel {
    let contactFullName: String
    
    init(with contact: Contact?) {
        if let contact = contact {
            self.contactFullName = contact.fullName()
        } else {
            contactFullName = String()
        }
    }
}
