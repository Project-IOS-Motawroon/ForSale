//
//  Coupons_API.swift
//  ForSale
//
//  Created by Mohamed on 12/19/20.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class Coupons_API: NSObject {
    static let instance = Coupons_API()
    func GetCoupons(completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){


                 Alamofire.request(getCouponsURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
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

    
    
    func singleCoupon(coupon_id:Int,completion : @escaping(_ code: Int,_ result:JSON?
    ) -> () ){

        let params:[String:Any] = [
            "coupon_id" : coupon_id,
            "user_id":UserDefaults.standard.integer(forKey: "id"),
        ]
        Alamofire.request(singleCouponURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    print("get Coupon Status code  == \(response.response?.statusCode)")
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
//                completion(false,nil,nil)

            case 200?:
                print("get Coupon Status code  == \(response.response?.statusCode)")
                switch response.result
                {
                case .failure( let error):
                    print(error)
//                    completion(response.response!.statusCode,nil)
                case .success(let data):
                    let jsonx = JSON(data)
                    let json = jsonx
                    print(json)
//                    completion(response.response!.statusCode,json)
                    completion(response.response?.statusCode ?? 0,json)

                }

            default:
                print("get Coupon Status code  == \(response.response?.statusCode)")
                if let dat = response.data {
                    //print(dat)
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON)
                }
                completion(response.response?.statusCode ?? 0,nil)

//                completion(false,nil,nil)


            }
        }

    }
    
    func actionCoupon(params:[String:Any],completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!]
               Alamofire.request(makeActionOnCoupon, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                   switch response.response?.statusCode {
                   case 200?:
                       switch response.result
                       {
                       case .failure( let error):
                           print(error)
                           completion(response.response!.statusCode,nil)
                       case .success(let data):
                           let jsonx = JSON(data)
                           let json = jsonx
                           print(json)
                           completion(response.response!.statusCode,json)
                       }
                   default:
                       print("get category code  == \(response.response?.statusCode ?? 0)")
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
    
    
    
    
    func addCoupons(title:String,brandTitle:String,couponCode:String,offerValue:String,fromDate:String,logo:Data?,completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!
        ]
        
           let parameters : [String : Any] = [
            "title":title,
            "brand_title":brandTitle,
            "coupon_code":couponCode,
            "offer_value":offerValue,
            "from_date":fromDate,
           ]

        Alamofire.upload(
            multipartFormData: { multipartFormData in

                if let image1 = logo {
                    multipartFormData.append(image1, withName: "coupon_image",fileName: "image.jpg", mimeType: "image/jpg")
                }

                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }

        },
            to: makeNewCouponURL,
            method: .post,headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):

                    upload.validate(statusCode: 200..<300)
                        .responseJSON { data in
                            switch data.response?.statusCode{
                            case 200?:

                                print("the status code is \(data.response?.statusCode ?? 0)")
                                let jsonx = JSON(data.data)
//                                let json = jsonx["data"]
                                let json = jsonx
                                print("nnnnnnnnnnnnnnnnnnn\(json["data"])")
//
                               
                                completion(data.response!.statusCode,json)
//                                completion(data.response?.statusCode ?? 0)
                            case 422?:
                                let responseJSON = try? JSON(data: data.data!)
                                print(responseJSON ?? 0)
                                //print("you are failed")
                                completion(data.response?.statusCode ?? 0,nil)
                            default :
                                print("the status code is \(data.response?.statusCode ?? 0)")
                                let responseJSON = try? JSON(data: data.data!)
                                print(responseJSON ?? 0)
                                print("you are failed")

                                completion(data.response?.statusCode ?? 0,nil)
                            }

                    }
                case .failure(let encodingError):
                    print("the error is in default:\(encodingError)")

                    completion(0,nil)

                }
        }
        )
       }

    
}
