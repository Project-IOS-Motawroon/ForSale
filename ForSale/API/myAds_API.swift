//
//  myAds_API.swift
//  ForSale
//
//  Created by Mohamed on 12/13/20.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class myAds_API: NSObject {
    static let instance = myAds_API()
    func myAds(completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
//        let params:[String:Any] = ["user_id":UserDefaults.standard.integer(forKey: "id") ]
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")! ]
                 Alamofire.request(getMyAddsUrl, method: .get, parameters: nil, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                     switch response.response?.statusCode {
                     case 200?:
                         switch response.result
                         {
                         case .failure( let error):
                             print(error)
                             completion(response.response!.statusCode,nil)
                         case .success(let data):
                             let jsonx = JSON(data)
                             let json = jsonx["data"].arrayValue
                             print(json)
                             completion(response.response!.statusCode,json)
                         }
                     default:
                         print("get Fav code  == \(response.response?.statusCode ?? 0)")
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
