//
//  LoginViewController.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var adminTextField: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var forgetPasswordBtn: UIButton!
    
    @IBOutlet var registerBtn: UIButton!
    
    private var options: [UserModel] = []
    
    @IBAction func loginBtnClick(_ sender: AnyObject) {
        if(seastarCompare(admin: adminTextField.text!) && seastarCompare(password: passwordTextField.text!)){
            startCustomView();
            UserViewModel.current.doLogin(adminTextField.text!, passwordTextField.text!, LoginType.ACCOUNT.rawValue, { (userModel) in
                self.stopCustomView();
                self.loginSuccess(user: userModel);
            }, {
                self.stopCustomView();
                hud(hudString: "AccountOrPasswordError", hudView: self.view);
            })
        }else{
            if !seastarCompare(admin: adminTextField.text!){
                hud(hudString: "PleaseEnterTheCorrectAdmin", hudView: self.view);
            }else{
                hud(hudString: "PleaseEnterTheCorrectPassword", hudView: self.view);
            }
        }
        
    }
    
    
    @IBAction func backBtnCkick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    override func initView()
    {
        makeBounds(backgroundImage.layer)
        adminTextField.delegate = self;
        adminTextField.placeholder = NSLocalizedString("PleaseInputAccount", comment: "");
        passwordTextField.delegate = self
        passwordTextField.placeholder = NSLocalizedString("PleaseInputPassword", comment: "");
        
        loginBtn.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal);
        loginBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
        let title = NSMutableAttributedString(string: NSLocalizedString("Forget", comment: ""));
        let titleRange = NSRange(location: 0,length: title.length);
        let num = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title.addAttribute(NSUnderlineStyleAttributeName, value: num, range: titleRange);
        forgetPasswordBtn.setAttributedTitle(title, for: UIControlState.normal);
        forgetPasswordBtn.setTitleColor(UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1), for: UIControlState.normal);
        
        let title1 = NSMutableAttributedString(string:NSLocalizedString("Register", comment: ""));
        let titleRange1 = NSRange(location: 0,length: title1.length);
        let num1 = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title1.addAttribute(NSUnderlineStyleAttributeName, value: num1, range: titleRange1);
        registerBtn.setAttributedTitle(title1, for: UIControlState.normal);
        registerBtn.setTitleColor(UIColor(red: 58/255, green: 140/255, blue: 224/255, alpha: 1), for: UIControlState.normal);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
