
import UIKit
import SwiftyJSON

class MyAdsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var rests = [JSON]()
    var rest:JSON!
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {

        BGLoading.instance.show(view)
        self.title = "My Ads".localized()
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
          tableView.delegate = self
          tableView.dataSource = self
        getMyAds()
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165.0
       }
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return rests.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as? AdsCell,rests.count > 0 {
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    let pos = indexPath.row
                    let item = rests[pos]


//            if(item["main_image"].string != nil){
                cell.imagee.setImage(from: ImageURL + item["main_image"].stringValue)
//            }else{
//                if let img = item["products_images"].array,img.count > 0{
//                    print("&&&&&&&&&&&&&&&&\( img[0]["name"].stringValue)")
//
//                    cell.imagee.setImage(from: ImageURL + img[0]["name"].stringValue)
//                }
//            }

            let DateAds: String = item["created_at"].stringValue;
            let DateAdsArr = DateAds.components(separatedBy: "T")
            let date: String = DateAdsArr [0]


            cell.label.text = item["title"].stringValue
            cell.name.text = item["user"]["name"].stringValue
            cell.date.text = date
            cell.place.text = item["address"].stringValue
            cell.price.text = item["price"].stringValue
            

            
                    return cell
                }else{
                    return UITableViewCell()
                }
    }
    //// To Navegat to other screen and send data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pos = indexPath.row
//            <<..
        let item = rests[pos]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsDetailsVC") as! AdsDetailsVC
        //////send data
        vc.ads_id = item["id"].intValue
        vc.tt = item["title"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    


    
    func getMyAds(){
        BGLoading.instance.show(view)
        myAds_API.instance.myAds{ (code, result) in
            BGLoading.instance.dismissLoading()
                        if code == 200 {
                            if let data = result {
                                if data.count > 0 {

                                    self.tableView.isHidden = false
                                    self.rests = data
                                    self.tableView.reloadData()

                                }else{
                                    self.tableView.isHidden = true
                                }
                            }
                        }else{
                            self.tableView.isHidden = true
                            self.showNoti("try")
                        }
        }
    }

}
