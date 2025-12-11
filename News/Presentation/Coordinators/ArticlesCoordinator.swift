//
//  ArticlesCoordinator.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//

import UIKit

final class ArticlesCoordinator: BaseCoordinator {
    
    private let router: Router
    private let repository: ArticlesRepository
    
    // Callback for parent (AppCoordinator) when this flow is “done”
    var onFinish: (() -> Void)?
    
    init(router: Router,
         repository: ArticlesRepository = NewsAPIArticlesRepository()) {
        self.router = router
        self.repository = repository
    }
    
    override func start() {
        let viewModel = ArticlesListViewModel(repository: repository)
        let listVC = ArticlesListViewController(viewModel: viewModel)
        
        viewModel.onArticleSelected = { [weak self] article in
            self?.showArticleDetail(article)
        }
        
        // This sets the root of the navigation stack for this flow
        router.setRoot(listVC, hideBar: false)
    }
    
    private func showArticleDetail(_ article: Article) {
        let detailVC = ArticleDetailViewController(article: article)
        router.push(detailVC, animated: true)
    }
    
    // Example: if you want to close this entire flow:
    func finish() {
        router.popToRoot(animated: true)
        onFinish?()
    }
}
