

import UIKit
import SwiftyJSON
import SVProgressHUD
import ImageSlideshow
import SDWebImage

class AdsDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
 

    
    @IBOutlet weak var locationViewwHeight: NSLayoutConstraint!
    
    var tt = ""
    let is_login = UserDefaults.standard.bool(forKey: "is_login")
    var ads_id = 0
    var list = [JSON]()
    var listImageSlider = [JSON]()
    var product_types = [JSON]()
    var AdsOnerId = -1


    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var nameUser: UILabel!
    
    @IBOutlet weak var phoneUser: UILabel!
    
    @IBOutlet weak var addressUser: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var tableConst: NSLayoutConstraint!
    
    @IBOutlet weak var stakAddress: UIStackView!
    
    var whatsAppPhone:String!
    var PhoneNumber:String!
    @IBOutlet weak var nameAds: UILabel!
    @IBOutlet weak var priceAds: UILabel!
    @IBOutlet weak var adsDetails: UILabel!
    @IBOutlet weak var discountValue: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    
    @IBOutlet weak var productTypes: UILabel!
    @IBOutlet weak var FavButtoni: UIButton!
    
    @IBOutlet weak var ReportButton: UIButton!
    

    override func viewWillAppear(_ animated: Bool) {
                tableConst.constant = 0.0
                getAdsDetails()
                self.title = tt
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        tableview.register(UINib(nibName: "DetailsAddTextCell", bundle: nil), forCellReuseIdentifier: "DetailsAddTextCell")
        tableview.delegate = self
        tableview.dataSource = self
    


    }

              
        func configSliderShow(_ slideView:ImageSlideshow,_ SlideImages:[JSON]) {
            slideView.slideshowInterval = 3.0
            slideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
            slideView.contentScaleMode = UIView.ContentMode.scaleToFill
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#3B0867")
            pageControl.pageIndicatorTintColor = UIColor.blue
            slideView.pageIndicator = pageControl
            slideView.activityIndicator = DefaultActivityIndicator()
    //        slideView.activityIndicator = DefaultActivityIndicator(style: .gray , color: nil )
            slideView.addSubview(pageControl)
            slideShow(slideView,SlideImages)
        }

        func slideShow(_ slideView:ImageSlideshow,_ slideImages:[JSON]) {
            var imgSource = [InputSource]()
            for item in slideImages{
                imgSource.append(SDWebImageSource(urlString: ImageURL + item["image"].stringValue)!)
            }
            slideView.setImageInputs(imgSource)

        }

    
    /////////// for tabel view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsAddTextCell", for: indexPath) as? DetailsAddTextCell,list.count > 0 {
            let pos = indexPath.row
            let item = list[pos]
            cell.icon.setImage(from: ImageURL + item["icon"].stringValue)
            cell.label1.text = item["title"].stringValue
            cell.label2.text = item["value"].stringValue
            return cell
        }else{ return UITableViewCell() }
    }
    
    /////////////////////
    func getAdsDetails(){
//        if is_login{
            BGLoading.instance.show(view)
           print("ads_id000000000000000000000000\(ads_id)")


            ADS_API().singleAds(ads_id: ads_id) { [self] (code, result) in
                BGLoading.instance.dismissLoading()
                print(result as Any)
                if let data = result{
                    ////// for  favorite image
                    print("nnmmvb \(data["data"]["user_like"].dictionaryValue)")
                    if data["data"]["is_favorite"].stringValue == "no" {
                        self.FavButtoni.setImage(UIImage(named:"loveDetails" ), for: UIControl.State.normal)
                        self.FavButtoni.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    }else{
                        self.FavButtoni.setImage(UIImage(named: "loveDetails"), for: UIControl.State.normal)
                        self.FavButtoni.tintColor = #colorLiteral(red: 0.6313980222, green: 0.1014319137, blue: 0.1613987982, alpha: 1)

                    }
                    if data["data"]["is_report"].stringValue == "no" {
                        self.ReportButton.setImage(UIImage(named:"reporticon" ), for: UIControl.State.normal)
                        self.ReportButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    }else{
                        self.ReportButton.setImage(UIImage(named: "reporticon"), for: UIControl.State.normal)
                        self.ReportButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

                    }
                    
                    /////////////////////////// for tabel
                    self.list = data["data"]["product_details"].arrayValue
                    if self.list.count > 0 {
                        print(")kokokokokookokokookokokokookokokokokokookokookoko")
                        self.tableview.reloadData()
                        self.tableConst.constant = CGFloat(self.list.count * 50)
                    }
                    print(".................\(self.list.count)")
                    ///////////////////
                    
                    //////////////////////////// for image slider
                    self.listImageSlider = data["data"]["product_images"].arrayValue
                    if self.listImageSlider.count > 0 {
                        print("12345")
                        self.configSliderShow(self.slideShow, self.listImageSlider)
                    }else{
                        self.slideShow.isHidden = true
                    }
                    print("??????????????????\(self.listImageSlider.count)")
                    
                    ///////////////////////////////
             
                    self.nameAds.text = data["data"]["title"].stringValue
                    self.priceAds.text = data["data"]["price"].stringValue
                    self.adsDetails.text = data["data"]["desc"].stringValue
                    self.oldPrice.text = data["data"]["old_price"].stringValue
                    self.discountValue.text = data["data"]["offer_value"].stringValue
                     
                    self.product_types = data["data"]["product_types"].arrayValue
                    if self.product_types.count > 0 {
                        print("--------")

                        self.productTypes.text = product_types[0]["type"]["title"].stringValue
                    }
                    
                    self.AdsOnerId = data["data"]["user"]["id"].intValue
                    self.nameUser.text = data["data"]["user"]["name"].stringValue
                    self.phoneUser.text = data["data"]["user"]["phone_code"].stringValue+data["data"]["user"]["phone"].stringValue
                    if data["data"]["user"]["address"].string == nil {
                        self.stakAddress.isHidden = true
                        locationViewwHeight.constant = 0
                    }else{
                        self.addressUser.text = data["data"]["user"]["address"].stringValue
                        locationViewwHeight.constant = 25

                        
                    }
       
                    
                }
//            }

        
    }

}
    
    @IBAction func CopyPress(_ sender: Any) {
                UIPasteboard.general.string = phoneUser.text!
        showAlert(message: "", title: "copyed")
        
    }
    
    @IBAction func CallPress(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneUser.text!)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    @IBAction func WhatsPress(_ sender: Any) {
        self.openWhatsApp(phoneUser.text!)
    }
    
    @IBAction func FAVPress(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "is_login"){
//        let pos = sender.tag
//        let item = rests[pos]
            let params = [
                "product_id" : ads_id,
            ]
            BGLoading.instance.show(view)
            Favorite_Api.instance.actionFav(params: params) { (code, result) in
               BGLoading.instance.dismissLoading()
                if code == 200 {
                    self.getAdsDetails()

                }else{
                    self.showNoti("try")
                }
            }
        
        }else{
            self.loginAlert()
        }
    }
    
    @IBAction func ReportAdsPress(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "is_login"){
//        let pos = sender.tag
//        let item = rests[pos]
            let params:[String : Any] = [
                "product_id" : ads_id,
                "title" : "title",
            ]
            print("mmmmm \(params)")
            BGLoading.instance.show(view)
            Favorite_Api.instance.ReportAds(params: params) { (code, result) in
               BGLoading.instance.dismissLoading()
                if code == 200 {

                    self.ftt("It has been reported".localized())

                    
                }else{
                    self.showNoti("try")
                }
            }
        
        }else{
            self.loginAlert()
        }
    }

    
////////////    to send data to other screen  by Segue
    @IBAction func chatPress(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "is_login"){
            
            if String(AdsOnerId) == UserDefaults.standard.string(forKey: "id")! {
                showAlert(message: "You are the owner of this advertisement!".localized())
            }else{
                performSegue(withIdentifier: "chatFormAdsDetailsSegue", sender: self)

            }
        }else{
                  self.loginAlert()
              }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "chatFormAdsDetailsSegue" {
                let des = segue.destination as! chatFormAdsDetailsVC
                des.AdsOnerId = AdsOnerId
            }
}
    
}
