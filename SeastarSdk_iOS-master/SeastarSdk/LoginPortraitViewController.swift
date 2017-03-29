//
//  LoginPortraitViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/31.
//
//

import UIKit

class LoginPortraitViewController: BaseViewController,UITextFieldDelegate {
    
    
    
    
    @IBOutlet var backgroundImageVIew: UIImageView!
    
    //    @IBOutlet var comboBox: ComboBox!
    
    @IBOutlet var adminTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var Loginbtn: UIButton!
    
    @IBOutlet var ForgetBtn: UIButton!
    
    @IBOutlet var registerBtn: UIButton!
    
    private var options: [UserModel] = []
    
    
    @IBAction func LoginBtnClick(_ sender: AnyObject) {
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
    
    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    override func initView()
    {
        makeBounds(backgroundImageVIew.layer)

        adminTextField.delegate = self;
        adminTextField.placeholder = NSLocalizedString("PleaseInputAccount", comment: "");
        passwordTextField.delegate = self
        passwordTextField.placeholder = NSLocalizedString("PleaseInputPassword", comment: "");
        //        passwordTextField.setValue(UIColor(red: 176/255, green: 175/255, blue: 179/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        
        Loginbtn.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal);
        Loginbtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
        let forgettitle = NSMutableAttributedString(string: NSLocalizedString("Forget", comment: ""));
        let forgettitleRange = NSRange(location: 0,length: forgettitle.length);
        let forgetnum = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        forgettitle.addAttribute(NSUnderlineStyleAttributeName, value: forgetnum, range: forgettitleRange);
        ForgetBtn.setAttributedTitle(forgettitle, for: UIControlState.normal);
        ForgetBtn.setTitleColor(UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1), for: UIControlState.normal);
        
        let registertitle = NSMutableAttributedString(string: NSLocalizedString("Register", comment: ""));
        let registertitleRange = NSRange(location: 0,length: registertitle.length);
        let registernum = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        registertitle.addAttribute(NSUnderlineStyleAttributeName, value: registernum, range: registertitleRange);
        registerBtn.setAttributedTitle(registertitle, for: UIControlState.normal);
        registerBtn.setTitleColor(UIColor(red: 58/255, green: 140/255, blue: 224/255, alpha: 1), for: UIControlState.normal);
        
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
