//
//  Utility.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation
import AdSupport
import CommonCrypto

class Utility {
    
    static func deviceId() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    static func deviceInfo() -> String {
        return "System: \(UIDevice.current.systemName):\(UIDevice.current.systemVersion), Model: \(UIDevice.current.model)"
    }
    
    static func locale() -> String {
        return UserDefaults.standard.object(forKey: "AppleLanguages") as? String ?? ""
    }
    
    static func plist() -> AppModel? {
        if let content = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let rootDictionary = NSMutableDictionary(contentsOfFile: content) {
                let appDictionary: NSMutableDictionary? = rootDictionary.object(forKey: "AppConfig") as? NSMutableDictionary
                
                if let dict = appDictionary {
                    var appModel: AppModel = AppModel()
                    appModel.appId  = dict.object(forKey: "AppId") as? Int
                    appModel.appKey = dict.object(forKey: "AppKey") as? String
                    appModel.serverUrl = dict.object(forKey: "ServerUrl") as? String
                    return appModel
                }
            }
        }
        
        return nil
    }
    
    static func md5(string data: String) -> String {
        let str = data.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(data.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
    
}
