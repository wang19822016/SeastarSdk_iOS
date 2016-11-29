//
//  ChangeAccountViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/11/4.
//
//

import UIKit

class ChangeAccountViewController: BaseViewController,ComboBoxDelegate {
    
//    let indView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray);
//    let customView = UIView();
    
    
    
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
        
//        customView.frame = view.frame;
//        customView.backgroundColor = UIColor.gray
//        customView.alpha = 0.3;
//        indView.center = customView.center;
        
        
        
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
