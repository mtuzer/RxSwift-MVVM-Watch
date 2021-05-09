//
//  UIImageView+Extension.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 8.05.2021.
//

import UIKit
import RxSwift

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageFromURLString(urlString: String) {
        if let image = imageCache.object(forKey: urlString as NSString) {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                return
            }
            DispatchQueue.main.async {
                let imageToBeCached = UIImage(data: data!)
                if let imageNotNil = imageToBeCached {
                    imageCache.setObject(imageNotNil, forKey: urlString as NSString)
                    self.image = imageNotNil
                } else {
                    self.image = nil
                }
            }
        }.resume()
    }
}
