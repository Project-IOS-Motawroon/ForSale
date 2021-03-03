//
//  AdsCell.swift
//  Camel market
//
//  Created by Mohamed on 11/16/20.
//  Copyright © 2020 endpont. All rights reserved.
//

import UIKit


class AdsCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imagee: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
