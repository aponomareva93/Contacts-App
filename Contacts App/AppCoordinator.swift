//
//  AppCoordinator.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: RootViewCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    let window: UIWindow
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        //navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    public init(window: UIWindow) {
        self.window = window
        
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    public func start() {
        self.showContactsListViewController()
    }
    
    private func showContactsListViewController() {
        let contactsListViewController = ContactsListViewController()
        contactsListViewController.delegate = self
        self.navigationController.viewControllers = [contactsListViewController]
    }
    
}

extension AppCoordinator: ContactsListViewControllerDelegate {
    func contactsListViewControllerDidTapContact(contactsListViewController: ContactsListViewController) {
        //contactsListViewControllerDidTapAddContact(contactsListViewController: contactsListViewController)
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
