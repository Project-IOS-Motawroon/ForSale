
import UIKit

class NotificationCelll: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var deletePress: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
