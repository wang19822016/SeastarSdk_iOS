//
//  Config.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation

// 常量定义
enum LoginType: Int {
    case ACCOUNT = 0
    case GUEST = 1
    case GOOGLE = 2
    case GAMECENTER = 3
    case FACEBOOK = 4
}

enum PayType: Int {
    case GOOGLE = 0
    case APPLE = 1
    case MYCARD = 2
}

enum LoginOPType: Int {
    case REGISTER = 1
    case Login = 0
}

enum UserStatus : Int {
    case DENY = 0
    case ALLOW = 1
}

enum UserNewOrOld : Int {
    case NEW = 1
    case OLD = 0
}

public enum Orientation
{
    case landscape
    case portrait
}
