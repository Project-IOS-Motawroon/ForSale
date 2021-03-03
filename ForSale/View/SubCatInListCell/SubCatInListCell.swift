//
//  SubCatInListCell.swift
//  ForSale
//
//  Created by Mohamed on 12/10/20.
//

import UIKit

class SubCatInListCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
