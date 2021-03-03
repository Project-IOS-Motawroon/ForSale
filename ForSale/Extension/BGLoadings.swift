//
//  BGLoadings.swift
//  Jayik
//
//  Created by endpoint on 6/13/20.
//  Copyright © 2020 endpoint. All rights reserved.
//

import UIKit
import JHSpinner

class BGLoading: NSObject {
    static let instance = BGLoading()
    static var spinner:JHSpinnerView?
    func dismissLoading(){
        if BGLoading.spinner != nil{
            BGLoading.spinner?.dismiss()
        }
    }
    func showLoading(_ view:UIView){
        if BGLoading.spinner != nil{
            BGLoading.spinner?.dismiss()
        }
        BGLoading.spinner = JHSpinnerView.showOnView(view, spinnerColor: UIColor.init(hexString: "ECAD3C"), overlay: .fullScreen, overlayColor: UIColor.black.withAlphaComponent(0.2), fullCycleTime: 4.0, text: "loading".localized(), textColor: UIColor.white)
        
        view.addSubview(BGLoading.spinner!)
    }
    func updateProgressLoadingView(progress:Double){
        BGLoading.spinner?.addCircleBorder(UIColor.init(hexString: "ECAD3C"), progress: CGFloat(progress / 100))
    }
    func showLoadingWithProgress(_ view:UIView){
        if BGLoading.spinner != nil{
            BGLoading.spinner?.dismiss()
        }
        BGLoading.spinner = JHSpinnerView.showOnView(view, spinnerColor: UIColor.init(hexString: "ECAD3C"), overlay: .fullScreen, overlayColor: UIColor.black.withAlphaComponent(0.2), fullCycleTime: 4.0, text: "loading".localized(), textColor: UIColor.white)
        
        view.addSubview(BGLoading.spinner!)
    }
  func showOnlyLoading(_ view:UIView){
       if BGLoading.spinner != nil{
           BGLoading.spinner?.dismiss()
       }
    BGLoading.spinner = JHSpinnerView.showOnView(view, spinnerColor: UIColor.init(hexString: "ECAD3C"), overlay: .fullScreen, overlayColor: UIColor.black.withAlphaComponent(0.2), fullCycleTime: 4.0, text: "YourRequestisbeingProcessed".localized(), textColor: UIColor.white)
       
       view.addSubview(BGLoading.spinner!)
   }
    
    func show(_ view:UIView){
          if BGLoading.spinner != nil{
              BGLoading.spinner?.dismiss()
          }
       BGLoading.spinner = JHSpinnerView.showOnView(view, spinnerColor: UIColor.init(hexString: "ECAD3C"), overlay: .fullScreen, overlayColor: UIColor.black.withAlphaComponent(0.2), fullCycleTime: 4.0)
          
          view.addSubview(BGLoading.spinner!)
      }
    //showOnlyLoading
    
}


