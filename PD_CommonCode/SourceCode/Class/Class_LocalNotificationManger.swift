//
//  Class_LocalNotificationManger.swift
//  Govt Exam se Sarkari Naukri
//
//  Created by iMac on 03/10/22.
//

import UIKit
import Foundation
//import SwiftyJSON
import UserNotifications

public class LocalNotificationManager:NSObject{
    
    let center = UNUserNotificationCenter.current() // notification center var
    private var objNotification:Class_LocalNotificationDetail!
    private var voidSucess:((Bool) -> ())?
    
    init(obj:Class_LocalNotificationDetail? = nil,
         isSucess:((Bool) -> ())? = nil){
        objNotification = obj
        voidSucess = isSucess
    }
}

//MARK:- Custom function's
extension LocalNotificationManager{
    // ask local notification permission
    func askNotificationPermission(){
        // set the type as sound or badge
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            if granted{
                self.setReminder()
            }else{
                if self.objNotification.isFor == .LessionOfDay{self.voidSucess?(false)}
                self.openSettingApp()
            }
        }
    }
    
    // open setting app for ask Notification permission
    private func openSettingApp(){
        DispatchQueue.main.async {
            if let tmpRootVC = self.objNotification.baseVC ?? UIApplication.shared.getTopViewController(){
                tmpRootVC.commonAlert(title: .per_NotificationTitle,
                                      message: .per_NotificationDes,
                                      arrAction: [.str_Allow],
                                      cancelTitle: .str_DontAllow) { (index, title) in
                    // open setting app
                    SETTING_APP_URL.appSetting.openURL()
                } voidCancelAction: {
                    if self.objNotification.isFor != .LessionOfDay{self.voidSucess?(false)}
                }
            }else{
                self.voidSucess?(false)
            }
        }
    }
    
    // remove reminder for givenID
    func removeReminder(identifier:String){
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // set reminder for given date or time
    private func setReminder(){
        let lastDateComponant = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: objNotification.time)
        
        // setup reminder date & time
        var reminderDateComponant = DateComponents()
        reminderDateComponant.hour = lastDateComponant.hour ?? 9
        reminderDateComponant.minute = lastDateComponant.minute ?? 0
        
        
        // setup reminder content
        let reminderContent = UNMutableNotificationContent()
        reminderContent.title = objNotification.title
        reminderContent.body = objNotification.body
        reminderContent.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: "Alarm.mp3"))//UNNotificationSound.default
        
        
        // trigger notification for reminder
        let reminderTrigger = UNCalendarNotificationTrigger(dateMatching: reminderDateComponant, repeats: objNotification.isRepeat)
        let reminderRequest = UNNotificationRequest(identifier: objNotification.identifier, content: reminderContent, trigger: reminderTrigger)
        
        center.add(reminderRequest, withCompletionHandler: { error in
            var msg:String = self.objNotification.toastMsg
            if let error = error {
                print("Reminder Not set :- ",error.localizedDescription)
                if !msg.isEmpty{ msg = .msg_SomethingWrong}
            }
            
            if !msg.isEmpty{CustomToast.toastMessage(message: msg)}
            self.voidSucess?(error == nil)
        })
    }
}

//MARK:- Tap of Notification
extension LocalNotificationManager{
    
    func didTapNotification(response:UNNotificationResponse){
        let tmpIdentifier = response.notification.request.identifier
        navigateOnNotificationTap(identifier: tmpIdentifier)
    }
    
    func navigateOnNotificationTap(identifier:String){
    }
}
