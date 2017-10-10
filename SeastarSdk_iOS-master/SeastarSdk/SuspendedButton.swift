//
//  SuspendedButton.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2017/9/30.
//
//

import UIKit

class SuspendedButton: UIButton {

    let kScreenWidth = UIScreen.main.bounds.size.width;
    let kScreenHeight = UIScreen.main.bounds.size.height;
    
    var currentPoint = CGPoint();
    var beginPoint = CGPoint();
    var alertView = UIView();
    var exist:Bool = false;
    var BtnEnabled:Bool = true;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //点击
        BtnEnabled = true;
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        if touch.tapCount == 1{
            super.touchesBegan(touches, with: event);
            let touch = ((touches as NSSet).anyObject() as AnyObject)
            beginPoint = touch.location(in: self);
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //移动
        BtnEnabled = false;
        beginPoint = self.bounds.origin;
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        currentPoint = touch.location(in: self);
        let offsetX = currentPoint.x - beginPoint.x;
        let offsetY = currentPoint.y - beginPoint.y;
        self.center = CGPoint(x: self.center.x + offsetX, y: self.center.y + offsetY);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if BtnEnabled{
            if exist {
                alertView.removeFromSuperview();
                exist = false;
            }else{
                alertView.frame = CGRect(x: 0, y: 0, width: 200, height: 200);
                alertView.center = (self.superview!.center);
                alertView.backgroundColor = UIColor.darkGray;
                alertView.alpha = 0.1;
                self.superview?.addSubview(alertView);
                exist = true;
                print(exist);
            }
        }else{
            super.touchesEnded(touches, with: event);
            let touch = ((touches as NSSet).anyObject() as AnyObject)
            if touch.tapCount == 0{
                if self.frame.origin.x >= kScreenHeight / 2{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.frame.origin.x = self.kScreenHeight - 50;
                    })
                }else{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.frame.origin.x = 0;
                    })
                }
            }
        }
    }
}
