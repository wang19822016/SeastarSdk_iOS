//
//  ForgetPasswordViewController.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 16/10/26.
//
//

import UIKit

class ForgetPasswordViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var adminTextField: UITextField!
    
    @IBOutlet var passwordGetBackBtn: UIButton!
    
    @IBOutlet var noticeLabel: UILabel!
    
    
    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func passwordGetBackClick(_ sender: AnyObject) {
        if seastarCompare(admin: adminTextField.text!) {
            UserViewModel.current.findPwd(self.adminTextField.text!, {(int)->(Void) in
                print(int)
                if int == 200{
                    hud(hudString: "FindSuccess", hudView: self.view);
                }else{
                    hud(hudString: "Findfalse", hudView: self.view);
                }
            });
        }else{
            hud(hudString: "PleaseEnterTheCorrectAdmin", hudView: self.view);
        }
    }
    
    override func initView()
    {
        makeBounds(backgroundImage.layer)
        
        adminTextField.placeholder = NSLocalizedString("PleaseInputAccount", comment: "");
        //        adminTextField.setValue(UIColor(red: 4/255, green: 66/255, blue: 81/255, alpha: 1), forKeyPath: "placeholderLabel.textColor");
        adminTextField.delegate = self;
        
        passwordGetBackBtn.setTitle(NSLocalizedString("FindPassword", comment: ""), for: UIControlState.normal);
        passwordGetBackBtn.setTitleColor(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1), for: UIControlState.normal);
        
        noticeLabel.text = NSLocalizedString("NoticeLabel", comment: "")
        //        "密码将被发送到该账户注册时绑定的邮箱,如有疑问请联系客服信箱:vrseastar@vrseastar.com";
        noticeLabel.textColor = UIColor(red: 107/255, green: 112/255, blue: 118/255, alpha: 1);
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

