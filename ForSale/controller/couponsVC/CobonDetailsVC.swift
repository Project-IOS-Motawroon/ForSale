

import UIKit

class CobonDetailsVC: UIViewController {
    var user_id:Int!
    var cobon_id:Int!
    var coponeLabelToCopy = ""
    var like:Bool!
    var dislike:Bool!

    @IBOutlet weak var LogoImg: UIImageView!
    @IBOutlet weak var titleCoupon: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var dateCoupon: UILabel!
    @IBOutlet weak var discountValueCoupon: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numberCoupon: UILabel!
    
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    
    @IBOutlet weak var dislikeCount: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        LogoImg.circleImage()
        LogoImg.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        getsingleCoupon()

    }

    func getsingleCoupon(){
        BGLoading.instance.show(view)
           print("cobon_id000000000000000000000000\(cobon_id)")


        Coupons_API().singleCoupon(coupon_id: cobon_id) { (code, result) in
            BGLoading.instance.dismissLoading()
            print(result as Any)
            if let data = result{
                
                ///////////// for like and dislike Image
                if data["data"]["like_action"].dictionary == nil{
                    self.dislike = false
                    self.like = false
                    self.likeButton.setImage(UIImage(named:"like1" ), for: UIControl.State.normal)
                    self.dislikeButton.setImage(UIImage(named:"dislike1" ), for: UIControl.State.normal)
                }else if data["data"]["like_action"]["type"].stringValue == "like" {
                    self.dislike = false
                    self.like = true
                    self.likeButton.setImage(UIImage(named:"Like" ), for: UIControl.State.normal)
                    self.dislikeButton.setImage(UIImage(named:"dislike1" ), for: UIControl.State.normal)
                            
                        }   else if data["data"]["like_action"]["type"].stringValue == "dislike"{
                            self.dislike = true
                            self.like = false
                            self.likeButton.setImage(UIImage(named:"like1" ), for: UIControl.State.normal)
                            self.dislikeButton.setImage(UIImage(named:"disLike" ), for: UIControl.State.normal)
                        }
                    
                

                /////////////////////////// for tabel

         
                self.titleCoupon.text = data["data"]["title"].stringValue
                self.brandName.text = data["data"]["brand_title"].stringValue
                self.dateCoupon.text = data["data"]["from_date"].stringValue
                self.discountValueCoupon.text = data["data"]["offer_value"].stringValue+"%"
                self.userName.text = data["data"]["user"]["name"].stringValue
                self.numberCoupon.text = data["data"]["coupon_code"].stringValue+"#"
                self.dislikeCount.text = data["data"]["dislikes_count"].stringValue
                self.likeCount.text = data["data"]["likes_count"].stringValue
                self.LogoImg.setImage(from: ImageURL + data["data"]["coupon_image"].stringValue)
                
                self.coponeLabelToCopy = data["data"]["coupon_code"].stringValue
             

                
            }
        }
        
        


        
    }

    
    @IBAction func Copy_Btn(_ sender: Any) {
        UIPasteboard.general.string = coponeLabelToCopy
        showAlert(message: "", title: "copyed")
    }
    
    
    @IBAction func likePress(_ sender: Any) {
        var bb = ""
        if like == true {
            bb = "deleteAction"
        }else{
            bb = "like"
        }
        
        let params = [
            "coupon_id" : String(cobon_id),
            "like_kind":bb
        ]
        BGLoading.instance.show(view)
    Coupons_API.instance.actionCoupon(params: params) { (code, result) in
           BGLoading.instance.dismissLoading()
            if code == 200 {
                self.getsingleCoupon()

            }else{
                self.showNoti("try")
            }
        }
    
        
    }
    
    @IBAction func dislikePress(_ sender: Any) {
        var cc = ""
        if dislike == true {
            cc = "deleteAction"
        }else{
            cc = "dislike"
        }
            let params = [
                "coupon_id" : String(cobon_id),
                "like_kind":cc
            ]
            BGLoading.instance.show(view)
        Coupons_API.instance.actionCoupon(params: params) { (code, result) in
               BGLoading.instance.dismissLoading()
                if code == 200 {
                    self.getsingleCoupon()

                }else{
                    self.showNoti("try")
                }
            }
        
    
    }
}
