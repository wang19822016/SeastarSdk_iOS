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
    var shareSuccess:((Bool)->Void)?
    var findSuccess:((Bool)->Void)?
    
    var contentURL:String = String();
    var contentTitle:String = String();
    var imageURL:String = String();
    var contentDescription:String = String();
    var bindUrl:String = String();
    var mainPageUrl:String = String();
}
