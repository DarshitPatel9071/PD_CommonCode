//
//  UITextField's Extension.swift
//  Whatsoo
//
//  Created by Darshit patel on 20/09/22.
//

import Foundation
import UIKit

extension UITextField{
    // change placeholder color of testfilder
    @IBInspectable var placeHolderColor:UIColor{
        get{
            return self.placeHolderColor
        }set{
            attributedPlaceholder = NSAttributedString(string:placeholder ?? "", attributes:[NSAttributedString.Key.foregroundColor: newValue])
        }
    }
    
    // change color of textfiled clear button
    @IBInspectable var clearButtonColor:UIColor{
        get{
            return self.clearButtonColor
        }set{
            if let clearButton = self.value(forKey: "_clearButton") as? UIButton {
                let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
                clearButton.setImage(templateImage, for: .normal)
                clearButton.tintColor = newValue
            }
        }
    }
    
    // set image as left view
    @IBInspectable var LeftImg:UIImage{
        get{
            return self.LeftImg
        }set{
            leftView = getLeftRightView(img: newValue)
            leftViewMode = .always
        }
    }
    
    // set image as right view
    @IBInspectable var RightImg:UIImage{
        get{
            return self.RightImg
        }set{
            rightView = getLeftRightView(img: newValue)
            rightViewMode = .always
        }
    }
    
    // set left padding
    @IBInspectable var LeftPadding:CGFloat{
        get{
            return self.LeftPadding
        }set{
            leftView = getLeftRightView(padding:newValue)
            leftViewMode = .always
        }
    }
    
    // set right padding
    @IBInspectable var RightPadding:CGFloat{
        get{
            return self.RightPadding
        }set{
            rightView = getLeftRightView(padding:newValue)
            rightViewMode = .always
        }
    }
    
    // shake txt
    func shakeForWrongEntry(){
        let tmpTxtColor = textColor
        textColor = .red
        self.shakeView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75){
            self.textColor = tmpTxtColor
        }
    }
}

extension UITextField{
    
    // get view for left/right
    func getLeftRightView(img:UIImage? = nil,padding:CGFloat? = nil) -> UIView{
        let height = self.frame.size.height
        let width = img == nil ? (padding ?? 15) : height
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        if let img = img{
            let imgVw = UIImageView()
            imgVw.frame.size = CGSize(width: height*0.5, height: height*0.5)
            imgVw.center.x = height / 2
            imgVw.center.y = height / 2
            imgVw.image = img
            imgVw.isUserInteractionEnabled = false
            view.addSubview(imgVw)
        }
        
        view.isUserInteractionEnabled = false
        return view
    }
}
