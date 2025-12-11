// Presentation/Coordinators/BaseCoordinator.swift
import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() {
        // override in subclass
    }
}