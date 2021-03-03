import UIKit
import DropDown
import SwiftyJSON
import GoogleMaps


class AddAdsVC: UIViewController,ImagePickerDelegate,VideoPickerDelegate,GMSMapViewDelegate,CLLocationManagerDelegate {


    
    @IBOutlet weak var oldPriceTF: UITextField!
    @IBOutlet weak var discountTF: UITextField!
    @IBOutlet weak var DiscountView: UIView!
    var unchecked = false
    @IBOutlet weak var chechButton: UIButton!
    
    @IBOutlet weak var checkSwearPress: UIButton!
    var uncheckedSwear = false
    var cats = [JSON]()
    var cats_names = [String]()
    var selectedCat_id = -1
    
    var Subcats = [JSON]()
    var Sub_cats_names = [String]()
    var selectedSubCat_id = -1

    var typesBySubcate = [JSON]()
    var typesBySubcate_names = [String]()
    var selectedTypesBySubcate_id = -1
    
    var listTF = [JSON]()
    @IBOutlet weak var tableConst: NSLayoutConstraint!
    
    var param = [String:Any]()
    ///////////for images
    var imgs = [UIImage]()
    var imgsData = [Data]()
    var imagePicker:ImagePicker!

    
    @IBOutlet weak var videoView: VideoView!
    var videoPicker:VideoPicker!
    var videoURL:URL?
    var ad_video:URL?
    
    @IBOutlet weak var addressTF: UITextField!
    var locationManager = CLLocationManager()
       var google_lat:Double?
       var google_long:Double?
    
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    
    @IBOutlet weak var selectCat: UIButton!
    @IBOutlet weak var subeCatView: UIView!
    @IBOutlet weak var selectTypesBySubCate: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var details_tv: UITextView!
    @IBOutlet weak var price_tf: UITextField!
    @IBOutlet weak var nameAdvertising: UITextField!
    
    
//    override func viewWillAppear(_ animated: Bool) {
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unchecked = false
        uncheckedSwear = false
        DiscountView.isHidden = true
        subeCatView.isHidden = true
        selectTypesBySubCate.isHidden = true
        tableConst.constant = 0.0
        getCats()
        tableView.register(UINib(nibName: "AddTextCell", bundle: nil), forCellReuseIdentifier: "AddTextCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        //////////////////////////////////
        collectionView.register(UINib(nibName: "AdsImageCell", bundle: nil), forCellWithReuseIdentifier: "AdsImageCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionLayOut(90, 4)
        /////////////////////////////////
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        viewMap.delegate = self
        
    }
    
    func getCats(){
        BGLoading.instance.show(view)
        AllCategoriesForSlid_API().getAllCategories { (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result{
                    if data.count > 0 {
                        self.cats = data
                        for item in data{
                            self.cats_names.append(item["title"].stringValue)
                        }
                    }
                }
            }else{
                print("code \(code)")
            }
        }
    }
    
    ///////////for images
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        imgs.append(image)
        imgsData.append(image.jpegData(compressionQuality: 0.7)!)
        collectionView.reloadData()
    }
    
    ///for upload video
    //after add video View Inherit from class VideoView
    
    func didSelect(url: URL?) {
        guard let url = url else {
            return
        }
        self.videoURL = url
        videoView.configureVideo(url: url)
        videoView.play()
    }
    
    @IBAction func uploadImage1(_ sender: UIButton) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func videoButton(_ sender: UIButton) {
        self.videoPicker = VideoPicker(presentationController: self, delegate: self)
        self.videoPicker.present(from: sender)
        
    }
    
    
    
    
    
    ///for map
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// location
//    var locationManager = CLLocationManager()
var lat:Double?
var lon:Double?



var onLoc = true
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if onLoc {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //  print("locations \(locValue.latitude) \(locValue.longitude)")
        let userLocation = locations.last!
        lat = userLocation.coordinate.latitude
        lon = userLocation.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 9.0)
        viewMap.camera = camera
        viewMap.isMyLocationEnabled = true
        viewMap.settings.compassButton = true
        viewMap.settings.myLocationButton = true
        reverseGeocodeCoordinate(locValue)
        // Add a Custom marker
        let markerSquirt = GMSMarker()
        markerSquirt.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        markerSquirt.map = viewMap
        onLoc = false
    }
}
func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    lat = coordinate.latitude
    lon = coordinate.longitude
    let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 9.0)
    viewMap.camera = camera
    //        viewMap.isMyLocationEnabled = true
    //        viewMap.settings.compassButton = true
    //        viewMap.settings.myLocationButton = true
    viewMap.clear()
    reverseGeocodeCoordinate(coordinate)
    let markerSquirt = GMSMarker()
    markerSquirt.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    markerSquirt.map = viewMap
}
private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
    // 1
    let geocoder = GMSGeocoder()
    // 2
    geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
            return
        }
        // 3
        print("the lines is \(lines.joined(separator: "\n"))")
        self.addressTF.text = lines.joined(separator: "\n")
        // 4
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
        textView.text = nil
        textView.textColor = UIColor.black
    }
}
func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = "details".localized()
        textView.textColor = UIColor.lightGray
    }
}

    
    
    
    
    
    
    
    
    
    @IBAction func slectCatPress(_ sender: UIButton) {
        print("ddsss \(cats_names)")
        if cats.count > 0 {
            self.drop(anchor: sender, dataSource: cats_names) { (item, index) in
                sender.setTitle(item, for: .normal)
            print("bnnbnmmmmmm \(item)")
                self.selectedCat_id = self.cats[index]["id"].intValue
                ////for remove data from list
                self.Subcats.removeAll()
                self.Sub_cats_names.removeAll()
                self.selectedSubCat_id = -1
                
print( self.selectedCat_id)
                print( "0000000000000")

                self.getsubCateByBasicCatId(self.selectedCat_id)
                
            }
        }
    }
    func getsubCateByBasicCatId(_ dptID:Int){
        subeCatView.isHidden = false
        BGLoading.instance.show(view)
        ADS_API().getsubCateByBasicCatId (CatIdId: dptID) { (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result{
                    if data.count > 0 {
                        self.Subcats = data
                        for item in data{
                            self.Sub_cats_names.append(item["title"].stringValue)
                        }
                    }
                }
            }else{
                print("code \(code)")


            }
        }
    }
    
    
    @IBAction func subCatPress(_ sender: UIButton) {
        print("ddsss \(cats_names)")
        if Subcats.count > 0 {
            self.drop(anchor: sender, dataSource: Sub_cats_names) { (item, index) in
                sender.setTitle(item, for: .normal)
            print("bnnbnmmmmmm \(item)")
                self.selectedSubCat_id = self.Subcats[index]["id"].intValue
                ////for remove data from list
                self.typesBySubcate.removeAll()
                self.typesBySubcate_names.removeAll()
                self.selectedTypesBySubcate_id = -1
                
print( self.selectedSubCat_id)
                print( "111111111111")

                self.getSelectTypesBySubCate(self.selectedSubCat_id)
                self.gettAttribuitesFromSubCategory(self.selectedSubCat_id)

            }
        }
    }
    
    func getSelectTypesBySubCate(_ dptIID:Int){
        selectTypesBySubCate.isHidden = false
        BGLoading.instance.show(view)
        ADS_API().getTypesBySubcateId (CatIdId: dptIID) { (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result{
                    if data.count > 0 {
                        self.typesBySubcate = data
                        for item in data{
                            self.typesBySubcate_names.append(item["title"].stringValue)
                        }
                    }
                }
            }else{
                print("code \(code)")


            }
        }
    }
    func gettAttribuitesFromSubCategory(_ dptIID:Int){
        BGLoading.instance.show(view)
        ADS_API().getAttribuitesFromSubCategory (CatIdId: dptIID) { (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result{
                    if data.count > 0 {
                        print(")kokokokokookokokookokokokookokokokokokookokookoko")
                        self.listTF = data
                        self.tableView.reloadData()
                        self.tableConst.constant = CGFloat(data.count * 95)
                    }
                }
            }else{
                print("code \(code)")


            }
        }
    }
    
    @IBAction func SelectTypesBySubCatePress(_ sender: UIButton) {
        if typesBySubcate.count > 0 {
            self.drop(anchor: sender, dataSource: typesBySubcate_names) { (item, index) in
                sender.setTitle(item, for: .normal)
            print("bnnbnmmmmmm \(item)")
                self.selectedTypesBySubcate_id = self.typesBySubcate[index]["id"].intValue
               
print( self.selectedTypesBySubcate_id)
                print( "2222222222222")

                
            }
        }
    }
    
    
    @IBAction func checkBoxPress(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("this is button 0")
            if unchecked == false {
                self.chechButton.setImage(UIImage(named:"check-mark" ), for: UIControl.State.normal)
                self.chechButton.tintColor = #colorLiteral(red: 0.6313980222, green: 0.1014319137, blue: 0.1613987982, alpha: 1)
                unchecked = true
                DiscountView.isHidden = false
            }else{
                self.chechButton.tintColor = nil
                self.chechButton.setImage(UIImage(named: ""), for: UIControl.State.normal)
                unchecked = false
                DiscountView.isHidden = true
                self.discountTF.text = nil
                self.oldPriceTF.text = nil
            }
            print(unchecked)
        case 1:
            ////  checked Swear press
            print("this is button 1")
            if uncheckedSwear == false {
                self.checkSwearPress.setImage(UIImage(named:"check-mark" ), for: UIControl.State.normal)
                self.checkSwearPress.tintColor = #colorLiteral(red: 0.6313980222, green: 0.1014319137, blue: 0.1613987982, alpha: 1)
                uncheckedSwear = true
                self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SwearVC"), animated: true)
                
            }else{
                self.checkSwearPress.setImage(UIImage(named: ""), for: UIControl.State.normal)
                self.checkSwearPress.tintColor = nil
                uncheckedSwear = false

            }
            print(uncheckedSwear)
   
        default:
            print("unknown button")
        }
        

        
        

    }
    
    
    
    
    
    
    
    ///////////// validate Data Before send data
     var product_details = [[String:Any]]()
    func validateData()-> Bool{
        if unchecked == true {
            guard !discountTF.text!.isEmpty else {
                self.showAlert(message: "enter discount Value".localized())
                return false
            }
            guard !oldPriceTF.text!.isEmpty else {
                self.showAlert(message: "enter old price Value".localized())
                return false
            }
        }
        guard !nameAdvertising.text!.isEmpty else {
            self.showAlert(message: "enter Ads Name".localized())
            return false
        }
        guard selectedCat_id != -1 else {
            self.showAlert(message: "choose department".localized())
            return false
        }
        
        guard selectedSubCat_id != -1 else {
            self.showAlert(message: "choose sub department".localized())
            return false
        }
        guard selectedTypesBySubcate_id != -1 else {
            self.showAlert(message: "choose type department".localized())
            return false
        }
        guard imgsData.count > 0 else {
            self.showAlert(message: "choose Ads imgae".localized())
            return false
        }
        guard videoURL != nil else {
            self.showAlert(message: "Choose the Ads video".localized())
            return false
        }
        product_details.removeAll()
        var xx = -1
        var x = 0
        for ite in listTF{
            let cell = tableView.cellForRow(at: IndexPath(row: x, section: 0)) as! AddTextCell
            if cell.textField.text!.isEmpty{
                xx += 1
            }
            x += 1
        }
        guard xx == -1 else {
            self.showAlert(message: "complete all required data".localized())
            return false
        }
        
        var index = 0
        for ite in listTF{
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! AddTextCell
            let para:[String:Any] = [
                "title":ite["title"].stringValue,
                "icon":ite["icon"].stringValue,
                "content":cell.textField.text!
            ]
            product_details.append(para)
            index += 1
        }
        print("salmooon \(product_details)")
        guard !price_tf.text!.isEmpty else {
            self.showAlert(message: "enter Ads Price".localized())
            return false
        }
        
        guard lat != nil , lon != nil else {
            self.showAlert(message: "choose location on map".localized())
            return false
        }
        return true
    }
    
    var haveOffer = ""
    
    
    @IBAction func addAdsBTN(_ sender: Any) {
        guard validateData() else {
            self.showAlert(message: "enter all required data".localized())
            return
        }
        if unchecked {
        haveOffer = "with_offer"
        }else{
        haveOffer = "without_offer"
        }
        
        if uncheckedSwear == false {
            self.showAlert(message: "The oath must be approved".localized())
            return
        }
        
        if UserDefaults.standard.bool(forKey: "is_login"){
            
            
                  BGLoading.instance.show(view)
                 param = [
                      "title": nameAdvertising.text!,
                      "category_id": selectedCat_id,
                      "sub_category_id": selectedSubCat_id,
                      "price": (price_tf.text! as NSString).integerValue,
                      "address": addressTF.text!,
                      "latitude": lat!,
                      "longitude": lon!,
                      "desc": details_tv.text!,
                      "have_offer": haveOffer,
                  ]
                  if !oldPriceTF.text!.isEmpty{
                      param["old_price"] = oldPriceTF.text!
                  }else{
                      param["old_price"] = price_tf.text!
                  }
                  if !discountTF.text!.isEmpty{
                      param["offer_value"] = discountTF.text!
                  }else{
                      param["offer_value"] = "0"
                  }
                  
                  ADS_API().addAds(params: param, ad_images: imgsData,main_image: imgsData[0], ad_video: videoURL!, product_details: product_details) { (status, code) in
                      
                      BGLoading.instance.dismissLoading()
                      if code == 200 {
                          print("ads added successfully")
                          self.ftt("Ad has been added".localized())

                          self.navigationController?.popToRootViewController(animated: true)



                      }else{
                          print("fail to add ads with code \(code)")
                      }
                  }
            
        }else{
            self.showAlertLogin()
        }
        
    }
    

    }









extension AddAdsVC: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTF.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddTextCell", for: indexPath) as? AddTextCell,listTF.count > 0 {
            let pos = indexPath.row
            let item = listTF[pos]
            cell.icon.setImage(from: ImageURL + item["icon"].stringValue)
            cell.name.text = item["title"].stringValue
            cell.textField.placeholder = item["title"].stringValue
            return cell
        }else{ return UITableViewCell() }
    }
    
}






extension AddAdsVC: UICollectionViewDelegate,UICollectionViewDataSource {
    ///collectionView for images
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsImageCell", for: indexPath) as? AdsImageCell,imgs.count > 0 {
            let pos = indexPath.row
            let item = imgs[pos]
            cell.img.image = item
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
}
