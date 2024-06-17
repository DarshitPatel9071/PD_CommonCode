//
//  UIViewController's Extension.swift
//  Whatsoo
//
//  Created by Darshit patel on 20/09/22.
//

import UIKit
import Photos
import Foundation
import CoreLocation
import AVFoundation
import MobileCoreServices



extension UIViewController{
    
    // get storyboard
    func getVC(withIdentifier:ViewControllerID,sb:StoryBoradType) -> UIViewController
    {
        let sb = UIStoryboard(name: sb.rawValue, bundle: .main)
        return sb.instantiateViewController(withIdentifier: withIdentifier.rawValue)
    }
    
    // Push on viewController
    func pushOnVC(viewController:UIViewController,animated:Bool=true)
    {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    // Push on viewController with Identifier
    func pushOnVC(withIdentifier:ViewControllerID,type:StoryBoradType,animated:Bool=true)
    {
        let newVC = getVC(withIdentifier: withIdentifier, sb: type)
        pushOnVC(viewController: newVC, animated: animated)
    }
    
    // Present on viewController
    func presentOnVC(viewController:UIViewController,
                     presentationStyle:UIModalPresentationStyle = .overFullScreen,
                     animated:Bool=true,
                     completion:(()->Void)? = nil)
    {
        viewController.modalPresentationStyle = presentationStyle
        self.navigationController?.present(viewController, animated: animated){
            completion?()
        }
    }
    
    // Present on viewController with Identifier
    func presentOnVC(withIdentifier: ViewControllerID,
                     type:StoryBoradType,
                     presentationStyle:UIModalPresentationStyle = .overFullScreen,
                     animated:Bool=true,
                     completion:(()->Void)? = nil)
    {
        let newVC = getVC(withIdentifier: withIdentifier, sb: type)
        presentOnVC(viewController: newVC,presentationStyle: presentationStyle,animated: animated){
            completion?()
        }
    }
    
    // Pop on Parents viewController
    func popVC(animated:Bool=true)
    {
        self.navigationController?.popViewController(animated: animated)
    }
    
    // Pop on Specific viewController
    func popSpecificVC(vc:UIViewController.Type,animated:Bool=true)
    {
        if let arrVC = self.navigationController?.viewControllers{
            for controller in arrVC
            {
                if controller.isKind(of: vc.self)
                {
                    self.navigationController?.popToViewController(controller, animated: animated)
                    break
                }
            }
        }
    }
    
    /*func popGestureRecognizerIsEnabled(isEnabled:Bool = true){
     navigationController?.interactivePopGestureRecognizer?.delegate = nil
     navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabled
     }*/
}

extension UIViewController{
    func commonAlert(title:String,
                     message:String,
                     preferredStyle:UIAlertController.Style = .alert,
                     arrAction:[String] = [],
                     cancelTitle:String = .str_Cancel,
                     voidSelectedAction:((Int,String) -> Void)? = nil,
                     voidCancelAction:(() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for actionIndex in 0..<arrAction.count {
            let actionTitle = arrAction[actionIndex]
            alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { act in
                voidSelectedAction?(actionIndex,actionTitle)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { act in
            voidCancelAction?()
        }))
        
        presentOnVC(viewController: alertController)
    }
    
    func shareAnyData(data:[Any]){
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: data, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // present the view controller
        
        CustomLoader.show()
        presentOnVC(viewController: activityViewController){
            CustomLoader.hide()
        }
    }
}

// OPEN Common View Controller
extension UIViewController{
    @objc func OpenRemoveAdScreenForNativeAd(){
    }
}

enum ImagePickerType{
    case PHOTO
    case VIDEO
    case BOTH
    
    func getInfo() -> [String]{
        switch self {
        case .PHOTO:
            return [kUTTypeImage as String]
        case .VIDEO:
            return ["public.movie"]
        case .BOTH:
            return ["public.movie",kUTTypeImage as String]
        }
    }
}

extension UIViewController{
    func openGalleryOrCamera(delegate:UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                             source:UIImagePickerController.SourceType = .photoLibrary,
                             type:ImagePickerType = .PHOTO,
                             isImageEdit:Bool = false) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.mediaTypes = type.getInfo()
        imagePicker.delegate = delegate
        imagePicker.allowsEditing = isImageEdit
        
        CustomLoader.show()
        presentOnVC(viewController: imagePicker){
            CustomLoader.hide()
        }
    }
}

extension UIViewController{
    func removeNCObserver(){
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIViewController{
    func checkLocationIsEnabled(void:@escaping((Bool)->Void)){
        ClassPermissionManager.manager.askPermission(type: .Check_LocationServicesEnabled) { [self] status in
            if status == 1{
                void(true)
            }else{
                void(false)
                self.commonAlert(title: .per_LocationDisbledTitle,
                                    message: "",
                                    arrAction: [.str_Enable],
                                    cancelTitle: .str_Cancel) { (index, title) in
                     // open setting app
                    SETTING_APP_URL.locationService.openURL()
                 }
            }
        }
    }
    
    func checkAndAskLocationPermission(void:@escaping((Bool)->Void)){
        // check & ask location permission
        ClassPermissionManager.manager.askPermission(type: .Check_Location) { [self] status in
            let perStatus = CLAuthorizationStatus.init(rawValue: Int32(status))
            if perStatus == .denied || perStatus == .notDetermined || perStatus == .restricted {
    
                /*let vc = getVC(withIdentifier: .permissionAskVC, sb: .popup) as! PermissionAskVC
                vc.perType = .Location
                vc.askPermission = {

                    if perStatus == .notDetermined{
                        ClassPermissionManager.manager.askPermission(type: .Ask_Location) { isSuccess in
                            let newPerStatus = CLAuthorizationStatus.init(rawValue: Int32(isSuccess))
                            if newPerStatus == .authorizedAlways || newPerStatus == .authorizedWhenInUse{
                                void(true)
                            }else{
                                void(false)
                            }
                        }
                    }else{
                        SETTING_APP_URL.appSetting.openURL()
                        void(false)
                    }
                }
                
                vc.voidDismiss = {
                    void(false)
                }
                
                self.presentOnVC(viewController: vc,animated: false)*/
            }else{
                void(true)
            }
        }
    }
    
    func checkAndAskAVCaptureDevicePermission(void:@escaping((Bool)->Void)){
        // check & ask location permission
        ClassPermissionManager.manager.askPermission(type: .Check_AVCaptureDevice) { [self] status in
            let perStatus = AVAuthorizationStatus.init(rawValue: status)
            if perStatus == .denied || perStatus == .notDetermined || perStatus == .restricted {
    
                /*let vc = getVC(withIdentifier: .permissionAskVC, sb: .popup) as! PermissionAskVC
                vc.perType = .AVCaptureDevice
                vc.askPermission = {

                    if perStatus == .notDetermined{
                        ClassPermissionManager.manager.askPermission(type: .Ask_AVCaptureDevice) { isSuccess in
                            let newPerStatus = AVAuthorizationStatus.init(rawValue: isSuccess)
                            if newPerStatus == .authorized{
                                void(true)
                            }else{
                                void(false)
                            }
                        }
                    }else{
                        SETTING_APP_URL.appSetting.openURL()
                        void(false)
                    }
                }
                
                vc.voidDismiss = {
                    void(false)
                }
                
                self.presentOnVC(viewController: vc,animated: false)*/
            }else{
                void(true)
            }
        }
    }
    
    func checkAndAskPHPhotoLibraryPermission(void:@escaping((Bool)->Void)){
        // check & ask location permission
        ClassPermissionManager.manager.askPermission(type: .Check_PHPhotoLibrary) { [self] status in
            let perStatus = PHAuthorizationStatus.init(rawValue: status)
            if perStatus == .denied || perStatus == .notDetermined || perStatus == .restricted {
    
                /*let vc = getVC(withIdentifier: .permissionAskVC, sb: .popup) as! PermissionAskVC
                vc.perType = .PHPhotoLibrary
                vc.askPermission = {

                    if perStatus == .notDetermined{
                        ClassPermissionManager.manager.askPermission(type: .Ask_PHPhotoLibrary) { isSuccess in
                            let newPerStatus = PHAuthorizationStatus.init(rawValue: isSuccess)
                            if newPerStatus == .authorized{
                                void(true)
                            }else{
                                void(false)
                            }
                        }
                    }else{
                        SETTING_APP_URL.appSetting.openURL()
                        void(false)
                    }
                }
                
                vc.voidDismiss = {
                    void(false)
                }
                
                self.presentOnVC(viewController: vc,animated: false)*/
            }else{
                void(true)
            }
        }
    }
}
