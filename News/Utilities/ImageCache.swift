//
//  ImageCache.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//


// Presentation/Views/ImageCache.swift
import UIKit

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "news.image.cache", qos: .userInitiated)
    
    private init() {}
    
    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString as NSString
        
        if let cached = cache.object(forKey: key) {
            completion(cached)
            return
        }
        
        queue.async {
            let data = try? Data(contentsOf: url)
            let image = data.flatMap(UIImage.init)
            
            if let image = image {
                self.cache.setObject(image, forKey: key)
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}