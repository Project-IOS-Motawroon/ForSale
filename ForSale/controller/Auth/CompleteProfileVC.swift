//
//  CompleteProfileVC.swift
//  ForSale
//
//  Created by Moustafa on 10/13/20.
//

import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuth
import MOLH
import FTToastIndicator

class CompleteProfileVC: UIViewController,ImagePickerDelegate {
    var phone = ""
    var phone_code = ""
    var imagePicker: ImagePicker!
    var user_imageData:Data?
    var status_code2 = 0

    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var LogoImg: UIImageView!
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var LoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogoImg.circleImage()
        LogoImg.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)

        EditBtn.circleView()
        EditBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @IBAction func pickImg(_ sender: UIButton)  {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        LogoImg.image = image
        LogoImg.contentMode = .scaleAspectFit
        user_imageData = image.jpegData(compressionQuality: 0.7)!
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        
        let nam = nameTF.text!
        if nam.isEmpty {
            self.showNoti("Enter Your Name")
        }else{
            Auth_API().register(name: nam, phone: phone, phone_code: phone_code, logo: user_imageData) { (code, result) in
                if code == 200 {
                    if let data = result {
                        print("..........\(result)")
//                        self.status_code2 = data["status"].intValue
                        if data["status"].stringValue == "200" {
                            print("code \(code)_1__________________________")
                            self.showNoti("RegisteredSuccessfully")
                            //<...
                            let vc = UIStoryboard(name: "Main", bundle: nil)
                            let rootVc = vc.instantiateViewController(withIdentifier: "homeID")
                            self.present(rootVc, animated: true, completion: nil)
                            
                            
                        }else if data["status"].stringValue == "402"{
                            self.showNoti(data["message"].stringValue)
                            print("code \(code)_2__________________________")
                        }
                    }

                }else{
                    self.showNoti("try")
                }
            }
         
        }
    }
    

}
