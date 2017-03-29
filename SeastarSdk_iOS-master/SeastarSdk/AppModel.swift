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
    
    init() {
        if let content = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let rootDictionary = NSMutableDictionary(contentsOfFile: content) {
                let appDictionary: NSMutableDictionary? = rootDictionary.object(forKey: "AppConfig") as? NSMutableDictionary
                
                if let dict = appDictionary {
                    appId  = dict.object(forKey: "AppId") as! Int
                    appKey = dict.object(forKey: "AppKey") as! String
                    serverUrl = dict.object(forKey: "ServerUrl") as! String
                }
            }
        }

    }
}
