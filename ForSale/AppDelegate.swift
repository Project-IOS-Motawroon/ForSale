
import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleMaps
import MOLH
import FirebaseMessaging
import FirebaseAuth
import SwiftyJSON
@main
class AppDelegate: UIResponder, UIApplicationDelegate ,MOLHResetable{
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        MOLHLanguage.setDefaultLanguage("en")
        MOLH.shared.activate(true)
        MOLH.shared.specialKeyWords = ["Cancel","Done"]
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyA6QI378BHt9eqBbiJKtqWHTSAZxcSwN3Q")
        setupNotifications(application)

        return true
    }

    
    
    /////////// for language ///////////////////
    func reset() {
             let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nav = storyBoard.instantiateViewController(identifier: "homeID")
                    let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
                    rootviewcontroller.rootViewController = nav
             if #available(iOS 13.0, *){
                 self.switchRoot()
             }else{
                 let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
                 let stry = UIStoryboard(name: "Main", bundle: nil)
                 rootviewcontroller.rootViewController = stry.instantiateViewController(identifier: "homeID")
             }
         }

      @available(iOS 13.0, *)
       func switchRoot(){
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let nav = storyBoard.instantiateViewController(identifier: "homeID")
        
        if let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!){
           rootviewcontroller.rootViewController = nav
        }
       }
    
    /////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////// for notifaction ////////////////////////////////////////////////////
    func setupNotifications(_ application: UIApplication){
           if #available(iOS 10.0, *) {
               // For iOS 10 display notification (sent via APNS)
               UNUserNotificationCenter.current().delegate = self
               
               let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
               UNUserNotificationCenter.current().requestAuthorization(
                   options: authOptions,
                   completionHandler: {_, _ in })
           }else{
               let settings: UIUserNotificationSettings =
                   UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
               application.registerUserNotificationSettings(settings)
           }
           Messaging.messaging().delegate = self
           application.registerForRemoteNotifications()
           
       }


}


extension AppDelegate :  MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
     print("Firebase registration token: \(fcmToken)")
     UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
    }


func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    print("APNs device token: \(deviceTokenString)")
    
}

}

extension AppDelegate : UNUserNotificationCenterDelegate{
// Receive displayed notifications for iOS 10 devices.
func userNotificationCenter(_ center: UNUserNotificationCenter,
                         willPresent notification: UNNotification,
                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 let userInfo = notification.request.content.userInfo
 
 if let data = userInfo as? [String:Any]{
    let item = JSON(data)
    if item["notification_type"].stringValue == "message_send" && item["to_user_id"].stringValue == UserDefaults.standard.string(forKey: "id"){
        let jsondata:[String:Any] = [
            "message_send":item
        ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "message_send"), object: nil, userInfo: jsondata)
    }
    /////////////////////////////////// other notification_type////////////////////
    if item["notification_type"].stringValue == "admin_message_send" && item["to_user_id"].stringValue == UserDefaults.standard.string(forKey: "id"){
        let jsondata:[String:Any] = [
            "message_send":item
        ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "message_send"), object: nil, userInfo: jsondata)
    }
  print("foreNoti$$$",JSON(data))

 }
 completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound])
}

    
    
    
    
func userNotificationCenter(_ center: UNUserNotificationCenter,
                         didReceive response: UNNotificationResponse,
                         withCompletionHandler completionHandler: @escaping () -> Void) {
 let userInfo = response.notification.request.content.userInfo
 
 if let xx = userInfo as? [String:Any] {
  print("BackNoti$$$",JSON(xx))
    let item = JSON(xx)
    if item["notification_type"].stringValue == "message_send" && item["to_user_id"].stringValue == UserDefaults.standard.string(forKey: "id"){
        let jsondata:[String:JSON] = [
            "message_send":item
        ]
        adminChat = item
        let stry = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeID")
        self.window?.rootViewController = stry
        self.window?.makeKeyAndVisible()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homechat"), object: nil, userInfo: jsondata)
      
    }
    
    ///////////////////////////  other notification_type  /////////////////////////////////////
    
    if item["notification_type"].stringValue == "admin_message_send" && item["to_user_id"].stringValue == UserDefaults.standard.string(forKey: "id"){
        let jsondata:[String:JSON] = [
            "message_send":item
        ]
        adminChat = item
        let stry = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeID")
        self.window?.rootViewController = stry
        self.window?.makeKeyAndVisible()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homechat"), object: nil, userInfo: jsondata)
      
    }

    
 }
 completionHandler()
}

}


