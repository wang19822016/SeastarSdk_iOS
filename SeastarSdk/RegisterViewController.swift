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
    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBOutlet var adminTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    @IBAction func registerBtnClick(_ sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView();

    }

    func initView()
    {
        
    }
    


}

extension RegisterViewController:UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting);
    }
}
