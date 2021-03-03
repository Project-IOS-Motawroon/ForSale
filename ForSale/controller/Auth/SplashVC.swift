

import UIKit

class SplashVC: UIViewController {
    let dev = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dev.bool(forKey: "is_login"){
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeID")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            if dev.bool(forKey: "languageSelected"){
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginID")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "languageID")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
        }
    }
}
