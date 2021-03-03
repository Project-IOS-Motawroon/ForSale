
import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuth
import MOLH
import FTToastIndicator

class VerficationCodeVC: UIViewController {
    
    var phone = ""
    var code = ""
    var phone_code = ""
    var status_code = 0
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    var timer:Timer?
    var startTime = 60.0
    
    
    @IBOutlet weak var verificationcodeTF: UITextField!
    
    @IBOutlet weak var timeButton: UIButton!
    
    
    @IBOutlet var checkButton: UIButton!
    

    
     override func viewWillAppear(_ animated: Bool) {
         checkButton.roundCorners(cornerRadius: 20.0)
              timeButton.isUserInteractionEnabled = false
               timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
         }
    //<... 00:00
    @objc func onTimerFires(){
              timeButton.isUserInteractionEnabled = false
              startTime -= 1.0
              timeButton.setTitle("00 : \(Int(startTime))", for: .normal)
              if startTime <= 0.0  {
                  timeButton.setTitle("Resend code".localized(), for: .normal)
                  timeButton.isUserInteractionEnabled = true
                  if let tt = timer {
                  tt.invalidate()
                  }
                  timer = nil

              }
          }
//<..
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 12.0, *) {
            verificationcodeTF.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        verificationcodeTF.becomeFirstResponder()
    }
    //<..
//    func didChangeValidity(isValid: Bool) {
//    }
    


    @IBAction func checkBTN(_ sender: Any) {
        let verificationCode  = verificationcodeTF.text!
        if verificationCode.isEmpty {
            self.showNoti("Enter Verification Code".localized())
        }else if verificationCode.count != 6 {
            self.showNoti("Invalid Verification Code".localized())
        }else {
            BGLoading.instance.showLoading(view)
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID ?? "",
                verificationCode: verificationCode)

            Auth.auth().signIn(with: credential) { (authResult, error) in
               BGLoading.instance.dismissLoading()
                if let error = error {
                    FTToastIndicator.setToastIndicatorStyle(.dark)
                    FTToastIndicator.showToastMessage(error.localizedDescription)
                    return
                }
                if self.status_code == 200{
                    print("success to login")
                    UserDefaults.standard.set(true, forKey: "is_login")
                    let vc = UIStoryboard(name: "Main", bundle: nil)
                    let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
                    self.present(rootVc, animated: true, completion: nil)
                }else{
                    self.performSegue(withIdentifier: "registerSegue", sender: self)
                    print("success to register")
                }

            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSegue" {
            let des = segue.destination as! CompleteProfileVC
            des.phone_code = self.phone_code
            des.phone = phone
        }
    }
    
    
    @IBAction func timeBTN(_ sender: Any) {
        setPhone()
    }
    //<.....
    func setPhone(){
        let phoneNumber = phone_code + phone
        BGLoading.instance.showLoading(view)
        print("phone \(phoneNumber)")
        Auth.auth().settings!.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            BGLoading.instance.dismissLoading()
            if let error = error {
                self.showNoti_without_Localization(error.localizedDescription)
                return
            }
            self.startTime = 60.0
            self.timeButton.isUserInteractionEnabled = false
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.showNoti("We Sent To You an Sms Verification Code".localized())
        }
    }
}
