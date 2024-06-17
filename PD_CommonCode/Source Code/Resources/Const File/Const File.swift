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
