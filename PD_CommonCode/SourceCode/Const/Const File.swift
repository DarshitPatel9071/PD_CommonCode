//
//  Const File.swift
//  Common Code
//
//  Created by iMac on 17/06/24.
//

import Foundation
import UIKit

struct AppInformation{
    static let AppName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "TEST"
}

enum StoryBoradType:String{
    case Main = "Main"
}

enum ViewControllerID:String{
    case ViewController = "ViewController"
}

struct Common_Color{
    
    static let popupBG = "#ED8A80".toUIColor()
    
    static let popupHeaderBG = "#27464F".toUIColor()
    static let popupHeaderTxt = "#ED8A80".toUIColor()
    static let popupMsgTxt = "#27464F".toUIColor()
    
    static let popupAllBtnBG = "#27464F".toUIColor()
    static let popupAllBtnTxt = "#ED8A80".toUIColor()
    static let popupAllBtnBrd = "#27464F".toUIColor()
    
    static let popupCancelBtnBG = "#ED8A80".toUIColor()
    static let popupCancelBtnTxt = "#27464F".toUIColor()
    static let popupCancelBtnBrd = "#27464F".toUIColor()
}

struct Common_Font{
    
    
}






//MARK: - ALL Functions

public func commonErrorAlert(arrBtn:[Alert_Button_Info]){
    if let topVC = UIApplication().getTopViewController(){
        
        let alertVC = CommonErrorAlert()
        alertVC.arrAllBtn = arrBtn
        
        
        
        
        alertVC.modalPresentationStyle = .overFullScreen
        topVC.navigationController?.present(alertVC, animated: false)
    }
}
