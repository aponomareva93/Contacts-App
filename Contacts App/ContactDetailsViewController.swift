//
//  AddContactViewController.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Eureka

protocol ContactDetailsViewControllerDelegate: class {
    func contactDetailsViewControllerDidTapClose(_ contactDetailsViewController: ContactDetailsViewController)
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
        
        form +++ Section("Contact Details")
            <<< TextRow(){ row in
                row.title = "Name"
            }
            <<< TextRow(){ row in
                row.title = "Surname"
            }
            <<< PhoneRow(){ row in
                row.title = "Phone Number"
            }
            <<< TextRow(){ row in
                row.title = "Ringtone"
            }
            <<< TextAreaRow(){ row in
                row.placeholder = "Note"
            }
            <<< ButtonRow() { button in
                button.title = "Delete Contact"
                }
                .cellUpdate({ cell, row in
                    cell.textLabel?.textColor = .red
                })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        return cancelBarButtonItem
    }()
    
    func cancelButtonTapped(sender: UIBarButtonItem) {
        delegate?.contactDetailsViewControllerDidTapClose(self)
    }
}
