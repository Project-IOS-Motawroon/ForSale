

import UIKit

class ChatRightCell: UITableViewCell {
    @IBOutlet weak var date_lb: UILabel!
    
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var logo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
