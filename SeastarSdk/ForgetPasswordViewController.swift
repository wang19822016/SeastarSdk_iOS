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
    
    
    @IBOutlet var adminTextField: UITextField!
    
    @IBOutlet var passwordGetBackBtn: UIButton!
    
    @IBOutlet var noticeLabel: UILabel!
    
    
    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func passwordGetBackClick(_ sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView();
    }

    func initView()
    {
        
    }
    

}

extension ForgetPasswordViewController:UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting);
    }
}
