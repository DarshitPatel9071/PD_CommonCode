//
//  CommonErrorAlert.swift
//  Alamofire
//
//  Created by iMac on 20/06/24.
//

import UIKit

enum Alert_Button_Type:Int{
    case DEF
    case CANCEL
}

struct Alert_Button_Info{
    var title:String
    var type:Alert_Button_Type = .DEF
    var tag:Int = 0
}

class CommonErrorAlert: UIViewController {
    
    @IBOutlet weak var vwMain:UIView!
    @IBOutlet weak var vwHeader:UIView!

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblMsg:UILabel!
    
    @IBOutlet weak var btnFirst:UIButton!
    @IBOutlet weak var btnSecond:UIButton!
    @IBOutlet weak var btnThird:UIButton!
    

    var arrAllBtn:[Alert_Button_Info] = []
}

extension CommonErrorAlert{
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showHideAnimation(isShow: true)
    }
}

extension CommonErrorAlert{
 
    private func initViewDidLoad(){
        setupUI()
    }
    
    private func setupUI(){
        vwMain.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.alpha = 0
        
        
        vwMain.backgroundColor = Common_Color.popupBG
        vwHeader.backgroundColor = Common_Color.popupHeaderBG
        
        lblTitle.textColor = Common_Color.popupHeaderTxt
        lblMsg.textColor = Common_Color.popupMsgTxt
        
        var arrBtn = [btnFirst!,btnSecond!,btnThird!]
        
        if let fIndex = arrAllBtn.firstIndex(where: {$0.type == .CANCEL}){
            setupBtnAsPerType(btn: btnThird, info: arrAllBtn[fIndex])
            arrAllBtn.remove(at: fIndex)
            arrBtn = arrBtn.dropLast()
        }
        
        for tmpIndex in 0..<arrBtn.count{
            
            let isHideBtn = tmpIndex >= arrAllBtn.count
            arrBtn[tmpIndex].isHidden = isHideBtn
            
            if !isHideBtn{
                setupBtnAsPerType(btn: arrBtn[tmpIndex], info: arrAllBtn[tmpIndex])
            }
            
        }
    }
    
    private func setupBtnAsPerType(btn:UIButton,info:Alert_Button_Info){
        
        let bgClr = info.type == .CANCEL ? Common_Color.popupCancelBtnBG : Common_Color.popupAllBtnBG
        let txtClr = info.type == .CANCEL ? Common_Color.popupCancelBtnTxt : Common_Color.popupAllBtnTxt
        let brdClr = info.type == .CANCEL ? Common_Color.popupCancelBtnBrd : Common_Color.popupAllBtnBrd
        
        btn.setTitle(info.title, for: .normal)
        btn.setTitleColor(txtClr, for: .normal)
        btn.backgroundColor = bgClr
        
        btn.layer.borderWidth = 1
        btn.layer.borderColor = brdClr.cgColor
    }
    
    private func showHideAnimation(isShow:Bool,completion:(() -> Void)? = nil){
        
        UIView.animate(withDuration: 0.3) {
            
            self.vwMain.transform = isShow ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = isShow ? 1 : 0
            
        } completion: { isComplete in
            if !isShow{
                self.dismiss(animated: false){
                    completion?()
                }
            }
        }
    }
    
}
