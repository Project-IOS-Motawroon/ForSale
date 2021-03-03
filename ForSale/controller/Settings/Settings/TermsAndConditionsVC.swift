

import UIKit

class TermsAndConditionsVC: UIViewController {

    @IBOutlet weak var text: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //****to mack UITextView not editable by the user
        text.isSelectable = false;
        text.isEditable = false;
        //********************
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        self.tabBarController?.tabBar.isHidden = true

            self.title = "Terms and Conditions".localized()
            text.RoundCorners(cornerRadius: 10.0)
            text.dropShadow()
            BGLoading.instance.show(view)
            Get_Setting_API.instance.settings { (code, result) in
               BGLoading.instance.dismissLoading()
                if let data = result{
                    self.text.text = data["ar_terms_condition"].stringValue.htmlToString
                }
            }
        

        }
    }
