

import UIKit
import MOLH

class SelectLangVC: UIViewController {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var englishView: UIView!
    @IBOutlet weak var arabicView: UIView!
    var select = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Languge".localized()
    }

    @IBAction func arabicPress(_ sender: Any) {
        arabicView.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        englishView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        MOLH.setLanguageTo("ar")
        select = true

    }
    
    @IBAction func englishPress(_ sender: Any) {
        arabicView.layer.borderColor = #colorLiteral(red: 0.9802958369, green: 0.9804596305, blue: 0.98027426, alpha: 1)
        englishView.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        MOLH.setLanguageTo("en")
        select = true
        
    }
    
    
    
    @IBAction func nextPress(_ sender: Any) {
        if select == true{
            if #available(iOS 13, *){
                self.defaults.set(true, forKey: "languageSelected")

                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginID"), animated: true, completion: nil)

            }else{
                MOLH.reset(transition: .transitionCrossDissolve)
            }
        }else{
            showAlert(message: "حدد اللغة")
        }
       
    }
    
}
