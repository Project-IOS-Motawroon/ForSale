//
//  Extensions.swift
//  Sun Fun
//
//  Created by arab devolpers on 7/17/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

//import Foundation
import UIKit
import CoreData
import FTToastIndicator
import FTNotificationIndicator
import SideMenu
import DropDown

extension UIViewController {
    
    func drop(anchor:UIView,dataSource:[String],completion: @escaping(_ item:String,_ index:Int)->Void) {
                let dropDown = DropDown()
                dropDown.anchorView = anchor
              //  dropDown.direction = .bottom
                dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! + 5)
                dropDown.anchorView?.plainView.semanticContentAttribute = .unspecified
                dropDown.backgroundColor = .lightGray
                dropDown.textColor = .black
                dropDown.dataSource = dataSource
                dropDown.RoundCorners(cornerRadius: 10.0)
      
//                dropDown.textFont = UIFont(name: "neoSansArabic", size: 16.0)!
                dropDown.cellHeight = 40.0
                dropDown.dropShadow()
                dropDown.selectionAction = {(index: Int, item: String) in
                    completion(item,index)
                }
                dropDown.show()
            }
//
//        func sideMenu(_ storyboard:String ,_ identifier:String)->UISideMenuNavigationController{
//            let menu = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier:identifier) as! UISideMenuNavigationController
//            menu.menuWidth = UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width/4
//    //        menu.presentationStyle = .menuSlideIn
//            if Locale.preferredLanguages[0] == "ar" {menu.leftSide = false}else{menu.leftSide = true}
//            return menu
//
//        }
    
//    func sideMenu(_ storyboard:String ,_ identifier:String)-> SideMenuNavigationController{
//        let menu = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier:identifier) as! SideMenuNavigationController
//        menu.menuWidth = UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width/4
//
//
//        menu.sideMenuManager.menuRightNavigationController =  UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier) as? SideMenuNavigationController
//        //menu.presentationStyle = .menuSlideIn
//        if Locale.preferredLanguages[0] == "ar" {
//            menu.sideMenuManager.menuRightNavigationController =  UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier) as? SideMenuNavigationController
//
//        }else{
//            menu.sideMenuManager.menuLeftNavigationController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier) as? SideMenuNavigationController
//        }
//        return menu
//
//    }
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
     func rateApp(appId: String) {
         openUrl("itms-apps://itunes.apple.com/app/" + appId)
         }
         func openUrl(_ urlString:String) {
         let url = URL(string: urlString)!
         if #available(iOS 10.0, *) {
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
         } else {
         UIApplication.shared.openURL(url)
         }
         }
    func ftt(_ txt:String){
        FTToastIndicator.setToastIndicatorStyle(.dark)
        FTToastIndicator.showToastMessage(txt.localized())
    }
    
    func openWhatsApp(_ phone_number:String){
        
                  let appURL = URL(string: "https://wa.me/\(phone_number)")!
                  if UIApplication.shared.canOpenURL(appURL) {
                      if #available(iOS 10.0, *) {
                          UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                      } else {
                          UIApplication.shared.openURL(appURL)
                      }
                  }
           
    }
    func showNoti(_ txt:String){
        FTNotificationIndicator.setNotificationIndicatorStyle(.light)
        FTNotificationIndicator.showNotification(with: UIImage(named: "logo"), title: "Fore Sale".localized(), message: txt.localized())
        FTNotificationIndicator.setDefaultDismissTime(4.0)
    }
    func showNoti_without_Localization(_ txt:String){
           FTNotificationIndicator.setNotificationIndicatorStyle(.dark)
           FTNotificationIndicator.showNotification(with: UIImage(named: "logo"), title: "Fore Sale".localized(), message: txt)
           FTNotificationIndicator.setDefaultDismissTime(4.0)
       }
    /////////// fromStampToString
    func fromStampToString(time: TimeInterval , format : String) -> String {
        
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat =  format // "EEE MMM dd HH:mm:ss Z yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }

    func ArabicNumReplacement(TF:UITextField,SS:String)->Bool {
           if TF.keyboardType == .numberPad && SS != "" {
               let numberStr: String = SS
               let formatter: NumberFormatter = NumberFormatter()
               formatter.locale = Locale(identifier: "EN")
               if let final = formatter.number(from: numberStr) {
                   TF.text =  "\(TF.text ?? "")\(final)"
               }
               return false
           }
           return true
       }
//    func changeBadge(){
//
//             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//             let managedContext = appDelegate.persistentContainer.viewContext
//             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
//             do {
//                 let result = try managedContext.fetch(fetchRequest)
//                 if let data = result as? [NSManagedObject] {
//                   if data.count > 0 {
//               if let tabItems = tabBarController?.tabBar.items {
//                   let tabItem = tabItems[3]
//                    var seen = [String]()
//                    var unique = [NSManagedObject]()
//                for item in data{
//                    if !seen.contains(item.value(forKey: "pro_id") as! String) {
//                        seen.append(item.value(forKey: "pro_id") as! String)
//                        unique.append(item)
//
//                    }
//                }
//                   tabItem.badgeValue = "\(unique.count)"
//                print("ssssssss\(unique.count)")
//               }
//
//                   }else{
//                       if let tabItems = tabBarController?.tabBar.items {
//                                      let tabItem = tabItems[3]
//                                      tabItem.badgeValue = nil
//                                  }
//                   }
//               }
//
//             } catch  {
//                 print("fail")
//             }
//         }

    func alertdone(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: { action in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
       
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func loginAlert() {
        let alertController = UIAlertController(title: "سعودي سيل".localized(), message: "loginPlease".localized(), preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok".localized(), style: .default, handler: { action in
             let vc = UIStoryboard(name: "Main", bundle: nil)
               let rootVc = vc.instantiateViewController(withIdentifier: "loginID")
               self.present(rootVc, animated: true, completion: nil)
        })
        alertController.addAction(OKAction)
        alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
}
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
    func dateFromInteger(_ timeStamp:Int)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: Date(timeIntervalSince1970:TimeInterval(timeStamp)))
    }
    
}
//class helperHelper:NSObject{
//class func sideMenu(_ storyboard:String ,_ identifier:String)->UISideMenuNavigationController{
//        let menu = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier:identifier) as! UISideMenuNavigationController
//        menu.menuWidth = UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width/4
//       // menu.presentationStyle = .menuSlideIn
//        if Locale.preferredLanguages[0] == "ar" {menu.leftSide = false}else{menu.leftSide = true}
//        return menu
//    }
//    func position(for bar: UIBarPositioning) -> UIBarPosition {
//            return .topAttached
//        }
//
//
//}
class helperHelper:NSObject{
class func sideMenu(_ storyboard:String ,_ identifier:String)->SideMenuNavigationController{
        let menu = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier:identifier) as! SideMenuNavigationController
        menu.menuWidth = UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width/4
        menu.presentationStyle = .menuSlideIn
        if Locale.preferredLanguages[0] == "en" {menu.leftSide = false}else{menu.leftSide = true}
        return menu
    }
}

