
import Foundation
import Alamofire
import SwiftyJSON
import MOLH

class Auth_API:NSObject{
    
    let defaults = UserDefaults.standard
//    static let instance = Auth_API()
//    let is_arabic = MOLHLanguage.currentAppleLanguage() == "en" ? "en" : "ar"
    func login(phone:String,phone_code:String,completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
        let parameters : [String : Any] = [
            "phone":phone,
            "phone_code":phone_code
        ]
        
        Alamofire.request(LoginURL, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.response?.statusCode {
            case 200?:
             
                switch response.result
                {
                case .failure( let error):
                    print(error)
                    completion(response.response!.statusCode,nil)
                case .success(let data):
                    let jsonx = JSON(data)
//                    let json = jsonx["data"]
                    let json = jsonx
                    self.defaults.set(json["data"]["id"].intValue, forKey: "id")
                    self.defaults.set(json["data"]["phone"].stringValue, forKey: "phone")
                    self.defaults.set(json["data"]["phone_code"].stringValue, forKey: "phone_code")
                    self.defaults.set(json["data"]["name"].stringValue, forKey: "name")
                    self.defaults.set(json["data"]["email"].stringValue, forKey: "email")
                    self.defaults.set(json["data"]["address"].stringValue, forKey: "address")
                    self.defaults.set(json["data"]["logo"].stringValue, forKey: "logo")
                    self.defaults.set(json["data"]["date_of_barth"].stringValue, forKey: "date_of_barth")

                   self.defaults.set(json["data"]["token"].stringValue, forKey: "token")
                    self.defaults.set(true, forKey: "is_login")
                    
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
    
    
    
    func register(name:String,phone:String,phone_code:String,logo:Data?,completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
           let parameters : [String : Any] = [
               "phone":phone,
               "phone_code":phone_code,
               "name":name,
               "latitude":"0",
               "longitude":"0",
               "software_type":"ios"
           ]

        Alamofire.upload(
            multipartFormData: { multipartFormData in

                if let image1 = logo {
                    multipartFormData.append(image1, withName: "logo",fileName: "image.jpg", mimeType: "image/jpg")
                }

                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }

        },
            to: RegisterURL,
            method: .post,
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
                                
                                self.defaults.set(json["data"]["id"].intValue, forKey: "id")
                                self.defaults.set(json["data"]["phone"].stringValue, forKey: "phone")
                                self.defaults.set(json["data"]["phone_code"].stringValue, forKey: "phone_code")
                                self.defaults.set(json["data"]["name"].stringValue, forKey: "name")
                                self.defaults.set(json["data"]["email"].stringValue, forKey: "email")
                                self.defaults.set(json["data"]["address"].stringValue, forKey: "address")
                                self.defaults.set(json["data"]["logo"].stringValue, forKey: "logo")
                                self.defaults.set(json["data"]["date_of_barth"].stringValue, forKey: "date_of_barth")

                               self.defaults.set(json["data"]["token"].stringValue, forKey: "token")
                                self.defaults.set(true, forKey: "is_login")
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
    
    func updateToken(prams:[String:Any],completion : @escaping(_ code: Int) -> () ){
       
           Alamofire.request(updateTokenURL, method: .post, parameters: prams, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
               switch response.response?.statusCode {
               case 200?:
                   switch response.result{
                   case .failure( let error):
                       print(error)
                       completion(response.response?.statusCode ?? 0)
                   case .success(let value):

                       completion(response.response?.statusCode ?? 0)
                   }
               default:
                   print("get update token code  == \(response.response?.statusCode ?? 0)")
                   if let dat = response.data {
                       //print(dat)
                       let responseJSON = try? JSON(data: dat)
                       print(responseJSON)
                   }
                   completion(response.response?.statusCode ?? 0)

               }
           }

       }

    func deleteToken(prams:[String:Any],completion : @escaping(_ code: Int) -> () ){
       
           Alamofire.request(DeletePhoneTokenURL, method: .post, parameters: prams, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
               switch response.response?.statusCode {
               case 200?:
                   switch response.result{
                   case .failure( let error):
                       print(error)
                       completion(response.response?.statusCode ?? 0)
                   case .success(let value):

                       completion(response.response?.statusCode ?? 0)
                   }
               default:
                   print("get update token code  == \(response.response?.statusCode ?? 0)")
                   if let dat = response.data {
                       //print(dat)
                       let responseJSON = try? JSON(data: dat)
                       print(responseJSON)
                   }
                   completion(response.response?.statusCode ?? 0)

               }
           }

       }

    
    func logOut(completion : @escaping(_ code: Int) -> () ){
//              let params:[String:Any] = [
////                  "soft_type":"ios",
////                  "user_id":UserDefaults.standard.integer(forKey: "id"),
//                  "phone_token":defaults.string(forKey: "token")!
//              ]
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,
                       "Accept":"application/json"
        ]

              Alamofire.request(logOutURL, method: .post, parameters: nil, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                  switch response.response?.statusCode {
                  case 200?:
                      switch response.result{
                      case .failure( let error):
                          print(error)
                          completion(response.response?.statusCode ?? 0)
                      case .success(let value):

                          completion(response.response?.statusCode ?? 0)
                      }
                  default:
                      print("get log out code  == \(response.response?.statusCode ?? 0)")
                      if let dat = response.data {
                          //print(dat)
                          let responseJSON = try? JSON(data: dat)
                          print(responseJSON)
                      }
                      completion(response.response?.statusCode ?? 0)

                  }
              }

          }

    func editProfile(name:String,
            email:String,logo:Data?,completion : @escaping(_ code: Int) -> () ){
           let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,]

           let parameters : [String : Any] = [
               "name":name,
               "email":email,
            "phone":defaults.string(forKey: "phone")!,
            "phone_code":defaults.string(forKey: "phone_code")!,
            "latitude":"0",
            "longitude":"0",
           ]

           Alamofire.upload(
               multipartFormData: { multipartFormData in

                   if let image1 = logo {
                       multipartFormData.append(image1, withName: "logo",fileName: "logo.jpeg", mimeType: "logo/jpeg")
                   }

                   for (key, value) in parameters {
                       multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                   }

           },
               to: updateProfileURL,
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
                                let jsonx = JSON(data.data)
                                print(".......\(jsonx)")
                                   let json = jsonx["data"]
//                                let json = jsonx

                                   print(".......\(json)")
                                self.defaults.set(json["id"].intValue, forKey: "id")
                                self.defaults.set(json["phone"].stringValue, forKey: "phone")
                                self.defaults.set(json["phone_code"].stringValue, forKey: "phone_code")
                                self.defaults.set(json["name"].stringValue, forKey: "name")
                                self.defaults.set(json["email"].stringValue, forKey: "email")
                                self.defaults.set(json["address"].stringValue, forKey: "address")
                                self.defaults.set(json["logo"].stringValue, forKey: "logo")
                                self.defaults.set(json["date_of_barth"].stringValue, forKey: "date_of_barth")

                               self.defaults.set(json["token"].stringValue, forKey: "token")
                                self.defaults.set(true, forKey: "is_login")
                                   completion(data.response?.statusCode ?? 0)
                               case 422?:
                                   let responseJSON = try? JSON(data: data.data!)
                                   print(responseJSON ?? 0)
                                   //print("you are failed")
                                   completion(data.response?.statusCode ?? 0)
                               default :
                                   print("the status code is \(data.response?.statusCode ?? 0)")
                                   let responseJSON = try? JSON(data: data.data!)
                                   print(responseJSON ?? 0)
                                   print("you are failed")
                                   completion(data.response?.statusCode ?? 0)
                               }

                       }
                   case .failure(let encodingError):
                       print("the error is in default:\(encodingError)")

                       completion(0)

                   }
           }
           )

       }

}
