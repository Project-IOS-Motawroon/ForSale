
import UIKit
import Alamofire
import SwiftyJSON

class OfferAPI: NSObject {
    let defaults = UserDefaults.standard

    func getAdsAllOffer (completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
        
        
        Alamofire.request(getAllOffersURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
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

    func getOfferSlider  (completion : @escaping(_ code: Int,_ result:[JSON]?) -> () ){
        
        
        Alamofire.request(getOfferSliderURL, method: .get, parameters: nil, encoding:URLEncoding.default , headers: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            
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
