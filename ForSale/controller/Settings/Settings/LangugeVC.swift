//
//  LangugeVC.swift
//  Lamah
//
//  Created by Moustafa on 11/22/20.
//

import UIKit
import MOLH

class LangugeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Languge".localized()
    }
    
    @IBAction func arabic_btn(_ sender: Any) {
        MOLH.setLanguageTo("ar")
        self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeID"), animated: true, completion: nil)
//          if #available(iOS 13, *){
//            print("arara")
//              let delegate = UIApplication.shared.delegate as? AppDelegate
//              delegate?.switchRoot()
//          }else{
//              MOLH.reset(transition: .transitionCrossDissolve)
//          }
    }
    @IBAction func english_btn(_ sender: Any) {
        MOLH.setLanguageTo("en")
        self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeID"), animated: true, completion: nil)
//        print("enenen")
//          if #available(iOS 13, *){
//              let delegate = UIApplication.shared.delegate as? AppDelegate
//              delegate?.switchRoot()
//          }else{
//              MOLH.reset(transition: .transitionCrossDissolve)
//          }
    }
}
