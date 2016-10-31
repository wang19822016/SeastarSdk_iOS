//
//  LoginPortraitViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/31.
//
//

import UIKit

class LoginPortraitViewController: BaseViewController,ComboBoxDelegate,UITextFieldDelegate {

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
    
    override func initView()
    {
        makeBounds(backgroundImageVIew.layer)
        
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
        comboBox.editable = true //禁止编辑
        comboBox.showBorder = false //不显示边框
        comboBox.placeholder = "占位符号"
        //comboBax.delegate = self //设置代理
        comboBox.options = optionsArray
        
        passwordTextField.delegate = self
        passwordTextField.placeholder = NSLocalizedString("pleaseInputPassword", comment: "");
        
        passwordTextField.setValue(UIColor(red: 176/255, green: 175/255, blue: 179/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        
        Loginbtn.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal);
        Loginbtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
        let title = NSMutableAttributedString(string: NSLocalizedString("ForgetPassword", comment: ""));
        let titleRange = NSRange(location: 0,length: title.length);
        let num = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title.addAttribute(NSUnderlineStyleAttributeName, value: num, range: titleRange);
        ForgetBtn.setAttributedTitle(title, for: UIControlState.normal);
        ForgetBtn.setTitleColor(UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1), for: UIControlState.normal);
        
        let title1 = NSMutableAttributedString(string: NSLocalizedString("RegisterAccount", comment: ""));
        let titleRange1 = NSRange(location: 0,length: title.length);
        let num1 = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title1.addAttribute(NSUnderlineStyleAttributeName, value: num1, range: titleRange1);
        registerBtn.setAttributedTitle(title1, for: UIControlState.normal);
        registerBtn.setTitleColor(UIColor(red: 58/255, green: 140/255, blue: 224/255, alpha: 1), for: UIControlState.normal);
        
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
        moveUp(comboBox.frame)
    }
    
    func comboBoxDidEndEditing() {
        moveDown()
    }
}
