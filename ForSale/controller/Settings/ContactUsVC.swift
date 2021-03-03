//
//  ContactUsVC.swift
//  ForSale
//
//  Created by Moustafa on 10/18/20.
//

import UIKit

class ContactUsVC: UIViewController {
    var linkFacebook:String?
    var linkGoogle:String?
    var linkinstagram:String?
    var linktwitter:String?
    
    
    @IBOutlet weak var LogoImg: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var whatsLabel: UILabel!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        BGLoading.instance.show(view)
        Get_Setting_API.instance.settings { (code, result) in
           BGLoading.instance.dismissLoading()
            if let data = result{
                print("mmmmm\(data)")
                self.linkFacebook = data["facebook"].stringValue
                self.linkGoogle = data["google_plus"].stringValue
                self.linkinstagram = data["instagram"].stringValue
                self.linktwitter = data["twitter"].stringValue
                self.phoneLabel.text = data["phone1"].stringValue
                self.whatsLabel.text = data["whatsapp"].stringValue
                self.emailLabel.text = data["email1"].stringValue

            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        LogoImg.circleImage()
        LogoImg.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)

    }

    @IBAction func facebookPress(_ sender: Any) {
        if let url = URL(string: "\(linkFacebook ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func googlePlasPress(_ sender: Any) {
        if let url = URL(string: "\(linkGoogle ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func instaPress(_ sender: Any) {
        if let url = URL(string: "\(linkinstagram ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func twitterPress(_ sender: Any) {
            if let url = URL(string: "\(linktwitter ?? "")") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
    }
    
    
    
    @IBAction func whatsAppPress(_ sender: Any) {
        self.openWhatsApp(whatsLabel.text!)

    }
    
    
    @IBAction func phonePress(_ sender: Any) {        
        if let url = URL(string: "tel://\(phoneLabel.text!)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
    
    @IBAction func chat_with_admin_Prss(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "is_login"){
            performSegue(withIdentifier: "chatWithAdminSegue", sender: self)
               }else{
                   self.loginAlert()
               }
    }
}
