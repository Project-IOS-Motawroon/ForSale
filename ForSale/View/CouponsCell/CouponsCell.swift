//
//  CouponsCell.swift
//  ForSale
//
//  Created by Mohamed on 12/19/20.
//

import UIKit

class CouponsCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var nameUserLabel: UILabel!
 
    @IBOutlet weak var coponeLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logo.circleImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
