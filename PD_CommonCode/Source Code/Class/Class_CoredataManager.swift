//
//  Class_CoredataManager.swift
//  Wifi Unlocker
//
//  Created by Darshit Patel on 28/09/23.
//

import CoreData
import UIKit
import Foundation


class CoredataManager{
    static let manager:CoredataManager = CoredataManager()
    
    enum ENTITY:String{
        case ConnectionHistory = "ConnectionHistory"
        case PasswordHistory = "PasswordHistory"
        case NearbyWifiList = "NearbyWifiList"
        case WifiRequirement = "WifiRequirement"
        case WifiSendMessage = "WifiSendMessage"
        case SharedWifiList = "SharedWifiList"
    }
    
    enum KEY_NAME:String{
        case id = "id"
        case type = "type"
        case ssid = "ssid"
        case time = "time"
        case password = "password"
        case location = "location"
        case reason = "reason"
        case latitude = "latitude"
        case longitude = "longitude"
        case wifiType = "wifiType"
    }
    
    private let context = NSPersistentContainer().viewContext
//    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

// Basic Operation
extension CoredataManager{
    private func GET_DATA(entityName:ENTITY,by:[(KEY_NAME,Any)]=[]) -> [NSManagedObject]{
        var arr = [NSManagedObject]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        if !by.isEmpty{
            var arrNSPredicate = [NSPredicate]()
            by.forEach({
                arrNSPredicate.append(NSPredicate(format: "(\($0.0) = %@)", "\($0.1)"))
            })
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: arrNSPredicate)
        }
        
        do {
            let result = try context.fetch(request)
            arr = result as! [NSManagedObject]
            
        }catch{
            print("Failed")
        }
        
        return arr
    }
    
    private func ADD_DATA(entityName:ENTITY,dic:[String:Any]){
        let entity = NSEntityDescription.entity(forEntityName: entityName.rawValue, in: context)
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        for (key,value) in dic{
            newData.setValue(value, forKey: key)
        }
        
        do {
            try context.save()
        } catch {
            print("--> CD :- Error saving :- ",error.localizedDescription)
            CustomToast.toastMessage(message: .msg_SomethingWrong, duration: 3, type: .ERROR)
        }
    }
    
    private func UPDATE_DATA(obj:NSManagedObject,dic:[String:Any]){
        let newData = obj
        for (key,value) in dic{
            newData.setValue(value, forKey: key)
        }
        
        do {
            try context.save()
        } catch {
            print("--> CD :- Error Update :- ",error.localizedDescription)
            CustomToast.toastMessage(message: .msg_SomethingWrong, duration: 3, type: .ERROR)
        }
    }
    
    private func DELETE_DATA(obj:NSManagedObject,entityName:ENTITY){
        context.delete(obj)
        do {
            try context.save()
        } catch {
            print("--> CD :- Error delete :- ",error.localizedDescription)
            CustomToast.toastMessage(message: .msg_SomethingWrong, duration: 3, type: .ERROR)
        }
    }
    
    private func DELETE_ALL_DATA(entityName:ENTITY){
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch
        {
            print("--> CD :- Error Delete All:- ",error.localizedDescription)
            CustomToast.toastMessage(message: .msg_SomethingWrong, duration: 3, type: .ERROR)
        }
    }
}
