//
//  ContactsListViewController.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {

    @IBOutlet fileprivate weak var contactsListTableView: UITableView!
    @IBOutlet private weak var searchContactsBar: UISearchBar!
    
    weak var delegate: ContactsListViewControllerDelegate?
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(addButtonTapped))
        return addBarButtonItem
    }()
    
    fileprivate var viewModel: ContactsListViewModel
        
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsListTableView?.dataSource = self
        contactsListTableView?.delegate = self
        contactsListTableView?.register(ContactTableViewCell.self,
                                        forCellReuseIdentifier: Constants.contactsListTableCellIdentifier)
        searchContactsBar?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.refresh()
        contactsListTableView?.reloadData()
    }
    
    init(viewModel: ContactsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = Constants.contactsListTableTitle
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtonTapped(sender: UIBarButtonItem) {
        delegate?.contactsListViewControllerDidTapAddContact(contactsListViewController: self)
    }
}

protocol ContactsListViewControllerDelegate: class {
    func contactsListViewControllerDidTapAddContact(contactsListViewController: ContactsListViewController)
    func contactsListViewControllerDidTapContact(contactsListViewController: ContactsListViewController, contact: Contact)
}

extension ContactsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            Constants.contactsListTableCellIdentifier, for: indexPath) as? ContactTableViewCell {
            cell.setup(viewModel: ContactCellModel(with: viewModel.sections[indexPath.section][indexPath.row]))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel.sections[section].isEmpty {
            return nil
        }
        return viewModel.collation.sectionTitles[section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String] {
        return viewModel.collation.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.collation.section(forSectionIndexTitle: index)
    }
}

extension ContactsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.contactsListViewControllerDidTapContact(contactsListViewController: self,
                                                          contact: viewModel.sections[indexPath.section][indexPath.row])
    }
}

extension ContactsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText)
        self.contactsListTableView.reloadData()
    }
}

extension Constants {
    static let contactsListTableCellIdentifier = "ContactCell"
    static let contactsListTableTitle = "All Contacts"
}
