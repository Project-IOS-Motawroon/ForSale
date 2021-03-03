

import Foundation
import UIKit
extension UIView{

    func RoundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }

    func dropShadow(scale: Bool = true) {
         layer.masksToBounds = false
             layer.shadowColor = UIColor.black.cgColor
             layer.shadowOpacity = 0.2
             layer.shadowOffset = .zero
             layer.shadowRadius = 3
             layer.shouldRasterize = true
             layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func circleView(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        
    }
   
//    func whiteBorder(){
//        self.layer.borderWidth = 3.0
//        self.layer.borderColor = UIColor(hexString: "#ffffff").cgColor
//    }
//    func blackBorder(){
//           self.layer.borderWidth = 3.0
//           self.layer.borderColor = UIColor(hexString: "#EEEEEE").cgColor
//       }
    
    
}
extension UICollectionView{
    func setCollectionLayOut(_ height:Int,_ count:Int){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 20)/CGFloat(count), height: CGFloat(height))
        layout.scrollDirection = .horizontal
        self.collectionViewLayout  = layout
    }

    func setCollectiontest(_ height:Int,_ count:Int){
           let layout = UICollectionViewFlowLayout()
           layout.sectionInset = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
           layout.minimumInteritemSpacing = 5
           layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 60)/CGFloat(count), height: CGFloat(height))
           layout.scrollDirection = .horizontal
           self.collectionViewLayout  = layout
       }
    func setCollectionWithOutHorizontalLayOut(_ height:Int,_ count:Int){
          let layout = UICollectionViewFlowLayout()
          layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
          layout.minimumInteritemSpacing = 5
          layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 20)/CGFloat(count), height: CGFloat(height))
         // layout.scrollDirection = .horizontal
          self.collectionViewLayout  = layout
      }
    
}
