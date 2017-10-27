//
//  User.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation

struct UserModel {
    private let USER_LIST_NAME = "users"
    private let CURRENT_USER_NAME = "current_user"
    
    var token: String = ""
    
    var userId: Int64 = 0
    var userName: String = ""
    var loginType: Int = 0
    var expire: Int64 = 0
    
    init() {}
    
    init(token: String) {
        self.token = token
        
        var tokenArr = self.token.components(separatedBy: ".")
        if tokenArr.count == 3 {
            let jwtPayload: String? = b64UrlDecode(tokenArr[1]);
            if let data = jwtPayload?.data(using: .utf8) {
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let json = json as? [String : Any] {
                    userId = (json["userId"] as AnyObject? as? Int64) ?? 0
                    userName = (json["username"] as AnyObject? as? String) ?? ""
                    loginType = (json["loginType"] as AnyObject? as? Int) ?? 0
                    expire = (json["exp"] as AnyObject? as? Int64) ?? 0
                }
            }
        }
    }
    
    func save() {
        // 获取用户列表词典并更新用户信息
        var userList = UserDefaults.standard.array(forKey: USER_LIST_NAME) ?? []
        var userDictionary: [String : Any] = [:]
        for (index, user) in userList.enumerated() {
            if let userDict = user as? [String : Any], let saveUserId = userDict["userId"] as? Int64, saveUserId == userId {
                userList.remove(at: index)
                break;
            }
        }
        
        userDictionary["userId"] = userId
        userDictionary["userName"] = userName
        userDictionary["loginType"] = loginType
        userDictionary["expire"] = expire
        userDictionary["token"] = token
    
        userList.append(userDictionary)
        
        UserDefaults.standard.set(userList, forKey: USER_LIST_NAME)
        UserDefaults.standard.synchronize()

    }
    
    func remove() {
        // 获取用户列表词典并更新用户信息
        var userList = UserDefaults.standard.array(forKey: USER_LIST_NAME) ?? []
        for (index, user) in userList.enumerated() {
            if let userDict = user as? [String : Any], let saveUserId = userDict["userId"] as? Int64, saveUserId == userId {
                userList.remove(at: index)
                break;
            }
        }
        
        UserDefaults.standard.set(userList, forKey: USER_LIST_NAME)
        UserDefaults.standard.synchronize()
    }
    
    func saveAsCurrentUser() {
        // 更新当前登录用户
        var currentUser = UserDefaults.standard.dictionary(forKey: CURRENT_USER_NAME) ?? [:]
        currentUser["userId"] = userId
        currentUser["userName"] = userName
        currentUser["token"] = token
        currentUser["loginType"] = loginType
        currentUser["expire"] = expire
        UserDefaults.standard.set(currentUser, forKey: CURRENT_USER_NAME)
        
        UserDefaults.standard.synchronize()
    }
    
    mutating func loadCurrentUser() -> Bool {
        if let currentUser = UserDefaults.standard.dictionary(forKey: CURRENT_USER_NAME) {
            self.userId = (currentUser["userId"] as? Int64) ?? 0
            self.userName = (currentUser["userName"] as? String) ?? ""
            self.loginType = (currentUser["loginType"] as? Int) ?? 0
            self.expire = (currentUser["expire"] as? Int64) ?? 0
            self.token = (currentUser["token"] as? String) ?? ""
            
            return true
        }
        
        return false
    }
    
    func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: CURRENT_USER_NAME)
        UserDefaults.standard.synchronize()
    }
    
    // 默认登录帐号在第一个
    static func loadAllUsers() -> [UserModel] {
        var list: [UserModel] = []
        
        var currentUserId: Int64 = -1
        if let currentUser = UserDefaults.standard.dictionary(forKey: "current_user"), let userId = currentUser["userId"] as? Int64 {
            currentUserId = userId
        }
        
        if let users = UserDefaults.standard.array(forKey: "users") {
            for index in 0..<users.count {
                if let userDict = users[index] as? [String : Any] {
                    var user = UserModel()
                    user.userId = (userDict["userId"] as? Int64) ?? 0
                    user.userName = (userDict["userName"] as? String) ?? ""
                    user.loginType = (userDict["loginType"] as? Int) ?? 0
                    user.expire = (userDict["expire"] as? Int64) ?? 0
                    user.token = (userDict["token"] as? String) ?? ""
                    
                    if user.userId == currentUserId {
                        // 默认登录的账号放倒第一个位置
                        list.insert(user, at: 0)
                    } else {
                        list.append(user)
                    }
                }
                
            }
        }
        /*
        var list: [UserModel] = []
        
        if let users = UserDefaults.standard.array(forKey: "users") {
            for index in 0..<users.count {
                if let userDict = users[index] as? [String : Any] {
                    var user = UserModel()
                    user.userId = (userDict["userId"] as? Int64) ?? 0
                    user.userName = (userDict["userName"] as? String) ?? ""
                    user.loginType = (userDict["loginType"] as? Int) ?? 0
                    user.expire = (userDict["expire"] as? Int64) ?? 0
                    user.token = (userDict["token"] as? String) ?? ""
                    
                    list.append(user)
                }
            }
        }*/
        return list
    }
    
    static func clearExpire() {
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int64(timeInterval) + Int64(7 * 24 * 60 * 60)
        
        var currentUserId: Int64 = 0
        if let currentUser = UserDefaults.standard.dictionary(forKey: "current_user") {
            currentUserId = (currentUser["userId"] as? Int64) ?? 0
        }

        var listTmp: [Any] = []
        if let users = UserDefaults.standard.array(forKey: "users") {
            for index in 0..<users.count {
                if let userDict = users[index] as? [String : Any] {
                    let expire = (userDict["expire"] as? Int64) ?? 0
                    let userId = (userDict["userId"] as? Int64) ?? 0
                    if timeStamp <= expire {
                        listTmp.append(users[index])
                    } else {
                        if userId == currentUserId {
                            UserDefaults.standard.removeObject(forKey: "current_user")
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
            }
            
            if listTmp.count > 0 {
                UserDefaults.standard.set(listTmp, forKey: "users")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: "users")
                UserDefaults.standard.synchronize()
            }
        }
    }
}
