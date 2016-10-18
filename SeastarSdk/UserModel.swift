//
//  User.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation

struct UserModel {
    var userId: Int64 = 0
    var userName: String = ""
    var password: String = ""
    var email: String = ""
    var status: Int = 0
    
    var facebookUserId: String = ""
    var guestUserId: String = ""
    var googleUserId: String = ""
    var gamecenterUserId: String = ""
    
    var deviceId: String = ""
    var locale: String = ""
    
    var appId: Int = 0
}
