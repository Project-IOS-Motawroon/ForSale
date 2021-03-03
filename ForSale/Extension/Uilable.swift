//
//  Uilable.swift
//  Construction Stock
//
//  Created by Mac on 8/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit
extension UILabel{
    func setBorder(){
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.5
    }
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
    func circlelable(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
