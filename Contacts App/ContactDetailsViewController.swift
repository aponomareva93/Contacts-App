//
//  AddContactViewController.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

protocol ContactDetailsViewControllerDelegate: class {
    func contactDetailsViewControllerDidTapClose(_ contactDetailsViewController: ContactDetailsViewController)
}

class ContactDetailsViewController: UIViewController {

    public weak var delegate: ContactDetailsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)        
        self.title = "Contact"
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
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
