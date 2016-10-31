//
//  RegisterPortraitViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/31.
//
//

import UIKit

class RegisterPortraitViewController: BaseViewController,UITextFieldDelegate {

    
    
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var adminTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    
    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func registerBtnClick(_ sender: AnyObject) {
        UserViewModel.current.doAccountLogin(username: adminTextField.text!, password: passwordTextField.text!, email: emailTextField.text!, opType: LoginOPType.REGISTER, success: { (Myusermodel:UserModel) in
            let LoginVC = self.presentingViewController as! LoginPortraitViewController;
            let MainVC = LoginVC.presentingViewController as! MainPortraitViewController;
            self.dismiss(animated: false, completion: {
                LoginVC.dismiss(animated: false, completion: {
                    MainVC.LoginSuccess?(Myusermodel);
                    MainVC.dismiss(animated: false, completion: nil);
                })
            })
        }) {
            hud(hudString: "RegsiterFalse", hudView: self.view);
        }
    }
    
    override func initView() {
        makeBounds(backgroundImageView.layer);
        adminTextField.placeholder = NSLocalizedString("PleaseInputSeastarAccount", comment: "");
        adminTextField.setValue(UIColor(red: 4/255, green: 66/255, blue: 81/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        adminTextField.delegate = self;
        
        passwordTextField.placeholder = NSLocalizedString("PleaseInputPassword", comment: "");
        passwordTextField.setValue(UIColor(red: 176/255, green: 175/255, blue: 179/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        passwordTextField.delegate = self;
        
        emailTextField.placeholder = NSLocalizedString("PleaseInputEmail(Option)", comment: "");
        emailTextField.setValue(UIColor(red: 176/255, green: 175/255, blue: 179/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        emailTextField.delegate = self;
        
        registerBtn.setTitle(NSLocalizedString("Register", comment: ""), for: UIControlState.normal);
        registerBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveUp(textField.frame)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveDown()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
