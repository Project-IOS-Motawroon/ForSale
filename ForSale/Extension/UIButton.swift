//
//  UIButton.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/27/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
extension UIButton{
    
    func loadingIndicator(_ show: Bool,_ color:UIColor) {
        let tag = 808404
        if show {
            self.isEnabled = false
            //self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.sizeThatFits(CGSize(width: buttonWidth, height: buttonHeight))
            indicator.tag = tag
            indicator.color = color
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
    func setBorder(){
        self.layer.borderColor = UIColor().colorfromHex("E5E7E9").cgColor
        self.layer.borderWidth = 2.0
    }
    func roundCornersWithBorder(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(hexString: "#E5E7E9").cgColor
        self.layer.borderWidth = 1.0
    }
    
}
