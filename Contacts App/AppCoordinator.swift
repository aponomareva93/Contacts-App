//
//  AppCoordinator.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class AppCoordinator: RootViewCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    private let window: UIWindow
    
    private lazy var navigationController: UINavigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
        
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        self.showContactsListViewController()
    }
    
    private func showContactsListViewController() {
        let viewModel = ContactsListViewModel()
        let contactsListViewController = ContactsListViewController(viewModel: viewModel)
        contactsListViewController.delegate = self
        self.navigationController.viewControllers = [contactsListViewController]
    }
    
}

extension AppCoordinator: ContactsListViewControllerDelegate {
    func contactsListViewControllerDidTapContact(contactsListViewController: ContactsListViewController, contact: Contact?) {
        let contactDeatilsCoordinator = ContactDetailsCoordinator()
        contactDeatilsCoordinator.delegate = self
        contactDeatilsCoordinator.start(with: contact)
        self.addChildCoordinator(contactDeatilsCoordinator)
        self.rootViewController.present(contactDeatilsCoordinator.rootViewController, animated: true, completion: nil)
    }
    
    func contactsListViewControllerDidTapAddContact(contactsListViewController: ContactsListViewController) {
        let contactDeatilsCoordinator = ContactDetailsCoordinator()
        contactDeatilsCoordinator.delegate = self
        contactDeatilsCoordinator.start()
        self.addChildCoordinator(contactDeatilsCoordinator)
        self.rootViewController.present(contactDeatilsCoordinator.rootViewController, animated: true, completion: nil)
    }
}

extension AppCoordinator: ContactDetailsCoordinatorDelegate {
    func contactDetailsCoordinatorDidRequestCancel(contactDetailsCoordinator: ContactDetailsCoordinator) {
        contactDetailsCoordinator.rootViewController.dismiss(animated: true)
        self.removeChildCoordinator(contactDetailsCoordinator)
    }
}
