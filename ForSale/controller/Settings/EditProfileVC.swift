

import UIKit
import MOLH
import FTToastIndicator
class EditProfileVC: UIViewController ,ImagePickerDelegate{
    var imagePicker: ImagePicker!
    var user_imageData:Data?
    let is_arabic = MOLHLanguage.currentAppleLanguage() == "en" ? "en" : "ar"
    let dev = UserDefaults.standard
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!

    @IBOutlet weak var StakEmailTohiden: UIStackView!
    
    override func viewDidLoad() {
        self.title = "Edit Profile".localized()
        StakEmailTohiden.isHidden = true
        super.viewDidLoad()
        settings()
        setData()
    }
    func setData(){
        dev.string(forKey: "logo")!
        logo.setImage(from: ImageURL + dev.string(forKey: "logo")!)
        nameTF.text = dev.string(forKey: "name")!
        emailTF.text = dev.string(forKey: "email")!
    }
    func settings(){
//        if is_arabic == "ar"{
//            img.image = UIImage(named: "ArIMG")
//        }
        logo.layer.borderWidth = 1.0
        logo.layer.borderColor = #colorLiteral(red: 0.8601463437, green: 0.588457346, blue: 0.1444929838, alpha: 1)
        logo.circleView()
 
       
      }
    
    @IBAction func saveBTN(_ sender: Any) {
        let name = nameTF.text!
        let email = emailTF.text!

            //api
            BGLoading.instance.show(view)
            Auth_API().editProfile(name: name, email: email, logo: user_imageData) { (code) in
                BGLoading.instance.dismissLoading()
                if code == 200 {
//                    FTToastIndicator.setToastIndicatorStyle(.dark)
//                    FTToastIndicator.showToastMessage("yourRequestHasExecuted".localized())
                    self.ftt("done".localized())
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("code \(code)")
                    FTToastIndicator.setToastIndicatorStyle(.dark)
                    FTToastIndicator.showToastMessage("try Again Later".localized())
                }
            }
    }
    
    @IBAction func pricIMG(_ sender: UIButton) {
     self.imagePicker = ImagePicker(presentationController: self, delegate: self)
              self.imagePicker.present(from: sender)
          }
          func didSelect(image: UIImage?) {
              guard let image = image else {
                  return
              }
              logo.image = image
              logo.contentMode = .scaleToFill
              user_imageData = image.jpegData(compressionQuality: 0.7)!
          }
    
 

}
