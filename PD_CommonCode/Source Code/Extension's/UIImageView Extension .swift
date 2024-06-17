//
//  UIImageView Extension .swift
//  Bibal
//
//  Created by Darshit Patel on 30/04/23.
//

import Foundation
//import SD
import UIKit

//MARK: - ************* UIImageVieqw *****************
extension UIImageView{
    func loadFromURL(urlPath:String,placeholderImage:UIImage?=nil){
//        sd_imageIndicator = SDWebImageActivityIndicator.gray
//        sd_imageIndicator!.startAnimatingIndicator()
//        sd_setImage(with: URL(string: urlPath),placeholderImage: placeholderImage)
    }
}

//MARK: - ************* UIImage *****************
/*extension UIImage{
    
    // Common
    static let img_AppLogo = UIImage(named: "ic_Logo")!
    static let img_Wifi = UIImage(named: "ic_Wifi")!
    static let img_MobileData = UIImage(named: "ic_MobileData")!
    
    // App Introduction Screen
    static let img_AppIntro_1 = UIImage(named: "ic_AppIntro_1")!
    static let img_AppIntro_2 = UIImage(named: "ic_AppIntro_2")!
    static let img_AppIntro_3 = UIImage(named: "ic_AppIntro_3")!
    
    // Permission Popup
    static let img_LocationPer = UIImage(named: "ic_LocationPer")!
    static let img_AvDevicePer = UIImage(named: "ic_AvDevicePer")!
    static let img_PHPhotoLibraryPer = UIImage(named: "ic_PHPhotoLibraryPer")!
    
    // Private Browser
    static let img_Google = UIImage(named: "ic_Google")!
    static let img_Yahoo = UIImage(named: "ic_Yahoo")!
    static let img_Gmail = UIImage(named: "ic_Gmail")!
    static let img_Instagram = UIImage(named: "ic_Instagram")!
    static let img_Facebook = UIImage(named: "ic_Facebook")!
    static let img_Youtube = UIImage(named: "ic_Youtube")!
    
    // Apple Map
    static let img_OpenWifi = UIImage(named: "ic_OpenWifi")!
    static let img_LockWifi = UIImage(named: "ic_LockedWifi")!
    static let img_PaidWifi = UIImage(named: "ic_PaidWifi")!
    
    
    // WIFI TOOLS
    static let img_Browser = UIImage(named: "ic_PrivateBrowser")!
    static let img_NetSpeed = UIImage(named: "ic_NetSpeed")!
    static let img_Analyzer = UIImage(named: "ic_Analyzer")!
    static let img_RouterSetting = UIImage(named: "ic_RouterSetting")!
    static let img_RouterPassword = UIImage(named: "ic_RouterPassword")!
    static let img_AppUsadeNet = UIImage(named: "ic_AppUsadeNet")!
    static let img_History = UIImage(named: "ic_History")!
    static let img_WhoUseWifi = UIImage(named: "ic_WhoUseWifi")!
    static let img_WifiScaner = UIImage(named: "ic_WifiScaner")!
    static let img_CreateQR = UIImage(named: "ic_CreateQR")!
    static let img_WifiMap = UIImage(named: "ic_WifiMap")!
    static let img_GeneratePassword = UIImage(named: "ic_GeneratePassword")!
    
}*/

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}

