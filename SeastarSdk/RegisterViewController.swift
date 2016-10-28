//
//  RegisterViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/26.
//
//

import UIKit

class RegisterViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        modalPresentationStyle = UIModalPresentationStyle.custom;
        transitioningDelegate = self;
        
    }
    
     let userViewModel = UserViewModel();
    
    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var adminTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    @IBAction func registerBtnClick(_ sender: AnyObject) {
        userViewModel.doAccountLogin(username: adminTextField.text!, password: passwordTextField.text!, email: emailTextField.text!, opType: LoginOPType.REGISTER, success: { (Myusermodel:UserModel) in
            let LoginVC = self.presentingViewController as! LoginViewController;
            let MainVC = LoginVC.presentingViewController as! MainLoginViewController;
            self.dismiss(animated: false, completion: { 
                LoginVC.dismiss(animated: false, completion: {
                    MainVC.loginBack!(Myusermodel);
                    MainVC.dismiss(animated: false, completion: nil);
                })
            })
            }) { 
                print("");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView();

    }

    func initView()
    {
        backgroundImage.layer.cornerRadius = 4;
        backgroundImage.layer.masksToBounds = true;
        
        
        adminTextField.placeholder = "请输入海星帐号";
        adminTextField.setValue(UIColor(red: 4/255, green: 66/255, blue: 81/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        passwordTextField.placeholder = "请输入登录密码";
        passwordTextField.setValue(UIColor(red: 176/255, green: 175/255, blue: 179/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        emailTextField.placeholder = "请输入邮箱(可选)";
        emailTextField.setValue(UIColor(red: 176/255, green: 175/255, blue: 179/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        
        registerBtn.setTitle("注册", for: UIControlState.normal);
        registerBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
    }
    


}

extension RegisterViewController:UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting);
    }
}
