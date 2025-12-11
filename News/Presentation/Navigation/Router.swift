//
//  Router.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//

import UIKit

protocol Router {
    var navigationController: UINavigationController { get }
    
    func setRoot(_ viewController: UIViewController, hideBar: Bool)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
}
