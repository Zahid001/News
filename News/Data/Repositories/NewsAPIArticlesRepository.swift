//
//  NewsAPIArticlesRepository.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/11/25.
//

import RxSwift

final class NewsAPIArticlesRepository: ArticlesRepository {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchArticles() -> Single<[Article]> {
        guard let request = NewsAPIEndpoints.allAppleNews.urlRequest else {
            return Single.error(NetworkError.invalidURL)
        }
        
        return apiClient.perform( request )
            .map { (response: NewsResponse) in
                response.articles
            }
    }
}
