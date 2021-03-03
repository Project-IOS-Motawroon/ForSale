
import UIKit

class MyAccountVC: UIViewController {
    @IBOutlet weak var LogoImg: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var prohibitedGoodsView: UIView!
    let dev = UserDefaults.standard

    override func viewWillAppear(_ animated: Bool) {
        prohibitedGoodsView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        if dev.string(forKey: "logo") != nil{
            name.text = dev.string(forKey: "name")!
        }

        if dev.string(forKey: "logo") != nil{
            LogoImg.setImage(from: ImageURL + dev.string(forKey: "logo")!)
        }else{
            LogoImg.image = UIImage(named: "smallLogo")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        LogoImg.circleImage()
        LogoImg.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)

        EditBtn.circleView()
        EditBtn.layer.borderColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        
   
    }
    
    @IBAction func AddAdsPress(_ sender: Any) {
                   performSegue(withIdentifier: "AddAdsSegue", sender: self)

    }


    @IBAction func favouritPress(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "is_login"){
                   performSegue(withIdentifier: "FAVSegue", sender: self)
               }else{
                   self.loginAlert()
               }
    }
    
    

    @IBAction func CommissionPress(_ sender: Any) {
        performSegue(withIdentifier: "CommissionSegue", sender: self)
        
    }
    
    
    @IBAction func contactUSPress(_ sender: Any) {
      
        performSegue(withIdentifier: "contactUSSegue", sender: self)
        
    }
    
    
    @IBAction func MyAdsPress(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "is_login"){
            performSegue(withIdentifier: "MyAdsSegue", sender: self)
               }else{
                   self.loginAlert()
               }
    }
    
    
    @IBAction func editProfilePress(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "is_login"){
            performSegue(withIdentifier: "EditMyProfileSegue", sender: self)
               }else{
                   self.loginAlert()
               }

    }
    
    
    @IBAction func settingPress(_ sender: Any) {
//        if UserDefaults.standard.bool(forKey: "is_login"){
            performSegue(withIdentifier: "settingSegue", sender: self)
//               }else{
//                   self.loginAlert()
//               }
    }
    
    @IBAction func logOutPress(_ sender: Any) {
        
        let alertController = UIAlertController(title: "do You want logout".localized(), message: nil, preferredStyle: .actionSheet)
              let OKAction = UIAlertAction(title: "Yes".localized(), style: .default, handler: { action in
                if UserDefaults.standard.bool(forKey: "is_login"){
                      Auth_API().logOut { (code) in
                          if code == 200 {
                            self.deleteFirebasToken()
                 
                          }else{
                            self.showNoti("try".localized())
                          }
                      }
                  }else{
                           let vc = UIStoryboard(name: "Main", bundle: nil)
                                              let rootVc = vc.instantiateViewController(withIdentifier: "loginID")
                                              self.present(rootVc, animated: true, completion: nil)
                  }
              })
              alertController.addAction(OKAction)
              alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
              if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.sourceView = sender as! UIView
                alertController.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
                  alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
              }
              
              self.present(alertController, animated: true)
    }
    
    func deleteFirebasToken(){
        let par:[String:Any] = [
            "user_id":dev.integer(forKey: "id"),
            "firebase_token":dev.string(forKey: "FCMToken") ?? "",
        ]
        Auth_API().deleteToken(prams: par) { (code) in
                if code == 200{
                    UserDefaults.standard.set(false, forKey: "is_login")
                    let vc = UIStoryboard(name: "Main", bundle: nil)
                    let rootVc = vc.instantiateViewController(withIdentifier: "loginID")
                    self.present(rootVc, animated: true, completion: nil)
                    
                }else{
                    self.showNoti("try".localized())
                }
            }
        
        }
    }
    

