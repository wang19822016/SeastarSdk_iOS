//
//  MainLoginViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/25.
//
//

import UIKit


class MainLoginViewController: BaseViewController {
    
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle:
        UIActivityIndicatorViewStyle.gray);
    
    @IBOutlet var backGroundImage: UIImageView!
    
    @IBOutlet var loginTypeLabel: UILabel!
    
    @IBOutlet var guestLoginLabel: UILabel!
    
    @IBOutlet var seastarLoginLabel: UILabel!
    
    @IBOutlet var facebookLoginLabel: UILabel!
    
    var loginSuccess:((_ usermodel:UserModel)->Void)?
    
    var loginFailure:(()->Void)?
    
    override func initView()
    {
        indicatorView.center = view.center;
        view.addSubview(indicatorView);

        
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
        indicatorView.startAnimating();
        UserViewModel.current.doGuestLogin(success: { userModel in
            self.indicatorView.stopAnimating();
            self.dismiss(animated: true) {
                self.loginSuccess?(userModel)
            }
            }, failure: {
                self.indicatorView.stopAnimating();
                hud(hudString: "LoginFalse", hudView: self.view);
        })
    }
    
    
    @IBAction func facebookLogin(_ sender: AnyObject) {
        UserViewModel.current.doFacebookLogin(viewController: self, success: { userModel in
            self.dismiss(animated: true)
            {
                self.loginSuccess?(userModel)
            }
            }, failure: {
                hud(hudString: "LoginFalse", hudView: self.view);
        })
        
    }
    
}








