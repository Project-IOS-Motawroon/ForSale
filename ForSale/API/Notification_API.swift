//
//  Notification_API.swift
//  Camel market
//
//  Created by Mohamed on 11/17/20.
//  Copyright © 2020 endpont. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class Notification_API: NSObject {
    static let instance = Notification_API()
    func NOT(completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
           let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,
                          "Accept":"application/json",
                          "lang":"ar"
           ]

                 Alamofire.request(getNotifactionURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
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
                         print("get NOT code  == \(response.response?.statusCode ?? 0)")
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

    
    func deleteNotifaction(notification_id:Int, completion : @escaping(_ code: Int) -> () ){
     let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!]
        let params:[String:Any] = [
                  "notification_id":notification_id,
        ]
          Alamofire.request(deleteNitifactionURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
              switch response.response?.statusCode {
              case 200?:
                  switch response.result
                  {
                  case .failure( let error):
                      print(error)
                      completion(response.response!.statusCode)
                  case .success(let data):
                      let json = JSON(data)
                      print(json)
                      completion(response.response!.statusCode)
                  }
              default:
                  print("get end room code  == \(response.response?.statusCode ?? 0)")
                  if let requestBody = response.request?.httpBody {
                      do {
                          let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
                          print("Array: \(jsonArray)")
                      }
                      catch {
                          print("Error: \(error)")
                      }
                  }
                  completion(response.response?.statusCode ?? 0)
              }
              
              
          }
      }

}
