//
//  ArticlesCoordinator.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//


// Presentation/Coordinators/ArticlesCoordinator.swift
import UIKit

final class ArticlesCoordinator {
    
    private let navigationController: UINavigationController
    private let repository: ArticlesRepository
    
    init(navigationController: UINavigationController,
         repository: ArticlesRepository = NewsAPIArticlesRepository()) {
        self.navigationController = navigationController
        self.repository = repository
    }
    
    func start() {
        let viewModel = ArticlesListViewModel(repository: repository)
        let listVC = ArticlesListViewController(viewModel: viewModel)
        
        viewModel.onArticleSelected = { [weak self] article in
            self?.showArticleDetail(article)
        }
        
        navigationController.pushViewController(listVC, animated: false)
    }
    
    private func showArticleDetail(_ article: Article) {
        let detailVC = ArticleDetailViewController(article: article)
        navigationController.pushViewController(detailVC, animated: true)
    }
}