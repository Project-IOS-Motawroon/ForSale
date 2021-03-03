
import Foundation
import Alamofire
import SwiftyJSON

class Favorite_Api: NSObject {
    static let instance = Favorite_Api()
    func fav(completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
           let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")! ]

                 Alamofire.request(getFavoriteUrl, method: .get, parameters: nil, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
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
    
    
    func actionFav(params:[String:Any],completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!]
               Alamofire.request(addOrRemoveFavoriteURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
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
    
    
    
//    func myAds(completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
////        let params:[String:Any] = ["user_id":UserDefaults.standard.integer(forKey: "id") ]
//        let params:[String:Any] = [
//            "pagination" : "off",
//            "limit_per_page":15,
//            "user_id":UserDefaults.standard.integer(forKey: "id")
//        ]
//                 Alamofire.request(getMyAddsUrl, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
//                     switch response.response?.statusCode {
//                     case 200?:
//                         switch response.result
//                         {
//                         case .failure( let error):
//                             print(error)
//                             completion(response.response!.statusCode,nil)
//                         case .success(let data):
//                             let jsonx = JSON(data)
//                             let json = jsonx["data"].arrayValue
//                             print(json)
//                             completion(response.response!.statusCode,json)
//                         }
//                     default:
//                         print("get Fav code  == \(response.response?.statusCode ?? 0)")
//                         if let requestBody = response.request?.httpBody {
//                             do {
//                                 let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
//                                 print("Array: \(jsonArray)")
//                             }
//                             catch {
//                                 print("Error: \(error)")
//                             }
//                         }
//                         completion(response.response?.statusCode ?? 0,nil)
//                     }
//                 }
//             }
    
    
//    func deleteMyAdd(paramsd:Int,completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
////        let headers = ["Authorization":UserDefaults.standard.string(forKey: "token")!]
//        let params:[String:Any] = [
//            "user_id":UserDefaults.standard.integer(forKey: "id"),
//            "product_id":paramsd
//        ]
//               Alamofire.request(deleteMyAddsUrl, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
//                   switch response.response?.statusCode {
//                   case 200?:
//                       switch response.result
//                       {
//                       case .failure( let error):
//                           print(error)
//                           completion(response.response!.statusCode,nil)
//                       case .success(let data):
//                           let jsonx = JSON(data)
//                           let json = jsonx
//                           print(json)
//                           completion(response.response!.statusCode,json)
//                       }
//                   default:
//                       print("get category code  == \(response.response?.statusCode ?? 0)")
//                       if let requestBody = response.request?.httpBody {
//                           do {
//                               let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
//                               print("Array: \(jsonArray)")
//                           }
//                           catch {
//                               print("Error: \(error)")
//                           }
//                       }
//                       completion(response.response?.statusCode ?? 0,nil)
//                   }
//               }
//           }
    
    
    
    func ReportAds(params:[String:Any],completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!]

               Alamofire.request(ReportAdsUrl, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
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
    
       }
