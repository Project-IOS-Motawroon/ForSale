

import UIKit

class MainTabBarVC: UITabBarController ,UITabBarControllerDelegate{
    
        let is_login = UserDefaults.standard.bool(forKey: "is_login")
        override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
   
        }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
                if viewController == tabBarController.viewControllers![2]  {
                    if is_login{
                        return true
                    }else{
                        self.loginAlert()

                        return false
                    }
                }
                return true
            }

}

