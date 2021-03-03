
import UIKit

class ChatLeft: UITableViewCell {
    @IBOutlet weak var date_lb: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var msg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
