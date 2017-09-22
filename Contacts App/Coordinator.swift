//
//  Coordinator.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }    
}

extension Coordinator {
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
    
}
