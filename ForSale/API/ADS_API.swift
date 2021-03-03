


import Foundation
import Alamofire
import SwiftyJSON
class ADS_API :NSObject {
    let isArabic = UserDefaults.standard.bool(forKey: "is_arabic")
    let defaults = UserDefaults.standard
    
    func singleAds(ads_id:Int,completion : @escaping(_ code: Int,_ result:JSON?
    ) -> () ){

        let params:[String:Any] = [
            "product_id" : ads_id,
            "user_id":UserDefaults.standard.integer(forKey: "id"),
        ]
        Alamofire.request(single_adsURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 422?:
                if let dat = response.data {
                    print(dat)
                    print("get Ads Status code  == \(response.response?.statusCode)")
                    let responseJSON = try? JSON(data: dat)
                    print(responseJSON ?? 0)
                }
//                completion(false,nil,nil)

            case 200?:
                print("get Ads Status code  == \(response.response?.statusCode)")
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
                print("get Ads Status code  == \(response.response?.statusCode)")
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
    
    
    
    func getsubCateByBasicCatId(CatIdId:Int,completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){

        let params:[String:Any] = [
            "category_id":CatIdId
        ]
        
        Alamofire.request(subCategoriesOfSingleCategoryURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
                     switch response.response?.statusCode {
                     case 200?:
                         switch response.result
                         {
                         case .failure( let error):
                             print(error)
                             completion(response.response!.statusCode,nil)
                         case .success(let data):
                             let jsonx = JSON(data)
                             let json = jsonx["date"].arrayValue
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
    

    func getTypesBySubcateId(CatIdId:Int,completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){

        let params:[String:Any] = [
            "sub_category_id":CatIdId
        ]
        
        Alamofire.request(getTypesBySubcateURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
                     switch response.response?.statusCode {
                     case 200?:
                         switch response.result
                         {
                         case .failure( let error):
                             print(error)
                             completion(response.response!.statusCode,nil)
                         case .success(let data):
                             let jsonx = JSON(data)
                             let json = jsonx["date"].arrayValue
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
    
    
    
    func getAttribuitesFromSubCategory(CatIdId:Int,completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){

        let params:[String:Any] = [
            "sub_category_id":CatIdId
        ]
        
        Alamofire.request(getAttribuitesFromSubCategoryURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
                     switch response.response?.statusCode {
                     case 200?:
                         switch response.result
                         {
                         case .failure( let error):
                             print(error)
                             completion(response.response!.statusCode,nil)
                         case .success(let data):
                             let jsonx = JSON(data)
                             let json = jsonx["date"].arrayValue
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
    
    

    
    

    func addAds(params:[String:Any],ad_images:[Data],main_image:Data?,ad_video:URL,product_details:[[String:Any]],completion : @escaping(_ success: Bool,_ code:Int) -> () ){
        
               let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!
               ]
        
        
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    if let image1 = main_image {
                        multipartFormData.append(image1, withName: "main_image",fileName: "image.jpg", mimeType: "image/jpg")
                    }
                   // send video
                    multipartFormData.append(ad_video, withName: "vedio")
                    // send images
                    var cc = 0
                    for item in ad_images{
                    multipartFormData.append(item, withName: "images[\(cc)]",fileName: "image\(cc).jpeg", mimeType: "image/jpeg")
                        cc += 1
                    }
                    // send params
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                    var vv = 0
                    for item in product_details{
                    for (key, value) in item {
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: "product_details[\(vv)][\(key)]")
                    }
                        vv += 1
                    }

            },
                to: addAdsURL,

                method: .post,
                headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):

                        upload.validate(statusCode: 200..<300)
                            .responseJSON { data in
                                switch data.response?.statusCode{
                                case 200?:
                                    print("the status code is \(data.response?.statusCode ?? 0)")
                                    let json = JSON(data.data)
                                    print(json)
                                    completion(true,data.response?.statusCode ?? 0)
                                case 422?:
                                    print("the status code is my_pre_customer\(data.response?.statusCode ?? 0)")
                                    let responseJSON = try? JSON(data: data.data!)
                                    print(responseJSON ?? 0)
                                    print("you are failed")
                                    completion(false,data.response?.statusCode ?? 0)
                                default :
                                    print("the status code is \(data.response?.statusCode ?? 0)")
                                    let responseJSON = try? JSON(data: data.data!)
                                    print(responseJSON ?? 0)
                                    print("you are failed")
                                    completion(false,data.response?.statusCode ?? 0)
                                }

                        }
                    case .failure(let encodingError):
                        print("the error is in default:\(encodingError)")

                        completion(false,111)

                    }
            }
            )

        }

    
    
    
    
    
    
    
    
    
    
//
//    func addAdsWithoutVideo(main_category_id: Int, category_id:Int,sub_id:Int
//             ,user_id:Int,ad_title:String,ad_desc:String,type_id:Int,city_id:Int
//             ,price:Int,address:String,latitude:Double,longitude:Double,forms_json:[[String:String]]
//             ,ad_images:[Data],completion : @escaping(_ success: Bool,_ code:Int) -> () ){
//
//                 let params:[String:Any] = [
//                     "main_category_id":main_category_id,
//                     "category_id":category_id,
//                     "user_id":user_id,
//                     "ad_title":ad_title,
//                     "ad_desc":ad_desc,
//                     "type_id":type_id,
//                     "city_id":city_id,
//                     "price":price,
//                     "address":address,
//                     "latitude":latitude,
//                     "longitude":longitude
//                 ]
//                 Alamofire.upload(
//                     multipartFormData: { multipartFormData in
//                        // send video
//                         // send images
//                         for item in ad_images{
//                         multipartFormData.append(item, withName: "ad_images[]",fileName: "ad_images.jpeg", mimeType: "ad_images/jpeg")
//                         }
//                         // send params
//                         for (key, value) in params {
//                             multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//                         }
//                         var x = 0
//                         for item in forms_json {
//
//                             multipartFormData.append(item["definition_id"]!.data(using: .utf8)!, withName: "forms_array[\(x)][definition_id]")
//                             multipartFormData.append(item["type"]!.data(using: .utf8)!, withName: "forms_array[\(x)][type]")
//                             multipartFormData.append(item["option_title"]!.data(using: .utf8)!, withName: "forms_array[\(x)][option_title]")
//                         x += 1
//                         }
//                 },
//                     to: "http://firstharaj.com.sa/api/create-adv",
//
//                     method: .post,
//                     encodingCompletion: { encodingResult in
//                         switch encodingResult {
//                         case .success(let upload, _, _):
//
//                             upload.validate(statusCode: 200..<300)
//                                 .responseJSON { data in
//                                     switch data.response?.statusCode{
//                                     case 200?:
//                                         print("the status code is \(data.response?.statusCode ?? 0)")
//                                         let json = JSON(data.data)
//                                         print(json)
//                                         completion(true,data.response?.statusCode ?? 0)
//                                     case 422?:
//                                         print("the status code is my_pre_customer\(data.response?.statusCode ?? 0)")
//                                         let responseJSON = try? JSON(data: data.data!)
//                                         print(responseJSON ?? 0)
//                                         print("you are failed")
//                                         completion(false,data.response?.statusCode ?? 0)
//                                     default :
//                                         print("the status code is \(data.response?.statusCode ?? 0)")
//                                         let responseJSON = try? JSON(data: data.data!)
//                                         print(responseJSON ?? 0)
//                                         print("you are failed")
//                                         completion(false,data.response?.statusCode ?? 0)
//                                     }
//
//                             }
//                         case .failure(let encodingError):
//                             print("the error is in default:\(encodingError)")
//
//                             completion(false,111)
//
//                         }
//                 }
//                 )
//
//             }
}
