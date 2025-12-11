//
//  APIClientProtocol.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/11/25.
//
import Foundation
import RxSwift

protocol APIClientProtocol {
    func perform<T: Decodable>(_ request: URLRequest) -> Single<T>
}

final class APIClient: APIClientProtocol {
    
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func perform<T: Decodable>(_ request: URLRequest) -> Single<T> {
        return Single<T>.create { [weak self] single in
            let task = self?.urlSession.dataTask(with: request) { data, response, error in
                print("URL:", request)
                
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.failure(NetworkError.unknown))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    single(.failure(NetworkError.serverError(message)))
                    return
                }
                
                guard let data = data else {
                    single(.failure(NetworkError.unknown))
                    return
                }
                
                print("STATUS:", httpResponse.statusCode)
                print("RAW DATA:", String(data: data, encoding: .utf8) ?? "no body")
                
                do {
                    guard let decoder = self?.decoder else {
                        single(.failure(NetworkError.unknown))
                        return
                    }
                    let decoded = try decoder.decode(T.self, from: data)
                    single(.success(decoded))
                } catch {
                    single(.failure(NetworkError.decodingFailed))
                }
            }
            task?.resume()
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
