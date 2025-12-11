//
//  AppCoordinator.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    private let router: Router
    
    private var articlesCoordinator: ArticlesCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        let navController = UINavigationController()
        self.router = NavigationRouter(navigationController: navController)
        super.init()
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    override func start() {
        showArticlesFlow()
    }
    
    // MARK: - Flows
    
    private func showArticlesFlow() {
        let articlesCoordinator = ArticlesCoordinator(router: router)
        self.articlesCoordinator = articlesCoordinator
        addChild(articlesCoordinator)
        
        articlesCoordinator.onFinish = { [weak self, weak articlesCoordinator] in
            if let articlesCoordinator = articlesCoordinator {
                self?.removeChild(articlesCoordinator)
            }
        }
        
        articlesCoordinator.start()
    }
    
    // Example if you later want to reset root (e.g., after logout)
    func resetToRoot() {
        router.popToRoot(animated: false)
    }
}
