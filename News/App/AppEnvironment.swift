//
//  AppEnvironment.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//

import Foundation

enum AppEnvironment: String {
    case dev
    case qa
    case prod
}

struct Config {
    
    static var current: Config {
        return Config()
    }
    
    let environment: AppEnvironment
    let apiKey: String
    
    init(bundle: Bundle = .main) {
        let envString = bundle.object(forInfoDictionaryKey: "APP_ENV") as? String ?? "dev"
        self.environment = AppEnvironment(rawValue: envString) ?? .dev
        
        self.apiKey = bundle.object(forInfoDictionaryKey: "NEWS_API_KEY") as? String ?? ""
    }
}
