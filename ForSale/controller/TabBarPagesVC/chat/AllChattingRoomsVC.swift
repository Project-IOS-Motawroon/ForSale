
import UIKit
import SwiftyJSON
class AllChattingRoomsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    


    @IBOutlet weak var noData: UILabel!
    @IBOutlet weak var tableview: UITableView!

    let dev = UserDefaults.standard
    var room_id = -1
    var to_user_id = -1
    var dateFormatter = DateFormatter()

    var rooms = [JSON]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        tableview.delegate = self
        tableview.dataSource = self

        getRooms()

    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func getRooms(){
        BGLoading.instance.show(view)
        ChatApi.instance.AllMyChattingRooms { (code, result) in
            BGLoading.instance.dismissLoading()
            if code == 200 {
                if let data = result,data.count > 0 {
                    self.tableview.isHidden = false
                    self.rooms = data
                    self.tableview.reloadData()
                }else{
                self.tableview.isHidden = true
                self.noData.text = "no data Found".localized()
                }
            }else{
                self.tableview.isHidden = true
                self.noData.text = "no data Found".localized()
                self.showNoti("try")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 68.0
      }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rooms.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            tableView.register(UINib(nibName: "RoomCell", bundle: nil), forCellReuseIdentifier: "RoomCell")
            if let cell = tableview.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as? RoomCell,rooms.count > 0 {
                     cell.selectionStyle = UITableViewCell.SelectionStyle.none
                     let pos = indexPath.row
                     let item = rooms[pos]
                cell.logo.setImage(from: ImageURL + item["other_user_logo"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                
                     cell.name.text = item["other_user_name"].stringValue
               
                     cell.msg.text = item["last_message"].stringValue
                
                dateFormatter.dateFormat = "dd-MM-yyyy"
                     cell.status.text = self.fromStampToString(time: TimeInterval((item["last_message_date"].stringValue as NSString).integerValue), format: dateFormatter.dateFormat)
                        
//                        item["last_message_date"].stringValue
              
                     return cell
                 }else{
                     return UITableViewCell()
                 }

        
      }

    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let pos = indexPath.row
    //            <<..
            let item = rooms[pos]
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatSegue") as! ChatVC
            //////send data

        vc.room_id = item["id"].intValue
        vc.to_user_id = item["second_user_id"].intValue != UserDefaults.standard.integer(forKey: "id") ? item["second_user_id"].intValue : item["first_user_id"].intValue
            self.navigationController?.pushViewController(vc, animated: true)
        }




}
