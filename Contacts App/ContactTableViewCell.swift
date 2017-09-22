//
//  ContactTableViewCell.swift
//  Contacts App
//
//  Created by anna on 19.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {    
    func setup(viewModel: ContactCellModel) {
        textLabel?.text = viewModel.contactFullName
    }
}
