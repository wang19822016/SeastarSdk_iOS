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
    
    
//    @IBOutlet var comboBax: ComboBox!
    
    private var options: [UserModel] = []
    
    @IBAction func loginBtnClick(_ sender: AnyObject) {
        if(seastarCompare(admin: adminTextField.text!) && seastarCompare(password: passwordTextField.text!)){
            startCustomView();
            let passwordMD5 = md5(string: passwordTextField.text!);
            UserViewModel.current.doAccountLogin(username: adminTextField.text!,
                                                 password: passwordMD5,
                                                 email: "",
                                                 opType: LoginOPType.Login,
                                                 success:
                { (MyuserModel:UserModel) in
                    self.stopCustomView();
                    let MainVC = self.presentingViewController as! MainLoginViewController;
                    let changeVC = MainVC.presentingViewController;
                    if(changeVC is ChangeAccountViewController){
                        let vc = MainVC.presentingViewController as! ChangeAccountViewController;
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
                                MainVC.loginSuccess?(MyuserModel);
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
        
//        var optionsArray: [String] = []
//        options = UserModel.loadAllUsers()
//        for user in options {
//            if !user.guestUserId.isEmpty {
//                optionsArray.append(user.userName)
//            } else if !user.facebookUserId.isEmpty {
//                optionsArray.append(user.userName)
//            } else {
//                optionsArray.append(user.userName)
//            }
//        }
//        comboBax.editable = true //禁止编辑
//        comboBax.showBorder = false //不显示边框
//        comboBax.placeholder = NSLocalizedString("PleaseInputAccount", comment: "");
//        comboBax.delegate = self //设置代理
//        comboBax.options = optionsArray;
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
        // Dispose of any resources that can be recreated.
    }
    
//    func selectOption(didChoose index: Int) {
//        //let currentSelectText = comboBax.currentContentText
//    }
//    
//    func deleteOption(didChoose index: Int) {
//        options.remove(at: index)
//    }
    
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
    
//    func comboBoxDidBeginEditing() {
//        self.moveUp(self.comboBax.frame)
//    }
//    
//    func comboBoxDidEndEditing() {
//        moveDown()
//    }
}
