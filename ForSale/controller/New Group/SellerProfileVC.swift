//
//  SellerProfileVC.swift
//  ForSale
//
//  Created by Moustafa on 10/21/20.
//

import UIKit

class SellerProfileVC: UIViewController {

    @IBOutlet weak var LogoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        LogoImg.circleImage()
        LogoImg.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
//        EditBtn.circleView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
