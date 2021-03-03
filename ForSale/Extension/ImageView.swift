//
//  ImageView.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/27/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
extension UIImageView{
    func circleImage(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(hexString: "#E5E7E9").cgColor
        self.layer.borderWidth = 1.5
    }
    
    
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(hexString: "#E5E7E9").cgColor
        
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
  func setImage(from url: String) {
          guard let imageURL = URL(string: url) else { return }
       
          self.sd_setImage(with: imageURL,placeholderImage: UIImage(named: "placeholder"),options: .progressiveLoad)
    
    }
}
