//
//  All Common Extension's.swift
//  Whatsoo
//
//  Created by iMac on 22/09/22.
//

import UIKit
import CoreData
import Foundation

//MARK: - ************* UILabel *****************
extension UILabel{

    enum ATTRIBUTE_TYPE{
        case Border
        case Paragraph
    }
    
    // Attributed Text
    func SetupAttribu(type:[ATTRIBUTE_TYPE],
                      borderColor:UIColor = .clear,borderWidth:CGFloat = -3.0,
                      lineSpacing:CGFloat = 10){
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if type.contains(.Border){
            attributes[.strokeColor] = borderColor
            attributes[.strokeWidth] = borderWidth
            attributes[.foregroundColor] = textColor!
        }
        
        if type.contains(.Paragraph){
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        // Set the attributed str ing to the button
        attributedText = NSAttributedString(string: text!,attributes: attributes)
        textAlignment = textAlignment
    }
    
    
    // HEIGHT and WIDTH of LABEL
    
    //Get Label Height
    func newHeight() -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = self.numberOfLines
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    //Get Label Width
    func newWidth() -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: self.frame.size.height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.width
    }
}

//MARK: - ************* UIColor *****************
extension UIColor {
    // get uicolor from hex string
    static func fromHEX(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    static let clr_TextGray = UIColor(named: "Text_Gray")
    
    
    // All CommonColor
    func getAllUIColor() -> [UIColor]{
        
        var uiColorArray: [UIColor] = []
        autoreleasepool{
            for red in stride(from: 0.0, to: 1.0, by: 0.4) {
                for green in stride(from: 0.0, to: 1.0, by: 0.3) {
                    for blue in stride(from: 0.0, to: 1.0, by: 0.2) {
                        for alpha in stride(from: 0.3, to: 1.0, by: 0.2) {
                            let R = CGFloat(red)
                            let G = CGFloat(green)
                            let B = CGFloat(blue)
                            let A = CGFloat(alpha)
                            
                            let uiColor = UIColor(red: R, green: G, blue: B, alpha: A)
                            uiColorArray.append(uiColor)
                        }
                    }
                }
            }
        }
        
        return uiColorArray.shuffled()
    }
}

//MARK: - ************* CGColor *****************
extension CGColor {
}

//MARK :- ************* UITableView *****************
extension UITableView{
    
    // set table footerview
    func footerView(){
        self.tableFooterView = UIView()
    }
    
    // for register XIB
    func registerNibs(name:[String]){
        footerView()
        
        for i in name
        {
            self.register(UINib(nibName: i, bundle: Bundle.main), forCellReuseIdentifier: i)
        }
    }
    
    // for register System UitableviewCell
    func registerSystemCell(id:String)
    {
        self.register(UITableViewCell.self, forCellReuseIdentifier: id)
    }
    
    // get tableviewCell
    func getCell(cell:String) -> UITableViewCell{
        let tblCell = dequeueReusableCell(withIdentifier: cell)!
        tblCell.selectionStyle = .none
        return tblCell
    }
}

//MARK: - ************* UICollectionView *****************
extension UICollectionView{
    // for register XIB
    func registerNibs(name:[String]){
        for i in name{
            self.register(UINib(nibName: i, bundle: Bundle.main), forCellWithReuseIdentifier: i)
        }
    }
    
    // for register System UicollectionviewCell
    func registerSystemCell(id:String){
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: id)
    }
    
    // get tableviewCell
    func getCell(cell:String,indexPath:IndexPath) -> UICollectionViewCell{
        let cvCell = dequeueReusableCell(withReuseIdentifier: cell, for: indexPath)
        return cvCell
    }
}

//MARK: - ************* Array *****************
extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension Array{
    func lastIndex() -> Int {
        return self.count - 1
    }
}

//MARK: - ************* URL *****************
extension URL{
    // open given url
    func openURL(){
        UIApplication.shared.openURL(self)
    }
}

//MARK: - ************* Array *****************
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

//MARK: - ************* UIApplication *****************
extension UIApplication {
    
    func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

//MARK: - ************* NoSelectTextView *****************
class NoSelectTextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

//MARK: - ************* Dictionary *****************
extension Dictionary{
    func toString() -> String{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("--> ERROR toString :- ",error.localizedDescription)
        }
        
        return ""
    }
}

//MARK: - ************* NSManagedObject *****************
extension NSManagedObject {
    func toDictionary() -> [String: Any] {
        let entity = self.entity
        let attributes = entity.attributesByName.keys

        var dictionary = [String: Any]()
        for attribute in attributes {
            dictionary[attribute] = self.value(forKey: attribute)
        }

        return dictionary
    }
}

//MARK: - ************* UINavigationController *****************
extension UINavigationController {
    func popWithCompletion(animated: Bool, completion: @escaping () -> ()) {
        popViewController(animated: animated)
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
