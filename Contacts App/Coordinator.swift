//
//  Coordinator.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

public protocol Coordinator: class {
    
    /// The services that the coordinator can use
    //var services: Services { get }
    
    var childCoordinators: [Coordinator] { get set }
    
}

public extension Coordinator {
    public func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    public func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
    
}
