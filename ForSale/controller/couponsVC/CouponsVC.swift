
import UIKit
import SwiftyJSON
import MOLH

class CouponsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {


    
    var Coupons = [JSON]()
    var coponeLabelToCopy = ""
    

    
    @IBOutlet weak var tabelView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabelView.register(UINib(nibName: "CouponsCell", bundle: nil), forCellReuseIdentifier: "CouponsCell")
        tabelView.dataSource = self
        tabelView.delegate = self
          getCoupons()
    }
    

    func getCoupons(){
        BGLoading.instance.show(view)
        Coupons_API().GetCoupons{ (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result {
                    if data.count > 0 {
                        self.tabelView.isHidden = false
                        self.Coupons = data
                        self.tabelView.reloadData()


                    }else{
                        self.tabelView.isHidden = true
                    }
                }
            }else{
                self.tabelView.isHidden = true
                self.showNoti("try")
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Coupons.count

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CouponsCell", for: indexPath) as? CouponsCell ,Coupons.count > 0 { //
            cell.selectionStyle = UITableViewCell.SelectionStyle.none


            let pos = indexPath.row
            let item = Coupons[pos]


             coponeLabelToCopy = item["coupon_code"].stringValue


            cell.logo.setImage(from: ImageURL + item["coupon_image"].stringValue)

            cell.mainLabel.text = item["title"].stringValue
            cell.coponeLabel.text = item["brand_title"].stringValue
            cell.dateLabel.text = item["from_date"].stringValue
            cell.discountLabel.text = item["offer_value"].stringValue+"%"
            cell.nameUserLabel.text = item["user"]["name"].stringValue
            cell.coponeLabel.text = item["coupon_code"].stringValue+"#"

            cell.copyButton.tag = pos
            cell.copyButton.addTarget(self, action: #selector(copyPress), for: .touchUpInside)


            return cell
        }else{
            return UITableViewCell()
        }

    }
    
    @objc func copyPress(_ sender: UIButton) {
        UIPasteboard.general.string = coponeLabelToCopy
        showAlert(message: "", title: "copyed")
        
    }
    
    // To Navegat to other screen and send data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pos = indexPath.row
//            <<..
        let item = Coupons[pos]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CobonDetailsVC") as! CobonDetailsVC
        //////send data
        vc.cobon_id = item["id"].intValue
        vc.user_id = item["user_id"].intValue
        if UserDefaults.standard.bool(forKey: "is_login"){
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
                  self.loginAlert()
              }

    }
    
    
    
    @IBAction func addCouponPress(_ sender: Any) {
        performSegue(withIdentifier: "addCouponSegue", sender: self)
    }
    
    
}

