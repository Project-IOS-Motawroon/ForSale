

import UIKit
import SwiftyJSON
import MOLH
class ChatVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,ImagePickerDelegate{
    
    let is_ar = MOLHLanguage.currentAppleLanguage()
    let dev = UserDefaults.standard
    
    @IBOutlet weak var msgTF: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    var room_id = -1
    var to_user_id = -1
    var messages = [JSON]()
    var userType = -1
    var dateFormatter = DateFormatter()
    
    var imagePicker: ImagePicker!
    var selectedData:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
       print("fjgjhfhjghgfh\(UserDefaults.standard.integer(forKey: "id"))")
        getChat()
        NotificationCenter.default.addObserver(self, selector: #selector(self.chating(_:)), name: NSNotification.Name(rawValue: "message_send"), object: nil)
    }
    

    @objc func chating(_ notification: Notification) {
        guard let message_send = notification.userInfo?["message_send"] as? JSON else { return }
        print("vvvcvv \(message_send)")
        if message_send["chat_room_id"].stringValue == "\(room_id)"{
            messages.append(message_send)
            tableview.reloadData()
            tableview.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        cell.
            let pos = indexPath.row
            let item = messages[pos]
            
            switch item["message_kind"].stringValue {
            case "text":
                if item["from_user_id"].intValue == UserDefaults.standard.integer(forKey: "id"){
                    registerNib("ChatLeft")
                    let cell = tableview.dequeueReusableCell(withIdentifier: "ChatLeft", for: indexPath) as! ChatLeft
                    // remove select row in chat vc
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.msg.text = item["message"].stringValue
                    cell.logo.setImage(from: ImageURL + item["from_user"]["logo"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    dateFormatter.dateFormat = "hh:mm a"
                    cell.date_lb.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(item["date"].intValue)))
                    return cell
                }else{
                    registerNib("ChatRightCell")
                    let cell = tableview.dequeueReusableCell(withIdentifier: "ChatRightCell", for: indexPath) as! ChatRightCell
                    // remove select row in chat vc
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.msg.text = item["message"].stringValue
                    cell.logo.setImage(from: ImageURL + item["sender_logo"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    dateFormatter.dateFormat = "hh:mm a"
                    cell.date_lb.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(item["date"].intValue)))
                    return cell
                }
            case "file":
                
                if item["from_user_id"].intValue == UserDefaults.standard.integer(forKey: "id"){
                    registerNib("ChatImageLeftCell")
                    let cell = tableview.dequeueReusableCell(withIdentifier: "ChatImageLeftCell", for: indexPath) as! ChatImageLeftCell
                    // remove select row in chat vc
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.imageUpload.setImage(from: ImageURL + item["file_link"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    cell.logoUser.setImage(from: ImageURL + item["from_user"]["logo"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    return cell
                }else{
                    
                    registerNib("ChatImageRightCell")
                    let cell = tableview.dequeueReusableCell(withIdentifier: "ChatImageRightCell", for: indexPath) as! ChatImageRightCell
                    // remove select row in chat vc
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.imageUpload.setImage(from: ImageURL + item["file_link"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    cell.logoAdmin.setImage(from: ImageURL + item["from_user"]["logo"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    
                    return cell
                }
            default:
                return UITableViewCell()
            }
           
    }
    
        func registerNib(_ identifier:String){
            tableview.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    func getChat(){
        BGLoading.instance.show(view)
        ChatApi.instance.oneChatRoom(room_id: room_id) { (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result,data.count > 0 {
                    print("hghhhhhhhhhh\(data)")
                    self.messages = data
                    self.tableview.reloadData()
                    self.tableview.scrollToRow(at: IndexPath(row: data.count - 1, section: 0), at: .bottom, animated: false)
                }
            }else{
                self.showNoti("try")
            }
        }
    }
    
    
    
    
    @IBAction func send_msg(_ sender: Any) {
        if let message = msgTF.text{
            let timestamp = NSDate().timeIntervalSince1970
            let myTimeInterval = TimeInterval(timestamp)
            let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))

            let params:[String:Any] = ["from_user_id":UserDefaults.standard.integer(forKey: "id"),
                                       "to_user_id":to_user_id,
                                       "message_kind":"text",
                                       "message":message,
                                       "room_id":room_id,
                                       "date":Int(Date().timeIntervalSince1970)
            ]
            ChatApi.instance.sendMsg(params: params) { (code, result) in
                if code == 200 {
                    if let data = result{
                        print(".....\(data)")
                        self.msgTF.text = nil
                        self.messages.append(data["data"])
                        self.tableview.reloadData()
                        self.tableview.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
                    }
                }
            }
        }
        
    }
    

    @IBAction func send_image_press(_ sender: UIButton) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        selectedData = image.jpegData(compressionQuality: 0.7)!

        let sendedDate = Int(Date().timeIntervalSince1970)
        let from_user_id =  UserDefaults.standard.integer(forKey: "id")
        
           
        ChatApi.instance.sendImagemessage(room_id: room_id, message_kind: "file", date: sendedDate, file_link: selectedData!, from_user_id: from_user_id, to_user_id: to_user_id) { (success:Bool, code:Int) in
            if code == 200 {
                if success{
                    print("success")
                    self.msgTF.text = nil
                    self.messages.removeAll()
                    self.getChat()
                    
                    
                }
            }else{
                self.showAlert(message: "server error with code \(code)")
            }
        }
        /// api code to send image
    }
    
}
    
   
