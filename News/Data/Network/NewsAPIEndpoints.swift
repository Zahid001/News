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
        let apiKey = "f23a88e56e0245b69da3b9c6507a8e48" //Config.current.apiKey
        let fromDate = "2025-06-20"
        let baseURLString =
        "https://newsapi.org/v2/everything?q=apple&from=\(fromDate)&sortBy=publishedAt&apiKey=\(apiKey)"
        
        guard let url = URL(string: baseURLString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
