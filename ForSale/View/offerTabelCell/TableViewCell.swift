//
//  TableViewCell.swift
//  ForSale
//
//  Created by Mohamed on 12/7/20.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var SAR1: UILabel!
    @IBOutlet weak var oldPrice2: UILabel!
    @IBOutlet weak var SAR2: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var discountValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
