//
//  String.swift
//  Emdad
//
//  Created by arab devolpers on 6/10/19.
//  Copyright © 2019 creative. All rights reserved.
//

import Foundation
extension String{
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func toFloat() -> Float? {
        return NumberFormatter().number(from: self)?.floatValue
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func englishNumbers() -> String? {
        let oldCount = self.count
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: "EN")
        
        if let final = formatter.number(from: self) {
            let newCount = "\(final)".count
            let differ = oldCount - newCount
            if differ == 0 {
                return "\(final)"
            } else {
                var outFinal = "\(final)"
                for _ in 1...differ {
                    outFinal = "0" + outFinal
                }
                return outFinal
            }
        } else {
            return nil
        }
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
