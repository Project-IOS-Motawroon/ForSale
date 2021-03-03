

import UIKit

class RoomCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var logo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        status.circleView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
