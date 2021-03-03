//
//  UITextView.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/28/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import Foundation
import UIKit
extension UITextView{
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#E5E7E9").cgColor
    }
    
}
