//
//  UserViewModel.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation

class UserViewModel {
    
    func doGuestLogin() {
        NetHandler.doGuestLogin()
    }
    
    func doFacebookLogin(viewController: UIViewController) {
        Facebook.current.login(viewController: viewController, success: {(userId, token) in
            
            
            }, failure: {
        
        })
    }
    
    func doLogout() {
        
    }
}
