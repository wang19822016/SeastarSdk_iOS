//
//  UserViewModel.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation

class UserViewModel {
    
    static let current = UserViewModel()
    
    func doGuestLogin(success: @escaping (UserModel)->Void, failure: @escaping ()->Void) {
        let app = AppModel()
        if !app.load() {
            failure()
            return
        }
        
        let signStr = "\(app.appId)\(deviceId())\(locale())\(app.appKey)"
        let md5Str = md5(string: signStr)
        
        let req: [String : Any] = [
            "appId": app.appId,
            "deviceId": deviceId(),
            "locale": locale,
            "deviceInfo": deviceInfo,
            "sign": md5Str
        ]
        
        Network.post(url: app.serverUrl, json: req, success: { data in
            
            let user = UserModel()
            user.load(userId: (data["userId"] as? Int ?? 0))
            user.userId = data["userId"] as? Int ?? 0
            user.userName = data["userName"] as? String ?? ""
            user.password = data["password"] as? String ?? ""
            user.status = data["status"] as? Int ?? UserStatus.ALLOW.rawValue
            user.isNewUser = data["newUser"] as? Int ?? UserNewOrOld.OLD.rawValue
            user.guestUserId = deviceId()
            user.session = data["session"] as? String ?? ""
            user.save()
            
            success(user)
            }, failure: { failure() })

    }
    
    func doFacebookLogin(viewController: UIViewController, success: @escaping (UserModel)->Void, failure: @escaping ()->Void) {
        
        Facebook.current.login(viewController: viewController, success: { fbuserId, token in
                let app = AppModel()
                if !app.load() {
                    failure()
                    return
                }
                
                let signstr = "\(deviceId())\(locale())\(fbuserId)\(token)\(LoginType.FACEBOOK.rawValue)\(app.appKey)"
                let md5str = md5(string: signstr)
                
                let req: [String : Any] = [
                    "appId": app.appId,
                    "deviceId": deviceId(),
                    "locale": locale(),
                    "deviceInfo": deviceInfo(),
                    "thirdUserId": fbuserId,
                    "thirdAccessToken": token,
                    "loginType": LoginType.FACEBOOK.rawValue,
                    "sign": md5str
                    ]
                
                Network.post(url: app.serverUrl, json: req, success: { data in
                    let user = UserModel()
                    user.load(userId: (data["userId"] as? Int ?? 0))
                    user.userId = data["userId"] as? Int ?? 0
                    user.userName = data["userName"] as? String ?? ""
                    user.password = data["password"] as? String ?? ""
                    user.status = data["status"] as? Int ?? UserStatus.ALLOW.rawValue
                    user.isNewUser = data["newUser"] as? Int ?? UserNewOrOld.OLD.rawValue
                    user.facebookUserId = fbuserId
                    user.session = data["session"] as? String ?? ""
                    user.save()
                    
                    success(user)
                    
                    }, failure: { failure() })
            }, failure: { failure() })
    }
    
    func doAccountLogin(username:String, password:String, email: String, opType:LoginOPType, success: @escaping (UserModel)->Void, failure: @escaping ()->Void) {
        let app = AppModel()
        if !app.load() {
            failure()
            return
        }
        
        let signStr = "\(app.appId)\(deviceId())\(locale())\(username)\(password)\(opType.rawValue)\(app.appKey)"
        let md5Str = md5(string: signStr)
        
        let req: [String : Any] = [
            "appId": app.appId,
            "deviceId": deviceId(),
            "locale": locale(),
            "deviceInfo": deviceInfo(),
            "userName": username,
            "password": password,
            "regist" : opType.rawValue,
            "email": email,
            "sign": md5Str
        ]
        
        Network.post(url: app.serverUrl, json: req, success: { data in
            
            let user = UserModel()
            user.load(userId: (data["userId"] as? Int ?? 0))
            user.userId = data["userId"] as? Int ?? 0
            user.userName = data["userName"] as? String ?? ""
            user.password = data["password"] as? String ?? ""
            user.status = data["status"] as? Int ?? UserStatus.ALLOW.rawValue
            user.isNewUser = data["newUser"] as? Int ?? UserNewOrOld.OLD.rawValue
            user.session = data["session"] as? String ?? ""
            user.save()
            
            success(user)
            }, failure: { failure() })
    }
    
    func doSessionLogin(success: @escaping (UserModel)->Void, failure: @escaping ()->Void) {
        let app = AppModel()
        if !app.load() {
            failure()
            return
        }
        
        let req: [String : Any] = [
            "appId": app.appId,
            "session": deviceId(),
            "userId": 0,
            "locale": locale(),
            "deviceInfo": deviceInfo()
        ]
        
        Network.post(url: app.serverUrl, json: req, success: { data in
            
            let user = UserModel()
            user.load(userId: (data["userId"] as? Int ?? 0))
            user.userId = data["userId"] as? Int ?? 0
            user.userName = data["userName"] as? String ?? ""
            user.password = data["password"] as? String ?? ""
            user.status = data["status"] as? Int ?? UserStatus.ALLOW.rawValue
            user.isNewUser = data["newUser"] as? Int ?? UserNewOrOld.OLD.rawValue
            user.session = data["session"] as? String ?? ""
            user.save()
            
            success(user)
            }, failure: { failure() })
    }
    
    func doLogout() {
        Facebook.current.logout()
        UserModel.removeCurrentUser()
    }
}
