//
//  ContactDetailsCoordinator.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

protocol ContactDetailsCoordinatorDelegate: class {
    func contactDetailsCoordinatorDidRequestCancel(contactDetailsCoordinator: ContactDetailsCoordinator)
}

class ContactDetailsCoordinator: RootViewCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    weak var delegate: ContactDetailsCoordinatorDelegate?
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    func start(with contact: Contact? = nil) {
        let viewModel = ContactDetailsViewModel(contact: contact)
        let contactDetailsViewController = ContactDetailsViewController(viewModel: viewModel)
        contactDetailsViewController.delegate = self
        self.navigationController.viewControllers = [contactDetailsViewController]
    }
}

extension ContactDetailsCoordinator: ContactDetailsViewControllerDelegate {
    func contactDetailsViewControllerDidTapClose(_ contactDetailsViewController: ContactDetailsViewController?) {
        self.delegate?.contactDetailsCoordinatorDidRequestCancel(contactDetailsCoordinator: self)
    }
}
