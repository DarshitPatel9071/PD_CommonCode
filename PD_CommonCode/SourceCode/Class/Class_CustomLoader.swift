//
//  Class_CustomLoader.swift
//  Govt Exam se Sarkari Naukri
//
//  Created by iMac on 30/09/22.
//

import AVKit
import Foundation
import Toast_Swift
import Lottie

public class CustomLoader{
    
    private static var bgview = UIView()

    static private var animationView:LottieAnimationView = LottieAnimationView()
    
    private static func addCustomLoader(){
        let tmpWidth:CGFloat = 80
        let tmpHalfWidth = tmpWidth / 2
        
        let tmpVW = UIApplication.shared.windows[0]
        
        self.bgview.frame = CGRect.init(x: 0, y: 0, width: tmpVW.frame.size.width, height: tmpVW.frame.size.height)
        self.bgview.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        
        animationView = LottieAnimationView(name: .customLoader)
        animationView.frame = CGRect(x: bgview.frame.width/2-tmpHalfWidth, y: bgview.frame.width/2-tmpHalfWidth, width:tmpWidth, height: tmpWidth)
        animationView.center = self.bgview.center
        animationView.backgroundColor = .white
        animationView.layer.cornerRadius = tmpHalfWidth
        animationView.setupShadow()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.stop()
        
        
        self.bgview.addSubview(animationView)
        animationView.play()
        tmpVW.addSubview(bgview)
    }
    
    class func show(){
        self.hide()
        addCustomLoader()
    }
    
    class func hide(){
        animationView.stop()
        self.bgview.subviews.forEach({ $0.removeFromSuperview() })
        self.bgview.removeFromSuperview()
    }
}

class CustomToast{
    
    enum TOAST_TYPE{
        case ERROR
        case SUCCESS
        case NONE
    }
    
    // show toast message
    class func toastMessage(message:String,
                            duration:Double = 3.0,
                            type:TOAST_TYPE = .SUCCESS){
        
        if message.isEmpty{return}
        
        DispatchQueue.main.async{
            let baseView = UIApplication.shared.keyWindow ?? UIView()
            
            baseView.hideToast()
            
            var toastStyle = ToastStyle()
            
            toastStyle.backgroundColor = type == .ERROR ? .red : .black
            toastStyle.titleAlignment = .center
            toastStyle.messageAlignment = .center
            toastStyle.titleColor = .white
            toastStyle.messageColor = .white
            
            baseView.makeToast(message, duration: duration, position: .top,style:toastStyle)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    // hide toast message
    class func hideToast(){
        let baseView = UIApplication.shared.keyWindow ?? UIView()
        baseView.hideToast()
    }
}
