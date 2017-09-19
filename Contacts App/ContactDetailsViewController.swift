//
//  AddContactViewController.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Eureka

protocol ContactDetailsViewControllerDelegate: class {
    func contactDetailsViewControllerDidTapClose(_ contactDetailsViewController: ContactDetailsViewController?)
}

class ContactDetailsViewController: FormViewController {

    weak var delegate: ContactDetailsViewControllerDelegate?
    
    private var viewModel: ContactDetailsViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: ContactDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Contact"
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        
        form +++ Section("Contact Details")
            <<< TextRow(){ row in
                row.title = "Name"
                row.tag = "NameRow"
                row.value = self.viewModel.contact?.name
            }
            <<< TextRow(){ row in
                row.title = "Surname"
                row.tag = "SurnameRow"
                row.value = self.viewModel.contact?.surname
            }
            <<< PhoneRow(){ row in
                row.title = "Phone Number"
                row.tag = "PhoneRow"
                row.value = self.viewModel.contact?.phoneNumber
            }
            <<< TextAreaRow(){ row in
                row.placeholder = "Note"
                row.tag = "NoteRow"
                row.value = self.viewModel.contact?.note
            }
        if self.viewModel.contact != nil {
            form +++ ButtonRow() { button in
                button.title = "Delete Contact"
                button.tag = "DeleteButton"
                button.onCellSelection(deleteButtonTapped)
                }
                .cellUpdate({ cell, row in
                    cell.textLabel?.textColor = .red
                })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        return cancelBarButtonItem
    }()
    
    lazy var saveBarButtonItem: UIBarButtonItem = {
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        return saveBarButtonItem
    }()
    
    func cancelButtonTapped(sender: UIBarButtonItem) {
        delegate?.contactDetailsViewControllerDidTapClose(self)
    }
    
    func saveButtonTapped(sender: UIBarButtonItem) {
        let layouts = form.values()
        do {
            try viewModel.saveContact(name: layouts["NameRow"] as? String, surname: layouts["SurnameRow"] as? String, phoneNumber: layouts["PhoneRow"] as? String, note: layouts["NoteRow"] as? String)
            showAlert(withTitle: "Success", message: "Contact saved", okButtonTapped: { [weak self] in
                self?.delegate?.contactDetailsViewControllerDidTapClose(self)
            })
        } catch {
            showAlert(withTitle: "Error", message: error.localizedDescription)
        }
    }
    
    func deleteButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        let alert = UIAlertController(title: "Delete contact", message: "Do you really want to delete this contact?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.viewModel.deleteContact()
            self?.delegate?.contactDetailsViewControllerDidTapClose(self)
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, message: String, okButtonTapped: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okButtonTapped?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
