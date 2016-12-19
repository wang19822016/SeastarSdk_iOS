//
//  UserViewModel.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation
import UIKit

class UserViewModel {
    
    static let current = UserViewModel()
    
    func doGuestLogin(success: @escaping (UserModel)->Void, failure: @escaping (String)->Void) {
        let app = AppModel()
        if !app.load() {
            failure("-1")
            return
        }
        
        let signStr = "\(app.appId)\(deviceId())\(app.appKey)"
        let md5Str = md5(string: signStr)
        
        let req: [String : Any] = [
            "appId": app.appId,
            "deviceId": deviceId(),
            "sign": md5Str
        ]
        
        MyNetwork.current.post(url: app.serverUrl + "/v2/auth/guest", json: req, success: { data in
            
            if let code = data["code"] as? String {
                if code == "0"{
                    var user = UserModel()
                    if user.load(userId: (data["userId"] as? Int ?? 0)) {
                        
                    }
                    user.userId = data["userId"] as? Int ?? 0
                    user.userName = data["userName"] as? String ?? ""
                    let password = data["password"] as? String ?? ""
                    if !password.isEmpty{
                        user.password = password;
                    }
                    user.status = data["status"] as? Int ?? UserStatus.ALLOW.rawValue
                    user.guestUserId = deviceId()
                    user.session = data["session"] as? String ?? ""
                    user.save()
                    user.saveAsCurrentUser()
                    
                    success(user)
                }else{
                    failure(code)
                }
            } else {
                failure("-1")
            }
        }, failure: { failure("-1") })
        
    }
    
    func doFacebookLogin(viewController: UIViewController, success: @escaping (UserModel)->Void, failure: @escaping (String)->Void) {
        
        Facebook.current.login(viewController: viewController, success: { fbuserId, token in
            let app = AppModel()
            if !app.load() {
                failure("-1")
                return
            }
            
            let signstr = "\(deviceId())\(fbuserId)\(token)\(LoginType.FACEBOOK.rawValue)\(app.appKey)"
            let md5str = md5(string: signstr)
            
            let req: [String : Any] = [
                "appId": app.appId,
                "deviceId": deviceId(),
                "thirdUserId": fbuserId,
                "thirdAccessToken": token,
                "loginType": LoginType.FACEBOOK.rawValue,
                "sign": md5str
            ]
            
            MyNetwork.current.post(url: app.serverUrl + "/v2/auth/thirdparty", json: req, success: { data in
                if let code = data["code"] as? String{
                    if code == "0"{
                        var user = UserModel()
                        if user.load(userId: (data["userId"] as? Int ?? 0)) {
                            
                        }
                        user.userId = data["userId"] as? Int ?? 0
                        user.userName = data["userName"] as? String ?? ""
                        let password = data["password"] as? String ?? ""
                        if !password.isEmpty{
                            user.password = password;
                        }
                        user.status = data["status"] as? Int ?? UserStatus.ALLOW.rawValue
                        user.facebookUserId = fbuserId
                        user.session = data["session"] as? String ?? ""
                        user.save()
                        user.saveAsCurrentUser()
                        
                        success(user)
                    }else{
                        failure(code);
                    }
                } else {
                    failure("-1")
                }
            }, failure: { failure("-1") })
        }, failure: { failure("-1") })
    }
    
    func doAccountLogin(username:String, password:String, email: String, opType:LoginOPType, success: @escaping (UserModel)->Void, failure: @escaping (String)->Void) {
        let app = AppModel()
        if !app.load() {
            failure("-1")
            return
        }
        
        var loginPassword = password
        
        let signStr = "\(app.appId)\(deviceId())\(username)\(loginPassword)\(opType.rawValue)\(app.appKey)"
        let md5Str = md5(string: signStr)
        
        let req: [String : Any] = [
            "appId": app.appId,
            "deviceId": deviceId(),
            "userName": username,
            "password": loginPassword,
            "regist" : opType.rawValue,
            "email": email,
            "sign": md5Str
        ]
        
        MyNetwork.current.post(url: app.serverUrl + "/v2/auth/username", json: req, success: { data in
            if let code = data["code"] as? String{
                if code == "0"{
                    var user = UserModel()
                    if user.load(userId: (data["userId"] as? Int ?? 0)) {
                        
                    }
                    user.userId = data["userId"] as? Int ?? 0
                    user.userName = data["userName"] as? String ?? ""
                    user.password = data["password"] as? String ?? ""
                    user.status = data["status"] as? Int ?? UserStatus.ALLOW.rawValue
                    user.session = data["session"] as? String ?? ""
                    user.save()
                    user.saveAsCurrentUser()
                    
                    success(user)
                }else{
                    failure(code);
                }
            } else {
                failure("-1")
            }
        }, failure: { failure("-1") })
    }
    
    func doSessionLogin(usermodel:UserModel, success: @escaping (UserModel)->Void, failure: @escaping (String)->Void) {
        let app = AppModel()
        if !app.load() {
            failure("-1")
            return
        }
        
        let req: [String : Any] = [
            "session": usermodel.session,
            ]
        
        MyNetwork.current.post(url: app.serverUrl + "/v2/auth/session", json: req, success: { data in
            if let code = data["code"] as? String{
                if code == "0"{
                    var user = UserModel()
                    if user.load(userId: (data["userId"] as? Int ?? 0)) {
                        
                    }
                    user.userId = data["userId"] as? Int ?? 0
                    user.userName = data["userName"] as? String ?? ""
                    //user.password = data["password"] as? String ?? ""
                    user.status = data["status"] as? Int ?? UserStatus.ALLOW.rawValue
                    user.session = data["session"] as? String ?? ""
                    user.save()
                    user.saveAsCurrentUser()
                    
                    success(user)
                }else{
                    failure(code);
                }
            } else {
                failure("-1")
            }
        }, failure: { failure("-1") })
    }
    
    func doLogout() {
        let app = AppModel()
        if !app.load() {
            return
        }
        Facebook.current.logout()
        let user = UserModel()
        user.removeCurrentUser()
        let req: [String : Any] = [
            "session" : user.session
        ]
        MyNetwork.current.post(url: app.serverUrl + "/v2/auth/logout", json: req, success: { (_) in
        }) {
        }
    }
    
    func findPwd(_ username: String) {
        let app = AppModel()
        if !app.load() {
            return
        }
        
        let signStr = "\(app.appId)\(username)\(app.appKey)"
        let md5Str = md5(string: signStr)
        
        let req: [String : Any] = [
            "appId" : app.appId,
            "userName" : username,
            "sign" : md5Str
        ]
        
        MyNetwork.current.post(url: app.serverUrl + "/v2/auth/findpwd", json: req, success: { result in }, failure: {})
    }
}
