

import UIKit
import Alamofire
import SwiftyJSON
import Foundation


class Get_Setting_API: NSObject {
    static let instance = Get_Setting_API()
    func settings(completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
           let headers = [
//            "Authorization":UserDefaults.standard.string(forKey: "token")!,
            "lang":"ar",
            "Accept":"application/json"
                    
           ]
   
                 Alamofire.request(getAppSettingURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                     switch response.response?.statusCode {
                     case 200?:
                         switch response.result
                         {
                         case .failure( let error):
                             print(error)
                             completion(response.response!.statusCode,nil)
                         case .success(let data):
                             let jsonx = JSON(data)
                             let json = jsonx["data"]
                             print(json)
                             completion(response.response!.statusCode,json)
                         }
                     default:
                         print("get settings code  == \(response.response?.statusCode ?? 0)")
                         if let requestBody = response.request?.httpBody {
                             do {
                                 let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
                                 print("Array: \(jsonArray)")
                             }
                             catch {
                                 print("Error: \(error)")
                             }
                         }
                         completion(response.response?.statusCode ?? 0,nil)
                     }
                 }
             }
    
    
    
    
}
