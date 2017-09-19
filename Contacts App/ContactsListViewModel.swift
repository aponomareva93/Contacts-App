//
//  ContactsListViewModel.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import RealmSwift

class ContactsListViewModel {
    
    var contacts = [Contact]()
    var sections = [[Contact]]()
    let collation = UILocalizedIndexedCollation.current()
        
    init() {
        refresh()
    }
    
    func refresh() {
        contacts = DataBase.loadAllContacts()
        
        let selector: Selector = Selector(("surname"))
        sections = Array(repeating: [], count: collation.sectionTitles.count)
        let sortedContacts = collation.sortedArray(from: contacts, collationStringSelector: selector)
        for contact in sortedContacts {
            let sectionNumber = collation.section(for: contact, collationStringSelector: selector)
            sections[sectionNumber].append(contact as! Contact)
        }
    }
}


