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
    var eventBtn = EventButton(type: .custom);
    var eventTitle = UILabel();
    var alertView = UIView();
    var exist:Bool = false;
    var BtnEnabled:Bool = true;
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //点击
        alpha = 1.0;
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
        alpha = 1.0;
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
            super.touchesEnded(touches, with: event);
            if exist {
                alertView.removeFromSuperview();
                exist = false;
                alpha = 0.5;
            }else{
                addAlertView();
                exist = true;
                alpha = 1.0;
            }
        }else{
            super.touchesEnded(touches, with: event);
            let touch = ((touches as NSSet).anyObject() as AnyObject)
            if touch.tapCount == 0{
                if self.frame.origin.x >= self.kScreenWidth / 2{
                    _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {_ in
                        UIView.animate(withDuration: 0.8, animations: {
                            self.frame.origin.x = self.kScreenWidth - 25;
                        })
                        _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {_ in
                            self.alpha = 0.5;
                        })
                    })
                }else{
                    _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {_ in
                        UIView.animate(withDuration: 0.8, animations: {
                            self.frame.origin.x = -25;
                        })
                        _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {_ in
                            self.alpha = 0.5;
                        })
                    })
                }
            }
        }
    }
    
    func addAlertView(){
        alertView.frame = CGRect(x: 0, y: 0, width: 200, height: 200);
        alertView.center = self.superview!.center;
        alertView.backgroundColor = UIColor.darkGray;
        alertView.alpha = 0.8;
        alertView.layer.cornerRadius = 5;
        alertView.layer.masksToBounds = true;
        self.superview?.addSubview(alertView);
        
        eventBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50);
        eventBtn.center = CGPoint(x:100,y:100);
        eventBtn.setBackgroundImage(UIImage(named:"2"), for: .normal);
        eventBtn.setBackgroundImage(UIImage(named:"2"), for: .highlighted);
        alertView.addSubview(eventBtn);
        
        eventTitle.frame = CGRect(x: eventBtn.frame.origin.x , y: eventBtn.frame.origin.y + 50, width: 50, height: 22);
        eventTitle.font = UIFont.systemFont(ofSize: 10);
        eventTitle.textAlignment = NSTextAlignment.center;
        eventTitle.text = "切换账号";
        eventTitle.textColor = UIColor.white;
        alertView.addSubview(eventTitle);
        
    }
}
