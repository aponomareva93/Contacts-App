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
        contacts = DataBaseManager.loadAllContacts()
        sortAlphabetically(data: contacts)
    }
    
    func sortAlphabetically(data: [Contact]) {
        let selector: Selector = Selector(("fullName"))
        sections = Array(repeating: [], count: collation.sectionTitles.count)
        let sortedData = collation.sortedArray(from: data, collationStringSelector: selector)
        for dataItem in sortedData {
            let sectionNumber = collation.section(for: dataItem, collationStringSelector: selector)
            sections[sectionNumber].append(dataItem as! Contact)
        }
    }
    
    func search(searchText: String) {
        let filteredData = searchText.isEmpty ? contacts : contacts.filter { (item: Contact) -> Bool in
            return item.fullName().range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        sortAlphabetically(data: filteredData)
    }
}


