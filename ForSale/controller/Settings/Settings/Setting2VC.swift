

import UIKit

class Setting2VC: UIViewController {
    var linkFacebook:String?
    var linkGoogle:String?
    var linkinstagram:String?
    var linktwitter:String?
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
//        BGLoading.instance.show(view)
        Get_Setting_API.instance.settings { (code, result) in
//           BGLoading.instance.dismissLoading()
            if let data = result{
                self.linkFacebook = data["facebook"].stringValue
                self.linkGoogle = data["google_plus"].stringValue
                self.linkinstagram = data["instagram"].stringValue
                self.linktwitter = data["twitter"].stringValue

            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func TermsAndConditionPress(_ sender: Any) {
        performSegue(withIdentifier: "TeemsAndConditionSegue", sender: self)
    }
    
    @IBAction func AboutAppPress(_ sender: Any) {
        performSegue(withIdentifier: "AboutAppSegue", sender: self)
    }
    
    

    
    
    
    @IBAction func facebookPress(_ sender: Any) {
        if let url = URL(string: "\(linkFacebook ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func googlePress(_ sender: Any) {
        if let url = URL(string: "\(linkGoogle ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func instagramPress(_ sender: Any) {
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
    
    
    
    
    @IBAction func languagePress(_ sender: Any) {
        performSegue(withIdentifier: "LanguageSegue", sender: self)
    }
    
}
