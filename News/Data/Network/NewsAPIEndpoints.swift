//
//  NewsAPIEndpoints.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/11/25.
//

import Foundation

enum NewsAPIEndpoints {
    case allAppleNews
    
    var urlRequest: URLRequest? {
        let apiKey = Config.current.apiKey
        let fromDate = "2025-11-20"
        let baseURLString =
        "https://newsapi.org/v2/everything?q=apple&from=\(fromDate)&sortBy=publishedAt&apiKey=\(apiKey)"
        
        guard let url = URL(string: baseURLString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
