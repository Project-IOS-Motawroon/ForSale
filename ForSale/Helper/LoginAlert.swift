//
//  LoginAlert.swift
//  Emdad
//
//  Created by arab devolpers on 7/2/19.
//  Copyright © 2019 creative. All rights reserved.
//

import UIKit
extension UIViewController{
    func showAlertLogin(){
        
        let title = NSLocalizedString("notification", comment: "")
        let msg = NSLocalizedString("need_login", comment: "")
        let signin = NSLocalizedString("signin", comment: "")
        let cancel = NSLocalizedString("cancel", comment: "")
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: {action in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        
        alert.addAction(UIAlertAction(title: signin, style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
            
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let rootVc = vc.instantiateViewController(withIdentifier: "loginID")
            self.present(rootVc,animated: true,completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
}
