//
//  ImageCaching.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import UIKit

class ImageCaching {
    
    static func cacheImage(url: String, image: UIImage) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let pathURL = URL(fileURLWithPath: path)
        let data =  image.jpegData(compressionQuality: 0.5)
        try? data?.write(to: pathURL)
        var dictionary = UserDefaults.standard.object(forKey: "ImageCache") as? [String: String]
        if dictionary == nil {
            dictionary = [String: String]()
        }
        dictionary![url] = path
        UserDefaults.standard.set(dictionary, forKey: "ImageCache")
    }
    
    
    static func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let dictionary = UserDefaults.standard.object(forKey: "ImageCache") as? [String: String] {
            if let path = dictionary[url] {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
            
        }

        
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    guard let image = UIImage(data: data) else { return }
                    completion(image)
                }
            }
            }.resume()
    }
    
}
