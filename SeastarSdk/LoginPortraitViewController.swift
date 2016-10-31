//
//  LoginPortraitViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/31.
//
//

import UIKit

class LoginPortraitViewController: BaseViewController {

    @IBOutlet var backgroundImageVIew: UIImageView!
    
    @IBOutlet var comboBox: ComboBox!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var Loginbtn: UIButton!
    
    @IBOutlet var ForgetBtn: UIButton!
    
    @IBOutlet var registerBtn: UIButton!
    
    private var options: [UserModel] = []
    

    @IBAction func LoginBtnClick(_ sender: AnyObject) {
        UserViewModel.current.doAccountLogin(username: comboBox.currentContentText,
                                             password: passwordTextField.text!,
                                             email: "",
                                             opType: LoginOPType.Login,
                                             success:
            { (MyuserModel:UserModel) in
                
                let MainVC = self.presentingViewController as! MainPortraitViewController;
                self.dismiss(animated: false, completion: {
                    MainVC.LoginSuccess?(MyuserModel)
                    MainVC.dismiss(animated: false, completion: nil);
                });
        }) {
            hud(hudString: "LoginFalse", hudView: self.view);
        }

        
    }

    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
}
