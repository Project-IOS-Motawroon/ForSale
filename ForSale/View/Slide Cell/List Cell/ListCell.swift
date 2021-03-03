//
//  ListCell.swift
//  HeragElawal
//
//  Created by endpoint on 1/23/20.
//  Copyright © 2020 endpoint. All rights reserved.
//

import UIKit
import SwiftyJSON
class ListCell: UITableViewCell {

    @IBOutlet weak var subCategoriesTabel: mytable!
    @IBOutlet weak var ListConst: NSLayoutConstraint!
    @IBOutlet weak var DirectBTN: UIButton!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catnameLB: UILabel!
   var subCats = [JSON]()
    weak var cellDelegate: TableViewCellDelegate?
        override func awakeFromNib() {
            super.awakeFromNib()
            subCategoriesTabel.register(UINib(nibName: "SubCatInListCell", bundle: nil), forCellReuseIdentifier: "SubCatInListCell")
            subCategoriesTabel.delegate = self
            subCategoriesTabel.dataSource = self
        }
    }
    extension ListCell:UITableViewDelegate,UITableViewDataSource{
        func updateCellWith(row: [JSON]) {
             self.subCats = row
             if row.count > 0 {
                 self.subCategoriesTabel.isHidden = false
                 self.subCategoriesTabel.reloadData()
             }else{
                 self.subCategoriesTabel.isHidden = true
             }
         }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return  50.0
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.subCats.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubCatInListCell", for: indexPath) as? SubCatInListCell,subCats.count > 0 {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                let pos = indexPath.row
                let item = subCats[pos]
                cell.label.text = item["title"].stringValue
                cell.logo.setImage(from: ImageURL + item["image"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                cell.btn.tag = pos
                cell.btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
                return cell
            }else{
                return UITableViewCell()
            }
        }
        
        @objc func btnTapped(_ sender:UIButton){
            let pos = sender.tag
            let item = subCats[pos]
            let indexPath = IndexPath(row: pos, section: 0)
            let cell = subCategoriesTabel.cellForRow(at: indexPath) as? SubCatInListCell
            print("I'm tapping the \(indexPath.item)")
            self.cellDelegate?.tableView(tableViewCell: cell, index: indexPath.item,item: item, didTappedInTableViewCell: self,withParentID:self.subCategoriesTabel.index)
        }
        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let pos = indexPath.row
//            let item = subCats[pos]
//            let cell = tableView.cellForRow(at: indexPath) as? SubCatInListCell
//            print("I'm tapping the \(indexPath.item)")
//            self.cellDelegate?.tableView(tableViewCell: cell, index: indexPath.item,item: item, didTappedInTableViewCell: self)
//        }
    }

protocol TableViewCellDelegate: class {
    func tableView(tableViewCell: SubCatInListCell?, index: Int,item: JSON, didTappedInTableViewCell: ListCell,withParentID:Int)

    }
class mytable: UITableView {
    var index = 0
}
