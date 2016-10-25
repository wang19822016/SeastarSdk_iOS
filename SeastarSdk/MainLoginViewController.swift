//
//  MainLoginViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/25.
//
//

import UIKit

class MainLoginViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        modalPresentationStyle = UIModalPresentationStyle.custom;
        transitioningDelegate = self;
    }
    
    
    
    @IBOutlet var backGroundImage: UIImageView!
    
    @IBOutlet var loginTypeLabel: UILabel!
    
    @IBOutlet var guestLoginLabel: UILabel!
    
    @IBOutlet var seastarLoginLabel: UILabel!
    
    @IBOutlet var facebookLoginLabel: UILabel!
    
    let userViewModel = UserViewModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundImage.layer.cornerRadius = 4;
        backGroundImage.layer.masksToBounds = true;
        
        guestLoginLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        seastarLoginLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);
        facebookLoginLabel.textColor = UIColor(red: 64/255, green: 66/255, blue: 81/255, alpha: 1.0);

        
        loginTypeLabel.textColor = UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1.0);
        
        
        
    }

    
    @IBAction func guestLogin(_ sender: AnyObject) {
        userViewModel.doGuestLogin(success: { (userModel:UserModel) in
            print("");
            }) { 
                print("");
        }
    }

    @IBAction func facebookLogin(_ sender: AnyObject) {
        userViewModel.doFacebookLogin(viewController: self, success: { (userModel:UserModel) in
            print("");
            }) { 
                print("");
        }
    }
    
}

extension MainLoginViewController:UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting);
    }
}








