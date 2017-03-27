//
//  ChangeAccountViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/11/4.
//
//

import UIKit

class ChangeAccountViewController: BaseViewController,ComboBoxDelegate {
    
    
    @IBOutlet var comboBox: ComboBox!
    
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var changeBtn: UIButton!
    
    private var options: [UserModel] = []
    
    var ChangeAccountloginSuccess:((_ usermodel:UserModel)->Void)?
    
    var ChangeAccountloginFailure:(()->Void)?
    
    @IBAction func loginBtnClick(_ sender: AnyObject) {
        for option in options
        {
            let username = option.userName;
            let password = option.password;
            if username == comboBox.currentContentText{
                startCustomView();
                UserViewModel.current.doAccountLogin(username: username,
                                                     password: password,
                                                     email: "",
                                                     opType:LoginOPType.Login,
                                                     success:
                    { (myUserModel:UserModel) in
                        self.stopCustomView();
                        self.dismiss(animated: true, completion: {
                            self.ChangeAccountloginSuccess?(myUserModel);
                        })
                }, failure: { str in
                    self.stopCustomView();
                    hud(hudString: "LoginFalse", hudView: self.view);
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initView() {
        
        
        var optionsArray: [Any] = []
        options = UserModel.loadAllUsers()
        for user in options {
            if !user.guestUserId.isEmpty {
                let tuples = ("guest",user.userName);
                optionsArray.append(tuples);
            } else if !user.facebookUserId.isEmpty {
                let tuples = ("facebook",user.userName);
                optionsArray.append(tuples);
            } else {
                let tuples = ("seastar",user.userName);
                optionsArray.append(tuples);
            }
        }
        comboBox.editable = false //禁止编辑
        comboBox.showBorder = false //不显示边框
        comboBox.placeholder = NSLocalizedString("PleaseInputAccount", comment: "");
        comboBox.delegate = self //设置代理
        comboBox.options = optionsArray
        
        loginBtn.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal);
        loginBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
        let title = NSMutableAttributedString(string: NSLocalizedString("ChangeAccount", comment: ""));
        let titleRange = NSRange(location: 0,length: title.length);
        let num = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue);
        title.addAttribute(NSUnderlineStyleAttributeName, value: num, range: titleRange);
        changeBtn.setAttributedTitle(title, for: UIControlState.normal);
        changeBtn.setTitleColor(UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1), for: UIControlState.normal);
    }
    
    func selectOption(didChoose index: Int)
    {
        
    }
    func deleteOption(didChoose index: Int)
    {
        options.remove(at: index);
    }
    func comboBoxDidBeginEditing()
    {
        moveUp(comboBox.frame);
    }
    func comboBoxDidEndEditing()
    {
        moveDown();
    }
    
}
