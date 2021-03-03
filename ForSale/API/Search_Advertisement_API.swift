//
//  Search_Advertisement_API.swift
//  Camel market
//
//  Created by Mohamed on 11/18/20.
//  Copyright © 2020 endpont. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Search_Advertisement_API: NSObject {
    
    static let instance = Search_Advertisement_API()

    func search(name:String,completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
        let params:[String:Any] =
            ["search_key":name,
             "using_my_location":"no"
          ]
//          if UserDefaults.standard.bool(forKey: "is_login"){
//              params["user_id"] = "\(UserDefaults.standard.integer(forKey: "id"))"
//          }else{
//              params["user_id"] =  "all"
//          }
                    Alamofire.request(getSearchAdvertisementURL, method: .get, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
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
                            print("get search Restaurants code  == \(response.response?.statusCode ?? 0)")
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
