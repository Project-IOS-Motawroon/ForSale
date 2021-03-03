//
//  OffersVC.swift
//  ForSale
//
//  Created by Mohamed on 12/9/20.
//

import UIKit
import SwiftyJSON
import MOLH

class OffersVC: UIViewController {
    var AdsOfferTB = [JSON]()
    var AdsOfferSliderCV  = [JSON]()

    
    @IBOutlet weak var offersTabelView: UITableView!
    
    @IBOutlet weak var offerSliderCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        offersTabelView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        offersTabelView.dataSource = self
        offersTabelView.delegate = self
          getAllOffersAds()
        
        //////////////////for collectionView
        offerSliderCV.register(UINib(nibName: "OffersCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OffersCollectionCell")
        offerSliderCV.delegate = self
        offerSliderCV.dataSource = self
        offerSliderCV.setCollectiontest(90, 4 )
        getofferSlider()
    }
    

    func getAllOffersAds(){
        BGLoading.instance.show(view)
        OfferAPI().getAdsAllOffer{ (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result {
                    if data.count > 0 {
                        self.offersTabelView.isHidden = false
                        self.AdsOfferTB = data
                        self.offersTabelView.reloadData()


                    }else{
                        self.offersTabelView.isHidden = true
                    }
                }
            }else{
                self.offersTabelView.isHidden = true
                self.showNoti("try")
            }
        }
        

    }
    
    
    func getofferSlider(){
        BGLoading.instance.show(view)
        OfferAPI().getOfferSlider{ (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result{
                    if data.count > 0 {
                        
                        self.AdsOfferSliderCV = MOLHLanguage.currentAppleLanguage() == "ar" ? data.reversed() : data
                        self.offerSliderCV.reloadData()
                        if MOLHLanguage.currentAppleLanguage() == "ar"{
                        self.offerSliderCV.scrollToItem(at: IndexPath(row: data.count - 1, section: 0), at: .right, animated: false)
                        }
                    }
                }
            }else{
                print("code \(code)")
            }
        }
    }
    


    
    
}


extension OffersVC: UITableViewDataSource,UITableViewDelegate {


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdsOfferTB.count

    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell ,AdsOfferTB.count > 0 { //
            cell.selectionStyle = UITableViewCell.SelectionStyle.none


            let pos = indexPath.row
            let item = AdsOfferTB[pos]


            if(item["main_image"].string != nil){
                cell.logo.setImage(from: ImageURL + item["main_image"].stringValue)
            }else{
                if let img = item["products_images"].array,img.count > 0{
                    print("&&&&&&&&&&&&&&&&\( img[0]["name"].stringValue)")

                    cell.logo.setImage(from: ImageURL + img[0]["name"].stringValue)
                }
            }

//            let DateAds: String = item["created_at"].stringValue;
//            let DateAdsArr = DateAds.components(separatedBy: "T")
//            let date: String = DateAdsArr [0]


            cell.title.text = item["title"].stringValue
            cell.details.text = item["desc"].stringValue
            cell.oldPrice2.text = item["old_price"].stringValue
            cell.Price.text = item["price"].stringValue
            cell.discountValue.text = item["offer_value"].stringValue + " %"

            cell.SAR1.text = "SAR".localized()
            cell.SAR2.text = "SAR".localized()


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
        let item = AdsOfferTB[pos]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsDetailsVC") as! AdsDetailsVC
        //////send data
        vc.ads_id = item["id"].intValue
        vc.tt = item["title"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)   

    }
    
    
}

extension OffersVC: UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AdsOfferSliderCV.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCollectionCell", for: indexPath) as? OffersCollectionCell,AdsOfferSliderCV.count > 0 {
            let pos = indexPath.row
            let item = AdsOfferSliderCV[pos]
            cell.discountValue.text = item["offer_value"].stringValue
            cell.logo.setImage(from: ImageURL + item["main_image"].stringValue)
            return cell
        }else{
            return UICollectionViewCell()
        }
       }
    
    //// To Navegat to other screen and send data

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = AdsOfferSliderCV[indexPath.row]
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsDetailsVC") as! AdsDetailsVC
        //////send data
        vc.ads_id = item["id"].intValue
        vc.tt = item["title"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    


    
}
