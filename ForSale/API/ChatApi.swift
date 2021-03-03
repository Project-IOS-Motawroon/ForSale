//
//  ChatApi.swift
//  ForSale
//
//  Created by Mohamed on 12/21/20.
//

import Foundation
import SwiftyJSON
import Alamofire
import MOLH
class ChatApi: NSObject {
    let is_arabic = MOLHLanguage.currentAppleLanguage()
    let defaults = UserDefaults.standard
    static let instance = ChatApi()
    
    func AllMyChattingRooms(completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!]
        let params:[String:Any] = ["user_id":UserDefaults.standard.integer(forKey: "id") ]
//print(".....\(headers).........\(params)")
              Alamofire.request(getallMyChattingRooms, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                  
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
                      print("get experts code  == \(response.response?.statusCode ?? 0)")
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
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,"Accept":"application/json"]

                Alamofire.request(getOneChatRoomURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
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
                Alamofire.request(SendMessageURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
                    
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
    
    
    
    func sendImagemessage(room_id:Int,message_kind:String,date:Int,file_link:Data,from_user_id:Int,to_user_id:Int,completion : @escaping(_ success: Bool,_ code:Int) -> () ){
        
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,
                       "Accept":"application/json"
        ]
        
                    let params:[String:Any] = [
                        "from_user_id":from_user_id,
                        "to_user_id":to_user_id,
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
                        to: SendMessageURL,
                        
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
    
    
    
    
    
    ///////////chat from Ads details
    func getAndCreatChatRoom(params:[String:Any],completion : @escaping(_ code: Int,_ result:JSON?) -> () ){
        let headers = ["Authorization":"Bearer "+UserDefaults.standard.string(forKey: "token")!,
                       "Accept":"application/json"
        ]
   
                 Alamofire.request(getChatRoomURL, method: .post, parameters: params, encoding:URLEncoding.default , headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
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
