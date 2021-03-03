//
//  CommissionVC.swift
//  ForSale
//
//  Created by Mohamed on 12/10/20.
//

import UIKit

class CommissionVC: UIViewController {

    @IBOutlet weak var CommissionValueTF: UITextField!
    @IBOutlet weak var CommissionValueLabel: UILabel!
    @IBOutlet weak var PayValueTF: UITextField!
    
    var total:String = "0"
    var value = 0.0

    override func viewWillAppear(_ animated: Bool) {
        total = CommissionValueTF.text!
        CommissionValueTF.addTarget(self, action: #selector(tapped), for: .editingChanged)
    }

    
    @objc func tapped(_ sender:UITextField){
        value = (1.0/100.0) * (sender.text! as NSString).doubleValue
        print("mmmmmmmmmm\(value)")
        CommissionValueLabel.text = String(Double(round(100 * value) / 100))
    }

    
    @IBAction func ContinuePress(_ sender: Any) {
    }
    
}
