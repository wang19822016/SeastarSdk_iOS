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
    
    func doRegist(_ username: String, _ password: String, _ email: String, _ type: Int, _ success: @escaping ()->Void, _ failure: @escaping ()->Void) {
        let app = AppModel()
        if !app.load() {
            failure()
            return
        }
        
        let signStr = "\(app.appId)\(type)\(email)\(app.appKey)"
        let body: [String : Any] = ["appId" : app.appId, "email" : email, "type" : type, "sign" : md5(string: signStr)]
        print(signStr);

        MyNetwork.current.post(app.serverUrl + "/api/user", ["Authorization" : "Basic " + b64Encode(username + ":" + password)!], body, {
            code, response in
            if code == 201 {
                // 注册成功
                print(code);
                print(response);
                success()
            } else {
                print(code);
                print(response);

                failure()
            }
        }, {
            failure()
        })
    }
    
    func doLogin(_ username: String, _ password: String, _ type: Int, _ success: @escaping(UserModel)->Void, _ failure: @escaping ()->Void) {
        let app = AppModel()
        if !app.load() {
            failure()
            return
        }
        
        let signStr = "\(app.appId)\(type)\(app.appKey)"
        let body: [String : Any] = ["appId" : app.appId, "type" : type, "sign" : md5(string: signStr)]
        
        MyNetwork.current.post(app.serverUrl + "/api/user/token", ["Authorization" : "Basic " + b64Encode(username + ":" + password)!], body, {
            code, response in
            if code == 200 {
                // 注册成功
                print("登陆成功");
                let user = UserModel(token: (response["access_token"] as? String) ?? "")
                user.save()
                user.saveAsCurrentUser()

                success(user)
            } else {
                failure()
            }
        }, {
            failure()
        })
    }
    
    func doLoginAndRegistAndLogin(_ username: String, _ password: String, _ type: Int, _ success: @escaping (UserModel)->Void, _ failure: @escaping ()->Void) {
        let app = AppModel()
        if !app.load() {
            failure()
            return
        }
        
        let signStr = "\(app.appId)\(type)\(app.appKey)"
        let body: [String : Any] = ["appId" : app.appId, "type" : type, "sign" : md5(string: signStr)]
        print(body);
        
        MyNetwork.current.post(app.serverUrl + "/api/user/token", ["Authorization" : "Basic " + b64Encode(username + ":" + password)!], body, {
            code, response in
            if code == 200 {
                // 注册成功
                print("登陆成功");
                let user = UserModel(token: (response["access_token"] as? String) ?? "")
                user.save()
                user.saveAsCurrentUser()
                success(user)
            } else if code == 404 {
                
                self.doRegist(username, password, "", type, {
                    print("注册成功");
                    self.doLogin(username, password, type, success, failure)
                    
                }, {
                    failure()
                    print("1失败");
                })
            } else {
                failure()
                print("2失败");
                print(code);
                print(response);
            }
        }, {
            failure()
            print("3失败");
        })
    }
    
    /*
    func hasEmail(_ result: @escaping () -> Void) {
        let app = AppModel()
        if !app.load() {
            failure()
            return
        }
        
        //MyNetwork.current.get(<#T##url: String##String#>, <#T##headers: [String : String]##[String : String]#>, <#T##success: (Int, [String : Any]) -> Void##(Int, [String : Any]) -> Void#>, <#T##failure: () -> Void##() -> Void#>)
    }
    
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
        
        MyNetwork.current.post(url: app.serverUrl + "/sdk/v2/auth/guest", json: req, success: { data in
            
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
            
            let signstr = "\(app.appId)\(deviceId())\(fbuserId)\(token)\(LoginType.FACEBOOK.rawValue)\(app.appKey)"
            
            let md5str = md5(string: signstr)
            
            let req: [String : Any] = [
                "appId": app.appId,
                "deviceId": deviceId(),
                "thirdUserId": fbuserId,
                "thirdAccessToken": token,
                "loginType": LoginType.FACEBOOK.rawValue,
                "sign": md5str
            ]
            
            MyNetwork.current.post(url: app.serverUrl + "/sdk/v2/auth/thirdparty", json: req, success: { data in
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
        
        let loginPassword = password
        
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
        
        MyNetwork.current.post(url: app.serverUrl + "/sdk/v2/auth/username", json: req, success: { data in
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
        
        MyNetwork.current.post(url: app.serverUrl + "/sdk/v2/auth/session", json: req, success: { data in
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
 */
    
    func doLogout() {
        let app = AppModel()
        if !app.load() {
            return
        }
        Facebook.current.logout()
        let user = UserModel()
        user.removeCurrentUser()
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
        
        MyNetwork.current.post(url: app.serverUrl + "/sdk/v2/auth/findpwd", json: req, success: { result in }, failure: {})
    }
}
