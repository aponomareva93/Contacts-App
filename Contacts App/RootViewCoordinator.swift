//
//  RootViewCoordinator.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

typealias RootViewCoordinator = Coordinator & RootViewControllerProvider

protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController { get }
}
