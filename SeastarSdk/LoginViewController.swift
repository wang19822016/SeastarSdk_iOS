//
//  LoginViewController.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import UIKit

class LoginViewController: BaseViewController, ComboBoxDelegate, UITextFieldDelegate {
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var forgetPasswordBtn: UIButton!
    
    @IBOutlet var registerBtn: UIButton!
    
    
    @IBOutlet var comboBax: ComboBox!
    
    private var options: [UserModel] = []
    
    @IBAction func loginBtnClick(_ sender: AnyObject) {

        UserViewModel.current.doAccountLogin(username: comboBax.currentContentText,
                                     password: passwordTextField.text!,
                                     email: "",
                                     opType: LoginOPType.Login,
                                     success:
            { (MyuserModel:UserModel) in
        
            let MainVC = self.presentingViewController as! MainLoginViewController;
            self.dismiss(animated: false, completion: {
                MainVC.loginSuccess?(MyuserModel)
                MainVC.dismiss(animated: false, completion: nil);
            });
            }) {
                hud(hudString: "LoginFalse", hudView: self.view);
        }
        
    }
    
    
    @IBAction func backBtnCkick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }

    override func initView()
    {
        makeBounds(backgroundImage.layer)
        
        var optionsArray: [(UIImage, String)] = []
        let frameworkBundle = Bundle(for: SeastarSdk.classForCoder())
        let guestImg = UIImage(named: "guest.png", in: frameworkBundle, compatibleWith: nil)!
        let facebookImg = UIImage(named: "facebook.png", in: frameworkBundle, compatibleWith: nil)!
        let seastarImg = UIImage(named: "seastar.png", in: frameworkBundle, compatibleWith: nil)!
        options = UserModel.loadAllUsers()
        for user in options {
            if !user.guestUserId.isEmpty {
                optionsArray.append((guestImg, user.userName))
            } else if !user.facebookUserId.isEmpty {
                optionsArray.append((facebookImg, user.userName))
            } else {
                optionsArray.append((seastarImg, user.userName))
            }
        }
        comboBax.editable = true //禁止编辑
        comboBax.showBorder = false //不显示边框
        comboBax.placeholder = "占位符号"
        //comboBax.delegate = self //设置代理
        comboBax.options = optionsArray
        
        passwordTextField.delegate = self
        passwordTextField.placeholder = NSLocalizedString("pleaseInputPassword", comment: "");

        passwordTextField.setValue(UIColor(red: 176/255, green: 175/255, blue: 179/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        
        loginBtn.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal);
        loginBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
        let title = NSMutableAttributedString(string: NSLocalizedString("ForgetPassword", comment: ""));
        let titleRange = NSRange(location: 0,length: title.length);
        let num = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title.addAttribute(NSUnderlineStyleAttributeName, value: num, range: titleRange);
        forgetPasswordBtn.setAttributedTitle(title, for: UIControlState.normal);
        forgetPasswordBtn.setTitleColor(UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1), for: UIControlState.normal);
        
        let title1 = NSMutableAttributedString(string: NSLocalizedString("RegisterAccount", comment: ""));
        let titleRange1 = NSRange(location: 0,length: title.length);
        let num1 = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title1.addAttribute(NSUnderlineStyleAttributeName, value: num1, range: titleRange1);
        registerBtn.setAttributedTitle(title1, for: UIControlState.normal);
        registerBtn.setTitleColor(UIColor(red: 58/255, green: 140/255, blue: 224/255, alpha: 1), for: UIControlState.normal);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectOption(didChoose index: Int) {
        //let currentSelectText = comboBax.currentContentText
    }
    
    func deleteOption(didChoose index: Int) {
        options.remove(at: index)
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

    func comboBoxDidBeginEditing() {
        moveUp(comboBax.frame)
    }
    
    func comboBoxDidEndEditing() {
        moveDown()
    }
}
