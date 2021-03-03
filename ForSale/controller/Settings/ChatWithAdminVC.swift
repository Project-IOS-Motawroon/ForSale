

import UIKit
import SwiftyJSON

class ChatWithAdminVC: UIViewController,UITableViewDataSource,UITableViewDelegate,ImagePickerDelegate {

    
    
    let dev = UserDefaults.standard
    
    var imagePicker: ImagePicker!
    var selectedData:Data?
    var messages = [JSON]()
    var room_id = -1
    var dateFormatter = DateFormatter()

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var msgTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self

        creatChatRoom()
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

    
    
    func creatChatRoom(){
        BGLoading.instance.show(view)
        Chat_With_Admin_API.instance.adminChatRoomGet { (code, result) in
           BGLoading.instance.dismissLoading()
            if let data = result{
                self.room_id = data["id"].intValue
                self.getChat()
            }
        }
    }
    func getChat(){
        BGLoading.instance.show(view)
        Chat_With_Admin_API.instance.oneChatRoom(room_id: room_id) { (code, result) in
            print(",.,.,.,.,.,.,.\(self.room_id)")
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result,data.count > 0 {
                    self.messages = data
                    self.tableview.reloadData()
                    self.tableview.scrollToRow(at: IndexPath(row: data.count - 1, section: 0), at: .bottom, animated: false)
                }
            }else{
                self.showNoti("try")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages.count > 0 {
            let pos = indexPath.row
            let item = messages[pos]
            
            
            if item["from_user_id"].intValue == UserDefaults.standard.integer(forKey: "id")&&item["message_kind"].stringValue == "text"{
                
                tableView.register(UINib(nibName: "ChatLeft", bundle: nil), forCellReuseIdentifier: "ChatLeft")
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeft", for: indexPath) as! ChatLeft
//                dateFormatter.dateFormat = "dd-MM-yyyy, hh:mm a"
                dateFormatter.dateFormat = "hh:mm a"
                // remove select row in chat vc
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                cell.date_lb.text = self.fromStampToString(time: TimeInterval((item["date"].stringValue as NSString).integerValue), format: dateFormatter.dateFormat)
                cell.logo.setImage(from: ImageURL + dev.string(forKey: "logo")!)
                cell.msg.text = item["message"].stringValue
                return cell
            }
            else if item["from_user_id"].intValue != UserDefaults.standard.integer(forKey: "id")&&item["message_kind"].stringValue == "text"{
                
                tableView.register(UINib(nibName: "ChatRightCell", bundle: nil), forCellReuseIdentifier: "ChatRightCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightCell", for: indexPath) as! ChatRightCell
//                dateFormatter.dateFormat = "dd-MM-yyyy, hh:mm a"
                dateFormatter.dateFormat = "hh:mm a"

                cell.date_lb.text = self.fromStampToString(time: TimeInterval((item["date"].stringValue as NSString).integerValue), format: dateFormatter.dateFormat)
                cell.logo.image = UIImage(named: "smallLogo")
                cell.msg.text = item["message"].stringValue
                return cell
            }else if item["from_user_id"].intValue == UserDefaults.standard.integer(forKey: "id")&&item["message_kind"].stringValue == "file"{
                
                tableView.register(UINib(nibName: "ChatImageLeftCell", bundle: nil), forCellReuseIdentifier: "ChatImageLeftCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageLeftCell", for: indexPath) as! ChatImageLeftCell
                
                cell.logoUser.setImage(from: ImageURL + dev.string(forKey: "logo")!)
                cell.imageUpload.setImage(from: ImageURL + item["file_link"].stringValue)
                return cell
            }else{
                tableView.register(UINib(nibName: "ChatImageRightCell", bundle: nil), forCellReuseIdentifier: "ChatImageRightCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageRightCell", for: indexPath) as! ChatImageRightCell
                ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                cell.logoAdmin.image = UIImage(named: "smallLogo")
                cell.imageUpload.setImage(from: ImageURL + item["file_link"].stringValue)
                return cell
            }

        }else{
            return UITableViewCell()
        }
    }
 

    @IBAction func send_msg(_ sender: Any) {
        if let message = msgTF.text{
            let timestamp = NSDate().timeIntervalSince1970
            let myTimeInterval = TimeInterval(timestamp)
            let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))

            let params:[String:Any] = [
                                       "message_kind":"text",
                                       "message":message,
                                       "room_id":room_id,
                                       "date":Int(Date().timeIntervalSince1970)
            ]
            Chat_With_Admin_API.instance.sendMsg(params: params) { (code, result) in
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
    


    @IBAction func sendImagePress(_ sender: UIButton) {
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    
    
}

    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        selectedData = image.jpegData(compressionQuality: 0.7)!

        let sendedDate = Int(Date().timeIntervalSince1970)
        
        
        
        Chat_With_Admin_API.instance.sendImagemessage(room_id:room_id,message_kind:"file", date: sendedDate, file_link: selectedData!) { (success:Bool, code:Int) in
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
