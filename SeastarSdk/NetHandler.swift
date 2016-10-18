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
    
    static func doFacebookLogin(uid: String, token: String) {
        let uuid = Utility.deviceId()
        let locale = Utility.locale()
        let thirdUserId = uid
        let thirdUserToken = token
        let loginType = LoginType.FACEBOOK.rawValue
        let deviceInfo = Utility.deviceInfo()
        
        if let appModel = Utility.plist() {
            let signstr = "\(uuid)\(locale)\(thirdUserId)\(thirdUserToken)\(loginType)\(appModel.appKey)"
            let md5str = Utility.md5(string: signstr)
            
            let req: JSON = [
                "appId": appModel.appId,
                "deviceId": uuid,
                "locale": locale,
                "deviceInfo": deviceInfo,
                "thirdUserId": thirdUserId,
                "thirdAccessToken": thirdUserToken,
                "loginType": loginType,
                "sign": md5str
            ]
            
            Network.post(url: appModel.serverUrl!, body: req.stringValue, success: { data in
                }, failure: { () in
            })
        }
    }
    
    static func doAccountLogin(username:String, password:String, email: String, regist:OPType) {
        let uuid = Utility.deviceId()
        let locale = Utility.locale()
        let deviceInfo = Utility.locale()
        if let appModel = Utility.plist() {
            let signstr = "\(uuid)\(locale)\(username)\(password)\(regist)\(appModel.appKey)"
            let md5str = Utility.md5(string: signstr)
            
            let req: JSON = [
                "appId": appModel.appId,
                "deviceId": uuid,
                "locale": locale,
                "deviceInfo": deviceInfo,
                "userName": username,
                "password": password,
                "regist": regist.rawValue,
                "email": email,
                "sign": md5str
            ]
            
            Network.post(url: appModel.serverUrl!, body: req.stringValue, success: { data in
                }, failure: { () in
            })
        }
    }
    

}

