//
//  MainLoginViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/25.
//
//

import UIKit


class MainLoginViewController: BaseViewController {
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var backGroundImage: UIImageView!
    
    @IBOutlet var loginTypeLabel: UILabel!
    
    @IBOutlet var guestLoginLabel: UILabel!
    
    @IBOutlet var seastarLoginLabel: UILabel!
    
    @IBOutlet var facebookLoginLabel: UILabel!
    
    override func initView()
    {
        makeBounds(backGroundImage.layer)
        
        guestLoginLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        guestLoginLabel.text = NSLocalizedString("Guest", comment: "");
        seastarLoginLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        seastarLoginLabel.text = NSLocalizedString("Seastar", comment: "");
        facebookLoginLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        facebookLoginLabel.text = NSLocalizedString("Facebook", comment: "");
        loginTypeLabel.textColor = UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1.0);
        loginTypeLabel.text = NSLocalizedString("SelectLoginType", comment: "");
    }
    
    @IBAction func guestLogin(_ sender: AnyObject) {
        startCustomView()
        UserViewModel.current.doLoginAndRegistAndLogin(deviceId(), deviceId(), LoginType.GUEST.rawValue, { (userModel) in
            self.stopCustomView();
            self.loginSuccess(user: userModel)
        }) {
            self.stopCustomView();
            hud(hudString: "LoginFalse", hudView: self.view);
        }
    }
    
    
    @IBAction func facebookLogin(_ sender: AnyObject) {
        startCustomView()
        
        Facebook.current.login(viewController: self, success: { (fbuserId, token) in
            UserViewModel.current.doLoginAndRegistAndLogin(fbuserId, token, LoginType.FACEBOOK.rawValue, { (userModel) in
                self.stopCustomView();
                self.loginSuccess(user: userModel);
            }, {
                self.stopCustomView();
                hud(hudString: "LoginFalse", hudView: self.view);
            })
        }) {
            self.stopCustomView();
            hud(hudString: "LoginFalse", hudView: self.view);
        }
    }
    @IBAction func dismissClick(_ sender: Any) {
        let vc = self.presentingViewController
        if(vc is ChangeAccountViewController){
            dismiss(animated: true, completion: nil);
        }else{
            loginFail()
        }
    }
}








