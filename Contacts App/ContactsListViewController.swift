//
//  ContactsListViewController.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {

    @IBOutlet private weak var contactsListTableView: UITableView!
    @IBOutlet private weak var searchContactsBar: UISearchBar!
    
    public weak var delegate: ContactsListViewControllerDelegate?
    
    lazy var addBarButtonItem: UIBarButtonItem = {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        return addBarButtonItem
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "All Contacts"
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtonTapped(sender: UIBarButtonItem) {
        delegate?.contactsListViewControllerDidTapContact(contactsListViewController: self)
    }
}

protocol ContactsListViewControllerDelegate: class {
    func contactsListViewControllerDidTapContact(contactsListViewController: ContactsListViewController)
}
