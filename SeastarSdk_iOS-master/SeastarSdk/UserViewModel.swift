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
        
        let signStr = "\(app.appId)\(type)\(email)\(app.appKey)"
        let body: [String : Any] = ["appId" : app.appId, "email" : email, "type" : type, "sign" : md5(string: signStr)]
        print(signStr);

        MyNetwork.current.post(app.serverUrl + "/api/user", ["Authorization" : "Basic " + b64Encode(username + ":" + password)!], body, {
            code, response in
            if code == 201 {
                // 注册成功
                success()
            } else {
                failure()
            }
        }, {
            failure()
        })
    }
    
    func doLogin(_ username: String, _ password: String, _ type: Int, _ success: @escaping(UserModel)->Void, _ failure: @escaping ()->Void) {
        let app = AppModel()
        
        let signStr = "\(app.appId)\(type)\(app.appKey)"
        let body: [String : Any] = ["appId" : app.appId, "type" : type, "sign" : md5(string: signStr)]
        
        MyNetwork.current.post(app.serverUrl + "/api/user/token", ["Authorization" : "Basic " + b64Encode(username + ":" + password)!], body, {
            code, response in
            if code == 200 {
                // 注册成功
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
        
        let signStr = "\(app.appId)\(type)\(app.appKey)"
        let body: [String : Any] = ["appId" : app.appId, "type" : type, "sign" : md5(string: signStr)]
        print(body);
        
        MyNetwork.current.post(app.serverUrl + "/api/user/token", ["Authorization" : "Basic " + b64Encode(username + ":" + password)!], body, {
            code, response in
            if code == 200 {
                // 注册成功
                let user = UserModel(token: (response["access_token"] as? String) ?? "")
                user.save()
                user.saveAsCurrentUser()
                success(user)
            } else if code == 404 {
                self.doRegist(username, password, "", type, {
                    self.doLogin(username, password, type, success, failure)
                }, {
                    failure()
                })
            } else {
                failure()
            }
        }, {
            failure()
        })
    }
    
    
    func doLogout() {
        Facebook.current.logout()
        let user = UserModel()
        user.removeCurrentUser()
    }
    
    func findPwd(_ username: String) {
        let app = AppModel()
        let signStr = "\(app.appId)\(username)\(app.appKey)"
        let md5Str = md5(string: signStr)
        let url = "\(app.serverUrl)/api/user/pwd?username=\(username)&appId=\(app.appId)&sign=\(md5Str)"
        
        MyNetwork.current.get(url, [:], {code, response in}, {})
    }
    
    func hasEmail(_ success: @escaping ()->Void, _ failure: @escaping ()->Void) {
        var user = UserModel()
        if !user.loadCurrentUser() {
            success()
            return
        }
        
        let app = AppModel()
        
        MyNetwork.current.get(app.serverUrl + "/api/user", ["Authorization" : "Bearer " + user.token], { code, json in
            if code == 200 {
                if let email = json["email"] as? String {
                    if !email.isEmpty {
                        success()
                    } else {
                        failure()
                    }
                } else {
                    success()
                }
            }
        }, {
            success()
        })
    }
    
    func updateEmail(_ email:String) {
        var user = UserModel()
        if !user.loadCurrentUser() {
            return
        }
        
        let app = AppModel()
        
        MyNetwork.current.put(app.serverUrl + "/api/user", ["Authorization" : "Bearer " + user.token], ["email" : email], { code, json in
                    }, {})
    }
}
