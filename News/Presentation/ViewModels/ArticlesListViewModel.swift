//
//  ArticleCellViewModel.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

struct ArticleCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    let dateText: String
}

final class ArticlesListViewModel {
    
    // Inputs
    let reloadTrigger = PublishRelay<Void>()
    let selection = PublishRelay<IndexPath>()
    
    // Outputs
    let articles: Driver<[ArticleCellViewModel]>
    let isLoading: Driver<Bool>
    let errorMessage: Driver<String?>
    
    // Coordinator callback
    var onArticleSelected: ((Article) -> Void)?
    
    private let repository: ArticlesRepository
    private let disposeBag = DisposeBag()
    
    private let articlesSubject = BehaviorRelay<[Article]>(value: [])
    private let loadingSubject = BehaviorRelay<Bool>(value: false)
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    
    init(repository: ArticlesRepository) {
        self.repository = repository
        
        self.articles = articlesSubject
            .map { articles in
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                
                return articles.map { article in
                    let dateText = article.publishedAt.map { formatter.string(from: $0) } ?? ""
                    let subtitle = article.source?.name ?? "Unknown Source"
                    let url = article.urlToImage.flatMap(URL.init(string:))
                    
                    return ArticleCellViewModel(
                        title: article.title ?? "No title",
                        subtitle: subtitle,
                        imageURL: url,
                        dateText: dateText
                    )
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        self.isLoading = loadingSubject.asDriver()
        self.errorMessage = errorSubject.asDriver()
        
        bindInputs()
    }
    
    private func bindInputs() {
        reloadTrigger
            .subscribe(onNext: { [weak self] in
                self?.fetchArticles()
            })
            .disposed(by: disposeBag)
        
        selection
            .withLatestFrom(articlesSubject) { indexPath, articles in
                return articles[indexPath.row]
            }
            .subscribe(onNext: { [weak self] article in
                self?.onArticleSelected?(article)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchArticles() {
        loadingSubject.accept(true)
        errorSubject.accept(nil)
        
        repository.fetchArticles()
            .subscribe(onSuccess: { [weak self] articles in
                self?.loadingSubject.accept(false)
                self?.articlesSubject.accept(articles)
            }, onFailure: { [weak self] error in
                self?.loadingSubject.accept(false)
                self?.errorSubject.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
