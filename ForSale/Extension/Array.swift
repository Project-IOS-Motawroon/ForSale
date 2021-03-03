//
//  Array.swift
//  Ghier
//
//  Created by endpoint on 3/8/20.
//  Copyright © 2020 endpoint. All rights reserved.
//

import Foundation
import UIKit
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
