//
//  ForgetPasswordViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/26.
//
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        modalPresentationStyle = UIModalPresentationStyle.custom;
        transitioningDelegate = self;
    }
    let userViewModel = UserViewModel();
    let mbHUD = MBProgressHUD();
    
    
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var adminTextField: UITextField!
    
    @IBOutlet var passwordGetBackBtn: UIButton!
    
    @IBOutlet var noticeLabel: UILabel!
    
    
    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func passwordGetBackClick(_ sender: AnyObject) {
        let userviewmodel = UserViewModel();
        userviewmodel.findPwd(adminTextField.text!);
        hud(hudString: "FindSuccess", hudView: view);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView();
    }

    func initView()
    {
        backgroundImage.layer.cornerRadius = 4;
        backgroundImage.layer.masksToBounds = true;
        
        adminTextField.placeholder = NSLocalizedString("please input account", comment: "");
        adminTextField.setValue(UIColor(red: 4/255, green: 66/255, blue: 81/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        
        passwordGetBackBtn.setTitle(NSLocalizedString("find password", comment: ""), for: UIControlState.normal);
        passwordGetBackBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
        noticeLabel.text = NSLocalizedString("notice label", comment: "")
//        "密码将被发送到该账户注册时绑定的邮箱,如有疑问请联系客服信箱:vrseastar@vrseastar.com";
        noticeLabel.textColor = UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1);
    }
    

}

extension ForgetPasswordViewController:UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting);
    }
}
