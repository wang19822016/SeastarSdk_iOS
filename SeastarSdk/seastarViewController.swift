//
//  seastarViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/24.
//
//

import UIKit

class seastarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //additional setup after loading the view.
    }

    @IBAction func guestLogin(_ sender: AnyObject) {
        let userviewmodel = UserViewModel();
        userviewmodel.doGuestLogin(success: { user in
            print("GuestLoginSuccess");
            
            }) { 
                print("GuestLoginFaile");
        }
        
        
    }

    
    @IBAction func facebookLogin(_ sender: AnyObject) {
        let userviewmodel = UserViewModel();
        userviewmodel.doFacebookLogin(viewController: self, success: { (_) in
            print("FacebookLoginSuccess");
            }) { 
                print("FacebookLoginFaile");
        }
        
    }


}
