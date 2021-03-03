

import UIKit
import SwiftyJSON
import Alamofire
import FirebaseAuth
import FTToastIndicator
import MOLH

class LoginVC: UIViewController {
    
    var validPhoneNumber = false
    var phone:String?
    var code = ""
    var phone_code = ""
    var status_code = 0
    var status_code2 = 0

    @IBOutlet weak var phoneTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTF.cornerRadius = 0
        
    }
    


    @IBAction func LoginPress(_ sender: Any) {
        let PhoneNumber = phoneTF.text!
        
        if PhoneNumber.isEmpty {
            self.showNoti("enter phone".localized())
        }else{
            BGLoading.instance.show(view)
            phone_code = "+966"
            phone = phoneTF.text!

            Auth_API().login(phone: phone!, phone_code: phone_code) { (code, result) in
                BGLoading.instance.dismissLoading()
                self.status_code = code
                if code == 200{
                    if let data = result {
                        print("..........\(result)")
                        self.status_code2 = data["status"].intValue
                        if data["status"].stringValue == "200" {
                            print("code \(code)_1__________________________")
                                      self.setPhone()
                        }else if data["status"].stringValue == "404"{
                            self.showNoti(data["message"].stringValue)
                            print("code \(code)_2__________________________")
                                      self.setPhone()
                        }
                    }
                }else{
                    print("code \(code)_1____________________")
                    self.showNoti("try".localized())
                }

            }
        }
        
        
    }
    

    func setPhone(){
            let phoneNumber = phone_code + phone!
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    self.showNoti_without_Localization(error.localizedDescription)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.showNoti("We Sent To You an Sms Verification Code".localized())
                self.performSegue(withIdentifier: "verfysegue", sender: self)
            }
        }

    //To send data to other page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verfysegue" {
            let des = segue.destination as! VerficationCodeVC
            des.phone = phone!
            des.code = self.code
            des.status_code = self.status_code2
            des.phone_code = phone_code
        }


}

    
    @IBAction func skipButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeID")
        self.present(vc, animated: true, completion: nil)
    }
    
}
