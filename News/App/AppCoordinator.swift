// App/AppCoordinator.swift
import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private var rootNavigationController: UINavigationController?
    private var articlesCoordinator: ArticlesCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        self.rootNavigationController = navigationController
        
        let articlesCoordinator = ArticlesCoordinator(navigationController: navigationController)
        self.articlesCoordinator = articlesCoordinator
        articlesCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}