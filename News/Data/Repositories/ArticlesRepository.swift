//
//  ArticlesRepository.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/11/25.
//

import RxSwift

protocol ArticlesRepository {
    func fetchArticles() -> Single<[Article]>
}
