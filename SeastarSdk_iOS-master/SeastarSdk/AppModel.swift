//
//  AppModel.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/27.
//
//

import Foundation

class AppModel {
    var appId: Int = 0
    var appKey: String = ""
    var serverUrl: String = ""
    var appsFlyerID:String = ""
    var appsFlyerKey:String = ""
    
    func load() -> Bool {
        if let content = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let rootDictionary = NSMutableDictionary(contentsOfFile: content) {
                let appDictionary: NSMutableDictionary? = rootDictionary.object(forKey: "AppConfig") as? NSMutableDictionary
                
                if let dict = appDictionary {
                    if dict.object(forKey: "AppId") == nil {
                        return false
                    }
                    
                    if dict.object(forKey: "AppKey") == nil {
                        return false
                    }
                    
                    if dict.object(forKey: "ServerUrl") == nil {
                        return false
                    }
                    
                    if dict.object(forKey: "appsFlyerID") == nil{
                        return false
                    }
                    
                    if dict.object(forKey: "appsFlyerKey") == nil{
                        return false
                    }
                    
                    appId  = dict.object(forKey: "AppId") as! Int
                    appKey = dict.object(forKey: "AppKey") as! String
                    serverUrl = dict.object(forKey: "ServerUrl") as! String
                    appsFlyerID = dict.object(forKey: "AppsFlyerID")as! String
                    appsFlyerKey = dict.object(forKey: "AppsFlyerKey")as! String
                    
                    return true
                }
            }
        }

        return false
    }
}
