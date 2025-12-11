//
//  NetworkError.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/11/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case serverError(String)
    case unknown
}
