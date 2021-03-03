
import UIKit
import CalendarFoundation

class AddNewCouponVC: UIViewController,ImagePickerDelegate {

    var imagePicker: ImagePicker!
    var user_imageData:Data?


    @IBOutlet weak var fromDateTxt: UITextField!
    @IBOutlet weak var logoCoupon: UIImageView!
    @IBOutlet weak var titleTF: UITextField!

    @IBOutlet weak var brandTitleTF: UITextField!
    @IBOutlet weak var couponCodeTF: UITextField!

    @IBOutlet weak var offerValueTF: UITextField!
    var birthDate = ""
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoCoupon.circleImage()
//        logoCoupon.layer.cornerRadius = 75.0
        logoCoupon.clipsToBounds = true
        logoCoupon.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        logoCoupon.layer.borderWidth = 1.0

        fromDateTxtPicker()

        // Do any additional setup after loading the view.
    }




    @IBAction func uplodLogoPress(_ sender: UIButton) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }

    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        logoCoupon.image = image
        logoCoupon.contentMode = .scaleAspectFit
        user_imageData = image.jpegData(compressionQuality: 0.7)!
    }



    //    pick Date
            func fromDateTxtPicker (){
                fromDateTxt.textAlignment = .center
        //        toolbar
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
        //        barButton
                let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
                toolbar.setItems([doneBtn], animated: true)
        //        assign toolbar
                fromDateTxt.inputAccessoryView = toolbar
        //        assign date picker to the text field
                fromDateTxt.inputView = datePicker
    //            datePicker.calendar.

                //        date picker mode
                datePicker.datePickerMode = .date
            }
            @objc func donePressed(){
        //        formatter
                let Formatter = DateFormatter()
                Formatter.dateFormat = "yyyy-MM-dd"
                fromDateTxt.text = Formatter.string(from: datePicker.date)
                print("Date\(fromDateTxt.text!)")
                 let fromDate = fromDateTxt.text!
                self.view.endEditing(true)
            }

//    //    pick Date
//            func toDateTxtPicker (){
//                toDateTF.textAlignment = .center
//        //        toolbar
//                let toolbar = UIToolbar()
//                toolbar.sizeToFit()
//        //        barButton
//                let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
//                toolbar.setItems([doneBtn], animated: true)
//        //        assign toolbar
//                toDateTF.inputAccessoryView = toolbar
//        //        assign date picker to the text field
//                toDateTF.inputView = datePicker
//    //            datePicker.calendar.
//
//                //        date picker mode
//                datePicker.datePickerMode = .date
//            }
//            @objc func donePressed2(){
//        //        formatter
//                let Formatter = DateFormatter()
//                Formatter.dateFormat = "yyyy-MM-dd"
//                toDateTF.text = Formatter.string(from: datePicker.date)
//                print("Date\(toDateTF.text!)")
//               let toDate = toDateTF.text!
//                self.view.endEditing(true)
//            }


   


    @IBAction func addButton(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "is_login"){
        let  title = titleTF.text!
        let  brandTitle = brandTitleTF.text!
        let  couponCode = couponCodeTF.text!
        let  offerValue = offerValueTF.text!
        let  fromDate = fromDateTxt.text!

        if (titleTF.text!.isEmpty) || (brandTitleTF.text!.isEmpty) || (couponCodeTF.text!.isEmpty) || (offerValueTF.text!.isEmpty) || (fromDateTxt.text!.isEmpty) || (user_imageData == nil){
            self.showAlert(message: "complete all required data".localized())

        }else{
            BGLoading.instance.show(view)

            print(";;;ok")
            Coupons_API.instance.addCoupons(title: title, brandTitle: brandTitle, couponCode: couponCode,offerValue: offerValue,fromDate: fromDate, logo: user_imageData) { (code, result) in
                BGLoading.instance.dismissLoading()
                if code == 200 {
                    if let data = result {
                        print("..........\(result)")
//                        self.status_code2 = data["status"].intValue
                        if data["status"].stringValue == "200" {
                            print("code \(code)_1__________________________")
                            self.showNoti("Add Coupon fully".localized())
                            //<...
                            self.navigationController?.popViewController(animated: true)

                        }else if data["status"].stringValue == "402"{
                            self.showNoti(data["message"].stringValue)
                            print("code \(code)_2__________________________")
                        }
                    }

                }else{
                    self.showNoti("try")
                }
            }

        }


    }else{
        self.showAlertLogin()
    }

}
}
