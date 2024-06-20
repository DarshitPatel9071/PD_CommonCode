//
//  ClassKeyChain.swift
//  Bibal
//
//  Created by Darshit Patel on 02/05/23.
//

import Foundation
import KeychainSwift

public class KeychainAccess{
    
    // STRING
    class func saveString(data:String,forKey:String){
        let keychain = KeychainSwift()
        keychain.set(data, forKey: forKey)
    }
    
    class func getString(forKey:String) -> String?{
        let keychain = KeychainSwift()
        return keychain.get(forKey)
    }
    
    //BOOL
    class func saveBool(bool:Bool,forKey:String){
        let keychain = KeychainSwift()
        keychain.set(bool, forKey: forKey)
    }
    
    class func getBool(forKey:String) -> Bool?{
        let keychain = KeychainSwift()
        return keychain.getBool(forKey)
    }
    
    
    class func removeData(forKey:String) -> Bool{
        let keychain = KeychainSwift()
        return keychain.delete(forKey)
    }
    
}
