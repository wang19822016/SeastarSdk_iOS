//
//  MainPortraitViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/31.
//
//

import UIKit

class MainPortraitViewController: BaseViewController {

    
    
    
    @IBOutlet var backgroundImageView: UIImageView!

    @IBOutlet var LoginTypeLabel: UILabel!
    
    @IBOutlet var GuestLabel: UILabel!
    
    @IBOutlet var SeastarLabel: UILabel!
    
    @IBOutlet var FacebookLabel: UILabel!
    
    var LoginSuccess:((_ usermodel:UserModel)->Void)?
    
    var LoginFailure:(()->Void)?
    
    
    
    override func initView() {
        makeBounds(backgroundImageView.layer);
        GuestLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        GuestLabel.text = NSLocalizedString("Guest", comment: "");
        SeastarLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        SeastarLabel.text = NSLocalizedString("SeastarLogin", comment: "");
        FacebookLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        FacebookLabel.text = NSLocalizedString("Facebook", comment: "");
        LoginTypeLabel.textColor = UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1.0);
    }
    
    
    @IBAction func guestLogin(_ sender: AnyObject) {
        UserViewModel.current.doGuestLogin(success: { userModel in
            self.dismiss(animated: true) {
                self.LoginSuccess?(userModel)
            }
            }, failure: {
                hud(hudString: "LoginFalse", hudView: self.view);
        })
    }

    @IBAction func facebookLogin(_ sender: AnyObject) {
        UserViewModel.current.doFacebookLogin(viewController: self, success: { userModel in
            self.dismiss(animated: true)
            {
                self.LoginSuccess?(userModel)
            }
            }, failure: {
                hud(hudString: "LoginFalse", hudView: self.view);
        })

    }

}
