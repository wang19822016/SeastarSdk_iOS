//
//  BaseViewController.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/10/31.
//
//

import UIKit

class BaseViewController: UIViewController {
    
    private var isUped: Bool = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = UIModalPresentationStyle.custom;
        transitioningDelegate = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        modalPresentationStyle = UIModalPresentationStyle.custom;
        transitioningDelegate = self;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    func initView() {
        
    }
    
    func makeBounds(_ layer: CALayer) {
        layer.cornerRadius = 4;
        layer.masksToBounds = true;
    }
    
    func moveUp(_ frame: CGRect) {
        let keyboardHeight: CGFloat = 216.0 + 35.0 //键盘高度216 键盘上tabbar35
        let keyboardY: CGFloat = self.view.frame.height - keyboardHeight
        let viewDownEdgeY = frame.origin.x + frame.size.height
        let offset = viewDownEdgeY - keyboardY
        UIView.beginAnimations("Resize", context: nil)
        UIView.setAnimationDuration(0.30)
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        if offset > 0 {
            let rect = CGRect(x: 0, y: -offset, width: width, height: height)
            self.view.frame = rect
        }
        UIView.commitAnimations()
        
        isUped = true
    }
    
    // 传入要移动控件的frame
    func moveDown() {
        UIView.beginAnimations("resize", context: nil)
        UIView.setAnimationDuration(0.30)
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.frame = rect
        UIView.commitAnimations()
        
        isUped = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if isUped {
            UIView.beginAnimations("resize", context: nil)
            UIView.setAnimationDuration(0.30)
            let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.frame = rect
            UIView.commitAnimations()
        }
        
        isUped = false
    }
}

extension BaseViewController:UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting);
    }
}
