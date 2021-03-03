

import UIKit

class AddTextCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
