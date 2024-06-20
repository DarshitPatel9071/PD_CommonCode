//
//  UIView's Extemnsion.swift
//  Whatsoo
//
//  Created by Darshit patel on 20/09/22.
//

import UIKit
import Foundation

let isIPhoneDevice = UIDevice.current.userInterfaceIdiom == .phone

extension UIView{
    // For Set borderColor
    @IBInspectable var borderColor : UIColor{
        get{
            return self.borderColor
        }set{
            layer.borderColor = newValue.cgColor
        }
    }
    
    // For Set borderWidth
    @IBInspectable var borderWidth : CGFloat{
        get{
            return self.borderWidth
        }set{
            layer.borderWidth = isIPhoneDevice ?  newValue : newValue*1.5
        }
    }
    
    // For Set CornerRadius
    @IBInspectable var cr_Phone : CGFloat{
        get{
            return self.cr_Phone
        }set{
            layer.cornerRadius = isIPhoneDevice ?  newValue : 0
        }
    }
    
    @IBInspectable var cr_Pad : CGFloat{
        get{
            return self.cr_Pad
        }set{
            layer.cornerRadius = isIPhoneDevice ?  0 : newValue
        }
    }
    
    // top left radius
    @IBInspectable var topLeftCR : CGFloat{
        get{
            return self.topLeftCR
        }set{
            layer.cornerRadius = isIPhoneDevice ?  newValue : newValue*1.5
            layer.maskedCorners = [.layerMinXMinYCorner]
        }
    }
    
    // set Defu Shadow
    @IBInspectable var defShadow : Bool{
        get{
            return self.defShadow
        }set{
            if newValue{
                setupShadow()
            }
        }
    }
    
    func asImage() -> UIImage
    {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    func getWidth() -> CGFloat{
        return frame.size.width
    }
    
    func getHeight() -> CGFloat{
        return frame.size.height
    }
}

//MARK: - ************* Shadow *****************
extension UIView{
    // For Set shadow
    func setupShadow(shadowOffset:CGSize = CGSize(width: 0, height: 0),
                     shadowRadius:CGFloat = 5,
                     shadowColor:UIColor = .black,
                     shadowOpacity:Float = 0.5){
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
    }
}

//MARK: - ************* Masked Corner *****************
extension UIView{

    enum MaskedCorner{
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    func maskedCorner(cr:CGFloat,arr:[MaskedCorner]){
        layer.cornerRadius = cr
        layer.maskedCorners = [
            arr.contains(.topLeft) ? .layerMinXMinYCorner : .init(),
            arr.contains(.topRight)  ? .layerMaxXMinYCorner : .init(),
            arr.contains(.bottomLeft)  ? .layerMinXMaxYCorner : .init(),
            arr.contains(.bottomRight)  ? .layerMaxXMaxYCorner : .init()
        ]
    }
}

//MARK: - ************* GrediantBorder && Shake view *****************
extension UIView{
 
    func grediantBorder(colors:[UIColor],radius:CGFloat){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = colors.map{$0.cgColor}
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
        let movedPath = CGRect(x: shapeLayer.lineWidth / 2 , y: shapeLayer.lineWidth / 2, width: bounds.size.width - shapeLayer.lineWidth, height: bounds.size.height - shapeLayer.lineWidth)
        shapeLayer.path = UIBezierPath(roundedRect: movedPath, cornerRadius: radius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        gradientLayer.mask = shapeLayer
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func shakeView() {
        
        let tmpRepeatCount:Float = 4
        let tmpAnimationDuration:Float = 0.3
        let tmpTranslation:Float = -5
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = tmpRepeatCount
        animation.duration = TimeInterval(tmpAnimationDuration/tmpRepeatCount)
        animation.autoreverses = true
        animation.byValue = tmpTranslation
        layer.add(animation, forKey: "shake")
    }
    
    func rotateView(rotation:CGFloat) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat]) {
            self.transform = CGAffineTransform(rotationAngle: 0.45)
        } completion: { isCom in
            self.transform = .identity
        }
    }
}

