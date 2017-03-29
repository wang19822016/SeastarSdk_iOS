//
//  MainPortraitViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/31.
//
//

import UIKit

class MainPortraitViewController: BaseViewController {
    
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var LoginTypeLabel: UILabel!
    
    @IBOutlet var GuestLabel: UILabel!
    
    @IBOutlet var SeastarLabel: UILabel!
    
    @IBOutlet var FacebookLabel: UILabel!
    
    override func initView() {
        
        makeBounds(backgroundImageView.layer);
        GuestLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        GuestLabel.text = NSLocalizedString("Guest", comment: "");
        SeastarLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        SeastarLabel.text = NSLocalizedString("Seastar", comment: "");
        FacebookLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        FacebookLabel.text = NSLocalizedString("Facebook", comment: "");
        LoginTypeLabel.textColor = UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1.0);
        LoginTypeLabel.text = NSLocalizedString("SelectLoginType", comment: "");
    }
    
    
    @IBAction func guestLogin(_ sender: AnyObject) {
        startCustomView();
        UserViewModel.current.doLoginAndRegistAndLogin(deviceId(), deviceId(), LoginType.GUEST.rawValue, { (userModel) in
            self.stopCustomView();
            self.loginSuccess(user: userModel);
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
    
    @IBAction func backButtonClick(_ sender: Any) {
        let vc = self.presentingViewController
        if(vc is ChangeAccountPortraitViewController){
            dismiss(animated: true, completion: nil);
        }else{
            loginFail()
        }
    }
    
}
