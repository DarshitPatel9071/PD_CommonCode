//
//  Class_CustomAnnotation.swift
//  Wifi Unlocker
//
//  Created by macOS on 10/10/23.
//

import UIKit
import MapKit
import Foundation

public class CustomPointAnnotation : MKPointAnnotation {
    var identifier: String?
    var img:UIImage?
    
    init(identifier: String? = nil, img: UIImage? = nil, tmpTitle:String) {
        super.init()
        self.identifier = identifier
        self.img = img
        
        title = tmpTitle
    }
}
