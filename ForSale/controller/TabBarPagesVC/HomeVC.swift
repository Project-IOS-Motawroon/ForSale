

import UIKit
import SwiftyJSON
import MOLH

class HomeVC: UIViewController {
    var AdsHome = [JSON]()

    
    @IBOutlet weak var HomeAds: UITableView!
    
    let dev = UserDefaults.standard

    func is_login()->Bool{
        return UserDefaults.standard.bool(forKey: "is_login")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(homeChat), name: NSNotification.Name(rawValue: "homechat"), object: nil)
        if self.is_login() {
        let par:[String:Any] = [
            "user_id":dev.integer(forKey: "id"),
            "firebase_token":dev.string(forKey: "FCMToken") ?? "",
            "software_type":"ios"
        ]
            Auth_API().updateToken(prams: par) { (code) in
                if code == 200{
                    print("success to update firebase token")
                }else{
                    print("fail to update firebase token")
                }
            }
        }

    }
    @objc func homeChat(_ notification:Notification){
        guard let item = notification.userInfo?["message_send"] as? JSON else { return }

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatSegue") as! ChatVC
        //////send data
        print("awaddddd")
        vc.room_id = (item["chat_room_id"].stringValue as NSString).integerValue
    vc.to_user_id = item["from_user_id"].intValue != UserDefaults.standard.integer(forKey: "id") ? item["from_user_id"].intValue : item["to_user_id"].intValue
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if let item = adminChat{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatSegue") as! ChatVC
            //////send data
            print("awaddddd")
            vc.room_id = (item["chat_room_id"].stringValue as NSString).integerValue
            vc.to_user_id = item["from_user_id"].intValue != UserDefaults.standard.integer(forKey: "id") ? item["from_user_id"].intValue : item["to_user_id"].intValue
            self.navigationController?.pushViewController(vc, animated: true)
            adminChat = nil
        }
        HomeAds.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        HomeAds.dataSource = self
        HomeAds.delegate = self
          getHomeAds()
        self.tabBarController?.tabBar.isHidden = false
    }
    

    func getHomeAds(){
        BGLoading.instance.show(view)
        HomeAPI().getAdsHome{ (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result {
                    if data.count > 0 {
                        self.HomeAds.isHidden = false
                        self.AdsHome = data
                        self.HomeAds.reloadData()


                    }else{
                        self.HomeAds.isHidden = true
                    }
                }
            }else{
                self.HomeAds.isHidden = true
                self.showNoti("try")
            }
        }
        

    }
    
    
    
    
    @IBAction func showMenuBtn(_ sender: Any) {
        self.present(helperHelper.sideMenu("Main", "sidemenuIdentifier"), animated: true, completion: nil)
        
    }
    
    @IBAction func NotifactionPress(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "is_login"){
            performSegue(withIdentifier: "NotificationSegue", sender: self)              }else{
                  self.loginAlert()
              }
    }
    
    
    @IBAction func searchPress(_ sender: Any) {
        performSegue(withIdentifier: "SearchSegue", sender: self)

    }
    
}


extension HomeVC: UITableViewDataSource,UITableViewDelegate {


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165.0
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdsHome.count

    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as? AdsCell ,AdsHome.count > 0 { //
            cell.selectionStyle = UITableViewCell.SelectionStyle.none


            let pos = indexPath.row
            let item = AdsHome[pos]


            if(item["main_image"].string != nil){
                cell.imagee.setImage(from: ImageURL + item["main_image"].stringValue)
            }else{
                if let img = item["products_images"].array,img.count > 0{
                    print("&&&&&&&&&&&&&&&&\( img[0]["name"].stringValue)")

                    cell.imagee.setImage(from: ImageURL + img[0]["name"].stringValue)
                }
            }

            let DateAds: String = item["created_at"].stringValue;
            let DateAdsArr = DateAds.components(separatedBy: "T")
            let date: String = DateAdsArr [0]


            cell.label.text = item["title"].stringValue
            cell.name.text = item["user"]["name"].stringValue
            cell.date.text = date
            cell.place.text = item["address"].stringValue
            cell.price.text = item["price"].stringValue


//            if item["user_like"].dictionary != nil{
//            cell.favoritePress.setImage(UIImage(named: "Component 8 – 1" ), for: .normal)
//            }else{
//                cell.favoritePress.setImage(UIImage(named:"heart"), for: .normal)
//            }

            return cell
        }else{
            return UITableViewCell()
        }

    }

    //// To Navegat to other screen and send data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pos = indexPath.row
//            <<..
        let item = AdsHome[pos]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsDetailsVC") as! AdsDetailsVC
        //////send data
        vc.ads_id = item["id"].intValue
        vc.tt = item["title"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
      
        
    }
    
    
}

