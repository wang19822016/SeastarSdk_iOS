//
//  NetHandler.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/10/17.
//
//

import Foundation

class NetHandler {
    static func doGuestLogin() {
        let uuid = Utility.deviceId()
        let locale = Utility.locale()
        let deviceInfo = Utility.deviceInfo()
        
        if let appModel = Utility.plist() {
            let signStr = "\(appModel.appId)\(uuid)\(locale)\(appModel.appKey)"
            let md5Str = Utility.md5(string: signStr)
            
            let req: JSON = [
                "appId": appModel.appId ?? 0,
                "deviceId": uuid,
                "locale": locale,
                "deviceInfo": deviceInfo,
                "sign": md5Str
            ]
            
            Network.post(url: appModel.serverUrl!, body: req.rawString()!, success: { (data: String) -> Void in
                
                }, failure: { () -> Void in
                    
            })
        }
    }

}

