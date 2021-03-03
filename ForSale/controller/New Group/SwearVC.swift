
import UIKit

class SwearVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    @IBAction func publish_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
