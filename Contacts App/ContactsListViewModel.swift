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
    
    private var contacts = [Contact]()
    private var sections = [[Contact]]()
    let collation = UILocalizedIndexedCollation.current()
    
    var sectionsCount: Int {
        return sections.count
    }
    
    func numberOfContacts(in section: Int) -> Int {
        return sections[section].count
    }
    
    func contact(section: Int, row: Int) -> Contact? {
        if sections.indices.contains(section),
            sections[section].indices.contains(row) {
            return sections[section][row]
        }
        return nil
    }
        
    init() {
        refresh()
    }
    
    func refresh() {
        if let contacts = DataBaseManager.loadAllContacts() {
            self.contacts = contacts
            sortAlphabetically(data: contacts)
        } else {
            print("ContactsListViewModel::refresh: Cannot load contacts from DataBase")
        }
    }
    
    func sortAlphabetically(data: [Contact]) {
        let selector: Selector = #selector(Contact.fullName)
        sections = Array(repeating: [], count: collation.sectionTitles.count)
        let sortedData = collation.sortedArray(from: data, collationStringSelector: selector)
        for dataItem in sortedData {
            let sectionNumber = collation.section(for: dataItem, collationStringSelector: selector)
            if let contactDataItem = dataItem as? Contact {
                sections[sectionNumber].append(contactDataItem)
            } else {
                print("ContactsListViewModel::sortAlphabetically:cannot cast sorted data to Contact type")
            }
        }
    }
    
    func search(searchText: String) {
        let filteredData = searchText.isEmpty ? contacts : contacts.filter { (item: Contact) -> Bool in
            return item.fullName().range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        sortAlphabetically(data: filteredData)
    }
}
