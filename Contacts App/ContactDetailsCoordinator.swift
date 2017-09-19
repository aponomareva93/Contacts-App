//
//  AddContactCoordinator.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
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
    
    func start() {
        let viewModel = ContactDetailsViewModel()
        let contactDetailsViewController = ContactDetailsViewController(viewModel: viewModel)
        contactDetailsViewController.delegate = self
        self.navigationController.viewControllers = [contactDetailsViewController]
    }
}

extension ContactDetailsCoordinator: ContactDetailsViewControllerDelegate {
    func contactDetailsViewControllerDidTapClose(_ contactDetailsViewController: ContactDetailsViewController) {
        self.delegate?.contactDetailsCoordinatorDidRequestCancel(contactDetailsCoordinator: self)
    }
}
