//
//  LoginPortraitViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/31.
//
//

import UIKit

class LoginPortraitViewController: BaseViewController,ComboBoxDelegate,UITextFieldDelegate {
    
//    let indView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray);
//    let customView = UIView();
    
    @IBOutlet var backgroundImageVIew: UIImageView!
    
    @IBOutlet var comboBox: ComboBox!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var Loginbtn: UIButton!
    
    @IBOutlet var ForgetBtn: UIButton!
    
    @IBOutlet var registerBtn: UIButton!
    
    private var options: [UserModel] = []
    
//    func startCustomView()
//    {
//        view.addSubview(customView);
//        customView.addSubview(indView);
//        indView.startAnimating();
//    }
//    
//    func stopCustomView()
//    {
//        indView.stopAnimating();
//        indView.removeFromSuperview();
//        customView.removeFromSuperview();
//    }
    
    @IBAction func LoginBtnClick(_ sender: AnyObject) {
        if(seastarCompare(admin: comboBox.currentContentText) && seastarCompare(password: passwordTextField.text!)){
            startCustomView();
            UserViewModel.current.doAccountLogin(username: comboBox.currentContentText,
                                                 password: passwordTextField.text!,
                                                 email: "",
                                                 opType: LoginOPType.Login,
                                                 success:
                { (MyuserModel:UserModel) in
                    self.stopCustomView();
                    let MainVC = self.presentingViewController as! MainPortraitViewController;
                    let changeVC = MainVC.presentingViewController;
                    if(changeVC is ChangeAccountPortraitViewController){
                        let vc = MainVC.presentingViewController as! ChangeAccountPortraitViewController;
                        self.dismiss(animated: false, completion: {
                            MainVC.dismiss(animated: false, completion: {
                                changeVC?.dismiss(animated: false, completion: {
                                    vc.ChangeAccountloginSuccess?(MyuserModel);
                                })
                            })
                        })
                    }else{
                        self.dismiss(animated: false, completion: {
                            MainVC.dismiss(animated: false, completion: {
                                MainVC.LoginSuccess?(MyuserModel);
                            })
                        })
                    }
            }) { str in
                self.stopCustomView();
                var loginErrorStr:String;
                if(str == "60"){
                    loginErrorStr = "AccountDoesNotExist";
                }
                else if(str == "61"){
                    loginErrorStr = "AccountOrPasswordError";
                }
                else if(str == "63"){
                    loginErrorStr = "AccountDoesNotExist";
                }
                else if(str == "64"){
                    loginErrorStr = "YouHaveBeenBanned";
                }else{
                    loginErrorStr = "LoginFalse";
                }
                hud(hudString: loginErrorStr, hudView: self.view);
            }
        }else{
            if !seastarCompare(admin: comboBox.currentContentText){
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
//        customView.frame = view.frame;
//        customView.backgroundColor = UIColor.gray
//        customView.alpha = 0.3;
//        indView.center = customView.center;
        
        makeBounds(backgroundImageVIew.layer)
        
        var optionsArray: [String] = []
//        let frameworkBundle = Bundle(for: SeastarSdk.classForCoder())
//        let guestImg = UIImage(named: "guest.png", in: frameworkBundle, compatibleWith: nil)!
//        let facebookImg = UIImage(named: "facebook.png", in: frameworkBundle, compatibleWith: nil)!
//        let seastarImg = UIImage(named: "seastar.png", in: frameworkBundle, compatibleWith: nil)!
        options = UserModel.loadAllUsers()
        for user in options {
            if !user.guestUserId.isEmpty {
                optionsArray.append(user.userName)
            } else if !user.facebookUserId.isEmpty {
                optionsArray.append(user.userName)
            } else {
                optionsArray.append(user.userName)
            }
        }
        comboBox.editable = true //禁止编辑
        comboBox.showBorder = false //不显示边框
        comboBox.placeholder = NSLocalizedString("PleaseInputAccount", comment: "");
        comboBox.delegate = self //设置代理
        comboBox.options = optionsArray
        
        passwordTextField.delegate = self
        passwordTextField.placeholder = NSLocalizedString("PleaseInputPassword", comment: "");
        //        passwordTextField.setValue(UIColor(red: 176/255, green: 175/255, blue: 179/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        passwordTextField.delegate = self;
        
        Loginbtn.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal);
        Loginbtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
        let title = NSMutableAttributedString(string: NSLocalizedString("Forget", comment: ""));
        let titleRange = NSRange(location: 0,length: title.length);
        let num = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title.addAttribute(NSUnderlineStyleAttributeName, value: num, range: titleRange);
        ForgetBtn.setAttributedTitle(title, for: UIControlState.normal);
        ForgetBtn.setTitleColor(UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1), for: UIControlState.normal);
        
        let title1 = NSMutableAttributedString(string: NSLocalizedString("Register", comment: ""));
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
