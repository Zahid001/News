//
//  BaseCoordinator.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//

import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() {
        // override in subclass
    }
}
