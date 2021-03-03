

import MOLH
import SwiftyJSON
class SideMenuVC: UIViewController ,UITableViewDelegate,UITableViewDataSource, TableViewCellDelegate{
    
    

    
    @IBOutlet weak var tableConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var cats = [JSON]()
    var isShow = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableConst.constant = 0.0
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        tableView.delegate = self
        tableView.dataSource = self
        getCats()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell,cats.count > 0 {
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let pos = indexPath.row
            let item = cats[pos]
            let show = isShow[pos]
            cell.catnameLB.text = item["title"].stringValue
            cell.catImage.setImage(from: ImageURL + item["image"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            cell.subCategoriesTabel.index = item["id"].intValue
            cell.DirectBTN.tag = pos
            cell.DirectBTN.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
            cell.updateCellWith(row: item["sub_categories"].arrayValue)
            cell.cellDelegate = self
            print("nbnb")
            if show{
                cell.ListConst.constant = CGFloat(item["sub_categories"].arrayValue.count * 50)
                cell.subCategoriesTabel.isHidden = false
            }else{
                //cell.ListConst.constant = 0.0
                cell.subCategoriesTabel.isHidden = true
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    @objc func btnTapped(_ sender:UIButton){
        let pos = sender.tag
        let item = cats[pos]
        let cell = tableView.cellForRow(at: IndexPath(row: pos, section: 0)) as! ListCell
        if cell.subCategoriesTabel.isHidden {
            isShow[pos] = true
            tableConst.constant += CGFloat(item["sub_categories"].arrayValue.count * 50)
        }else{
            isShow[pos] = false
            tableConst.constant -= CGFloat(item["sub_categories"].arrayValue.count * 50)
        }
        tableView.reloadData()
        
    }
    func getCats(){
        AllCategoriesForSlid_API().getAllCategories { (code, result) in
            if code == 200 {
                
                if let data = result,data.count > 0 {
                    self.cats = data
                    self.tableView.reloadData()
                    self.tableConst.constant = CGFloat(data.count * 42)
                    for _ in data{
                        self.isShow.append(false)
                    }
                }
            }else{
                print("error with code \(code)")
            }
        }
        
    }
    
    
    
    @IBAction func couponsPress(_ sender: Any) {
        
        performSegue(withIdentifier: "couponsSegue", sender: self)
    
    }
    
    

}
extension SideMenuVC{
    func tableView(tableViewCell: SubCatInListCell?, index: Int, item: JSON, didTappedInTableViewCell: ListCell,withParentID:Int) {
        print("tapped with data \(item)")
        print("catid \(withParentID)")
        print("subCatid \(item["id"].intValue)")
        
        ///// To Navegat to other screen and send data
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsFromSideMenue") as! AdsFromSideMenue
        //////send data

        vc.catid = withParentID
        vc.subCatid = item["id"].intValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


