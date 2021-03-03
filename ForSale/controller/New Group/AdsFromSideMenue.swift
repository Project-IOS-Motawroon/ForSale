//
//  AdsFromSideMenue.swift
//  ForSale
//
//  Created by Mohamed on 12/23/20.
//

import UIKit
import SwiftyJSON
import MOLH

class AdsFromSideMenue: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource {

    
    var catid = -1
    var subCatid = -1
    
    var cats = [JSON]()
    var Advertisement = [JSON]()

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
          collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
          collectionView.delegate = self
          collectionView.dataSource = self
//          collectionView.setCollectionLayOut(115, 4)
          getCats()

        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        tableView.dataSource = self
        tableView.delegate = self
        getAdvertisement()
        

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell,cats.count > 0 {
            let pos = indexPath.row
            let item = cats[pos]
            cell.label.text = item["title"].stringValue
            return cell
        }else{
            return UICollectionViewCell()
        }
       }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = cats[indexPath.row]
        subCatid = item["id"].intValue
        getAdvertisement(String(item["id"].intValue))
        // ageb el rest lekol cats mo5tlef
    }
    func getCats(){
        var params = [String:Any]()
        BGLoading.instance.show(view)
         params["sub_category_id"] = String(subCatid)
        HomeAPI.instance.getTypesByCatOrSubCate(params: params) { (code, result)in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result{
                    if data.count > 0 {
                        
                        self.cats = MOLHLanguage.currentAppleLanguage() == "ar" ? data.reversed() : data
                        self.collectionView.reloadData()
                        if MOLHLanguage.currentAppleLanguage() == "ar"{
                        self.collectionView.scrollToItem(at: IndexPath(row: data.count - 1, section: 0), at: .right, animated: false)
                        }
                    }
                }
            }else{
                print("code \(code)")
            }
        }
    }
    
    func getAdvertisement(_ departemnt_id:String = ""){
//        var params = [String:Any]()
            BGLoading.instance.show(view)
   
        
        let params:[String:Any] = ["category_id":String(catid),
                                   "using_user_location":"no",
                                   "using_price":"no"
        ]
        print("dsfsfsd\(params)")
        HomeAPI.instance.getproductFilterByCategory(params: params) { (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result {
                    if data.count > 0 {
                        self.tableView.isHidden = false
                        self.Advertisement = data
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


extension AdsFromSideMenue: UITableViewDataSource,UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165.0
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Advertisement.count

    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as? AdsCell ,Advertisement.count > 0 { //
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            
            let pos = indexPath.row
//            <<..
            let item = Advertisement[pos]
            
            
                cell.imagee.setImage(from: ImageURL + item["main_image"].stringValue)
         
            
            let myString: String = item["created_at"].stringValue;
            let myStringArr = myString.components(separatedBy: "T")
            let date: String = myStringArr [0]


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
        let item = Advertisement[pos]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsDetailsVC") as! AdsDetailsVC
        //////send data
        vc.ads_id = item["id"].intValue
        vc.tt = item["title"].stringValue
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    
    
    
}

