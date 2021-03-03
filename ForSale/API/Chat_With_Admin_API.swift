
import UIKit
import Alamofire
import SwiftyJSON
//import Foundation

class Chat_With_Admin_API: NSObject {
    
    static let instance = Chat_With_Admin_API()
    
    func adminChatRoomGet(completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,
                       "Accept":"application/json"
        ]
   
                 Alamofire.request(adminChatRoomGetURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
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

    
    
    
    func oneChatRoom(room_id:Int,completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
        let params = ["room_id":room_id]
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!]

                Alamofire.request(allChatRoomDataURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                    
                    switch response.response?.statusCode {
                    case 200?:
                        switch response.result
                        {
                        case .failure( let error):
                            print(error)
                            completion(response.response!.statusCode,nil)
                        case .success(let data):
                            let jsonx = JSON(data)
                            let json = jsonx["data"]["messages"].arrayValue
                            print(json)
                            completion(response.response!.statusCode,json)
                        }

                    default:
                        print("get one chat message code  == \(response.response?.statusCode ?? 0)")
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

    
    func sendMsg(params:[String:Any],completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,
                       "Accept":"application/json"
        ]
        
        print("params \(params)")
                Alamofire.request(sendMessageToAdminURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                    
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
                        print("get chat room code  == \(response.response?.statusCode ?? 0)")
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
    
    
    
    
    func sendImagemessage(room_id:Int,message_kind:String,date:Int,file_link:Data,completion : @escaping(_ success: Bool,_ code:Int) -> () ){
        
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,
                       "Accept":"application/json"
        ]
        
                    let params:[String:Any] = [
                        "room_id":room_id,
                        "file_link":file_link,
                        "date":date,
                        "message_kind":message_kind
                    ]
        
                    Alamofire.upload(
                        multipartFormData: { multipartFormData in
                           // send video
                            // send images
                            multipartFormData.append(file_link, withName: "file_link",fileName: "file_link.jpeg", mimeType: "file_link/jpeg")
                            // send params
                            for (key, value) in params {
                                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                            }
                           
                    },
                        to: sendMessageToAdminURL,
                        
                        method: .post, headers: headers,
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

    
    
}
