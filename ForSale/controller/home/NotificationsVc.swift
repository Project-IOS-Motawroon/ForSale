

import UIKit
import SwiftyJSON

class NotificationsVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var notificationsJson = [JSON]()
    var notificationJson:JSON!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.title = "Notification".localized()
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
          tableView.delegate = self
          tableView.dataSource = self
          getNotifactions()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    
       }
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return notificationsJson.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCelll ,notificationsJson.count > 0 {
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    let pos = indexPath.row
                    let item = notificationsJson[pos]
                    
            cell.title.text = item["title"].stringValue
            cell.message.text = item["message"].stringValue
            cell.deletePress.tag = pos
            cell.deletePress.addTarget(self, action: #selector(deleteNOTPress), for: .touchUpInside)
                    return cell
                }else{
                    return UITableViewCell()
                }
    }
    
    @objc func deleteNOTPress(_ sender: UIButton) {
        ActionPress(sender.tag)
       }
    
    func ActionPress(_ index:Int){
        let item = notificationsJson[index]
        BGLoading.instance.show(view)
        Notification_API().deleteNotifaction(notification_id: item["id"].intValue) { (code) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                self.getNotifactions()
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "homeID")
//                self.present(vc, animated: true, completion: nil)
            }else{
                print("code \(code)")
                self.ftt("tryAgainLater")
            }
        }
    }
    
    
    func getNotifactions(){
        BGLoading.instance.show(view)
        Notification_API.instance.NOT { (code, result) in
            BGLoading.instance.dismissLoading()
                        if code == 200 {
                            if let data = result {
                                if data.count > 0 {
                                    self.tableView.isHidden = false
                                    self.notificationsJson = data
                                    self.tableView.reloadData()
                                    
                                }else{
                                    self.tableView.isHidden = true
                                }
                            }
                        }else{
                            self.tableView.isHidden = true
                            self.showNoti("try")
                        }
        }
    }

}
