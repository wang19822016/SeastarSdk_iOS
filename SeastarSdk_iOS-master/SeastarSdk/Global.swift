//
//  Global.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2017/3/29.
//
//

import Foundation

class Global:NSObject{
    
    static let current = Global();
    var rootViewController: UIViewController? = nil
    var myOrientation:Bool = true
    var loginSuccess:((_ usermodel:UserModel)->Void)?
    var loginFailure:(()->Void)?
    
    
}
