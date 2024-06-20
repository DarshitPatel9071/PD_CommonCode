//
//  Class_PermissionManager.swift
//  Bibal
//
//  Created by Darshit Patel on 19/02/23.
//

import UIKit
import Foundation
import Photos
import UserNotifications
import CoreLocation

struct SETTING_APP_URL{
    static let appSetting = UIApplication.openSettingsURLString
    static let locationService = "App-Prefs:root=LOCATION_SERVICES"
    static let wifi = "App-Prefs:root=WIFI"
}

public class ClassPermissionManager : NSObject{
    
    //MARK: - PUBLIC VARIABLE'S
    static let manager:ClassPermissionManager = ClassPermissionManager()
    private var resBlock:((Int)->Void)!
    private let manager = CLLocationManager()
    
    enum TYPE : String{
        // For ask permission
        case Ask_PHPhotoLibrary = "PHPhotoLibrary"
        case Ask_UNUserNotification = "UNUserNotification"
        case Ask_Location = "Location"
        case Ask_AVCaptureDevice = "AVCaptureDevice"
        
        // For check permission status
        case Check_PHPhotoLibrary = "Check_PHPhotoLibrary"
        case Check_LocationServicesEnabled = "Check_LocationServicesEnabled"
        case Check_Location = "Check_LocationPermission"
        case Check_AVCaptureDevice = "Check_AVCaptureDevice"
    }
    
    
}

extension ClassPermissionManager{
    
    func askPermission(type:TYPE,isSucess:@escaping((Int) -> Void)){
        
        resBlock = isSucess
        
        switch type {
            
        case .Ask_PHPhotoLibrary:
            ASK_PHPhotoLibrary()
        case .Ask_UNUserNotification:
            UNUserNotificatioPermission()
        case .Ask_Location:
            ASK_CLLocation()
        case .Ask_AVCaptureDevice:
            ASK_AVCaptureDevice()
            
        case .Check_PHPhotoLibrary:
            Check_PHPhotoLibrary()
        case .Check_LocationServicesEnabled:
            Check_LocationServicesEnabled()
        case .Check_Location:
            Check_CLLocation()
        case .Check_AVCaptureDevice:
            Check_AVCaptureDevice()
        }
        
    }
    
    // open setting app for ask Notification permission
    func openSettingApp(type:TYPE){
        if let rootVc = UIApplication.shared.getTopViewController()
        {
            DispatchQueue.main.async {
                rootVc.commonAlert(title: String(format: .per_CommonTitle, type.rawValue),
                                    message: .per_CommonDes,
                                    arrAction: [.str_Allow],
                                    cancelTitle: .str_DontAllow) { (index, title) in
                     // open setting app
                    SETTING_APP_URL.appSetting.openURL()
                 }
            }
        }
    }
}


extension ClassPermissionManager{
    fileprivate func UNUserNotificatioPermission(){
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.badge]) {[self]  (granted, error) in
                resBlock(granted ? 1 : 0)
                if !granted{
                    self.openSettingApp(type: .Ask_UNUserNotification)
                }
            }
        }
    }
}

//LOCATION
extension ClassPermissionManager : CLLocationManagerDelegate{
    fileprivate func Check_LocationServicesEnabled(){
        resBlock(CLLocationManager.locationServicesEnabled() ? 1 : 0)
    }
    
    fileprivate func Check_CLLocation(isSettingAlert:Bool = false){
        
        let status = CLLocationManager.authorizationStatus()
        resBlock(Int(status.rawValue))
        
        if isSettingAlert && (status == .denied || status == .restricted){
            self.openSettingApp(type: .Ask_Location)
        }
    }
    
    fileprivate func ASK_CLLocation(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Check_CLLocation()
    }
}

// AVCaptureDevice
extension ClassPermissionManager{
    
    fileprivate func ASK_AVCaptureDevice(){
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) -> Void in
            self.Check_AVCaptureDevice()
        })
    }
    
    fileprivate func Check_AVCaptureDevice(isSettingAlert:Bool = false){
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        resBlock(Int(status.rawValue))
        
        if isSettingAlert && (status == .denied || status == .restricted){
            self.openSettingApp(type: .Ask_AVCaptureDevice)
        }
    }
    
}

// PHPhotoLibrary
extension ClassPermissionManager{
    fileprivate func ASK_PHPhotoLibrary(){
        PHPhotoLibrary.requestAuthorization(){[self] status in
            self.Check_PHPhotoLibrary()
        }
    }
    
    fileprivate func Check_PHPhotoLibrary(isSettingAlert:Bool = false){
        
        let status = PHPhotoLibrary.authorizationStatus()
        resBlock(Int(status.rawValue))
        
        if isSettingAlert && (status == .denied || status == .restricted){
            self.openSettingApp(type: .Ask_AVCaptureDevice)
        }
    }
    
}
