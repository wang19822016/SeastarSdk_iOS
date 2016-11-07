//
//  MainPortraitViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/31.
//
//

import UIKit

class MainPortraitViewController: BaseViewController {
    
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle:
        UIActivityIndicatorViewStyle.gray);
    
    
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var LoginTypeLabel: UILabel!
    
    @IBOutlet var GuestLabel: UILabel!
    
    @IBOutlet var SeastarLabel: UILabel!
    
    @IBOutlet var FacebookLabel: UILabel!
    
    var LoginSuccess:((_ usermodel:UserModel)->Void)?
    
    var LoginFailure:(()->Void)?
    
    
    
    override func initView() {
        
        indicatorView.center = view.center;
        view.addSubview(indicatorView);
        
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
        indicatorView.startAnimating();
        UserViewModel.current.doGuestLogin(success: { userModel in
            self.indicatorView.stopAnimating();
            let changeVC = self.presentingViewController;
            if(changeVC is ChangeAccountPortraitViewController){
                let vc = self.presentingViewController as! ChangeAccountPortraitViewController
                self.dismiss(animated: false, completion: {
                    changeVC?.dismiss(animated: false, completion: {
                        vc.ChangeAccountloginSuccess?(userModel);
                    })
                })
            }else{
                self.dismiss(animated: false, completion: {
                    self.LoginSuccess?(userModel);
                })
            }
            }, failure: {
                self.indicatorView.stopAnimating();
                hud(hudString: "LoginFalse", hudView: self.view);
        })
    }
    
    @IBAction func facebookLogin(_ sender: AnyObject) {
        self.indicatorView.startAnimating();
        UserViewModel.current.doFacebookLogin(viewController: self, success: { userModel in
            self.indicatorView.stopAnimating();
            let changeVC = self.presentingViewController;
            if(changeVC is ChangeAccountPortraitViewController){
                let vc = self.presentingViewController as! ChangeAccountPortraitViewController
                self.dismiss(animated: false, completion: {
                    changeVC?.dismiss(animated: false, completion: {
                        vc.ChangeAccountloginSuccess?(userModel);
                    })
                })
            }else{
                self.dismiss(animated: false, completion: {
                    self.LoginSuccess?(userModel);
                })
            }
            }, failure: {
                self.indicatorView.stopAnimating();
                hud(hudString: "LoginFalse", hudView: self.view);
        })
        
    }
    
}
