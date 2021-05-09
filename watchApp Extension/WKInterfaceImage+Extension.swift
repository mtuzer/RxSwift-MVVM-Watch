//
//  WKInterfaceImage+Extension.swift
//  watchApp Extension
//
//  Created by Mert Tuzer on 9.05.2021.
//

import WatchKit

public extension WKInterfaceImage {
    @discardableResult func setImageWithUrl(url:String, scale: CGFloat = 1.0) -> WKInterfaceImage? {
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        session.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            if (data != nil && error == nil) {
                
                let image = UIImage(data: data!, scale: scale)
                
                DispatchQueue.main.async {
                    self.setImage(image)
                }
            }
        }.resume()
        
        return self
    }
}
