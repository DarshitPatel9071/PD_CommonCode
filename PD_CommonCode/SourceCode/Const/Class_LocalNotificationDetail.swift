//
//  Class_LocalNotificationDetail.swift
//  Bibal
//
//  Created by Darshit Patel on 14/07/23.
//

import Foundation
import UIKit

enum LocalNotificationFor{
    case LessionOfDay
    case BibleAlarm
}

struct Class_LocalNotificationDetail{
    
    var time:Date!
    var toastMsg:String = ""
    var identifier:String
    var title:String
    var body:String
    var baseVC:UIViewController? = nil
    var isRepeat:Bool = true
    var isFor:LocalNotificationFor = .LessionOfDay
}


