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
    
    var userId: Int = 0
    var userName: String = ""
    var password: String = ""
    var email: String = ""
    var status: Int = UserStatus.ALLOW.rawValue
    
    var session: String = ""
    
    var facebookUserId: String = ""
    var guestUserId: String = ""
    var gamecenterUserId: String = ""
    
    var isNewUser: Int = UserNewOrOld.OLD.rawValue
    
    mutating func load(userId: Int) -> Bool {
        let userList = UserDefaults.standard.array(forKey: USER_LIST_NAME) ?? []
        for user in userList {
            if let userDict = user as? [String : Any], let saveUserId = userDict["userId"] as? Int, saveUserId == userId {
                self.userId = (userDict["userId"] as? Int) ?? 0
                self.userName = (userDict["userName"] as? String) ?? ""
                self.password = (userDict["password"] as? String) ?? ""
                self.email = (userDict["email"] as? String) ?? ""
                self.status = (userDict["status"] as? Int) ?? UserStatus.ALLOW.rawValue
                
                self.session = (userDict["session"] as? String) ?? ""
                
                self.facebookUserId = (userDict["facebookUserId"] as? String) ?? ""
                self.guestUserId = (userDict["guestUserId"] as? String) ?? ""
                self.gamecenterUserId = (userDict["gamecenterUserId"] as? String) ?? ""
                
                return true
            }
        }

        return false
    }
    
    func save() {
        // 获取用户列表词典并更新用户信息
        var userList = UserDefaults.standard.array(forKey: USER_LIST_NAME) ?? []
        for (index, user) in userList.enumerated() {
            if let userDictConst = user as? [String : Any] {
                var userDict = userDictConst
                if let saveUserId = userDict["userId"] as? Int, saveUserId == userId {
                    userDict["userId"] = userId
                    userDict["userName"] = userName
                    userDict["password"] = password
                    userDict["email"] = email
                    userDict["status"] = status
                    
                    userDict["session"] = session
                    
                    userDict["facebookUserId"] = facebookUserId
                    userDict["guestUserId"] = guestUserId
                    userDict["gamecenterUserId"] = gamecenterUserId
                    
                    userList[index] = userDict
                    
                    UserDefaults.standard.set(userList, forKey: USER_LIST_NAME)
                    UserDefaults.standard.synchronize()
                    break
                }
            }
        }
    }
    
    func saveAsCurrentUser() {
        // 更新当前登录用户
        var currentUser = UserDefaults.standard.dictionary(forKey: CURRENT_USER_NAME) ?? [:]
        currentUser["userId"] = userId
        currentUser["userName"] = userName
        currentUser["session"] = session
        UserDefaults.standard.set(currentUser, forKey: CURRENT_USER_NAME)
        
        UserDefaults.standard.synchronize()
    }
    
    mutating func loadCurrentUser() -> Bool {
        if let currentUser = UserDefaults.standard.dictionary(forKey: CURRENT_USER_NAME), let userId = currentUser["userId"] as? Int {
            let userList = UserDefaults.standard.array(forKey: USER_LIST_NAME) ?? []
            for user in userList {
                if let userDict = user as? [String : Any], let saveUserId = userDict["userId"] as? Int, saveUserId == userId {
                    self.userId = (userDict["userId"] as? Int) ?? 0
                    self.userName = (userDict["userName"] as? String) ?? ""
                    self.password = (userDict["password"] as? String) ?? ""
                    self.email = (userDict["email"] as? String) ?? ""
                    self.status = (userDict["status"] as? Int) ?? UserStatus.ALLOW.rawValue
                    
                    self.session = (userDict["session"] as? String) ?? ""
                    
                    self.facebookUserId = (userDict["facebookUserId"] as? String) ?? ""
                    self.guestUserId = (userDict["guestUserId"] as? String) ?? ""
                    self.gamecenterUserId = (userDict["gamecenterUserId"] as? String) ?? ""
                    
                    return true
                }
            }
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
        
        var currentUserId: Int = -1
        if let currentUser = UserDefaults.standard.dictionary(forKey: "current_user"), let userId = currentUser["userId"] as? Int {
            currentUserId = userId
        }
        
        if let users = UserDefaults.standard.array(forKey: "users") {
            for index in 0..<users.count {
                if let userDict = users[index] as? [String : Any] {
                    var user = UserModel()
                    user.userId = (userDict["userId"] as? Int) ?? 0
                    user.userName = (userDict["userName"] as? String) ?? ""
                    user.password = (userDict["password"] as? String) ?? ""
                    user.email = (userDict["email"] as? String) ?? ""
                    user.status = (userDict["status"] as? Int) ?? UserStatus.ALLOW.rawValue
                    
                    user.session = (userDict["session"] as? String) ?? ""
                    
                    user.facebookUserId = (userDict["facebookUserId"] as? String) ?? ""
                    user.guestUserId = (userDict["guestUserId"] as? String) ?? ""
                    user.gamecenterUserId = (userDict["gamecenterUserId"] as? String) ?? ""
                    
                    if user.userId == currentUserId {
                        // 默认登录的账号放倒第一个位置
                        list.insert(user, at: 0)
                    } else {
                        list.append(user)
                    }
                }
                
            }
        }
        
        return list
    }
}
