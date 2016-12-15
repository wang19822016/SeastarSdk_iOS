//
//  VerticalButton.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2016/12/7.
//
//

import UIKit

class VerticalButton: UIButton {

    func setUp(){
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        setUp();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.imageView?.frame.origin.x = 0;
        self.imageView?.frame.origin.y = 0;
        
        self.titleLabel?.frame.origin.x = 0;
        self.titleLabel?.frame.origin.y = (self.imageView?.frame.size.height)!;
        self.titleLabel?.frame.size.width = self.frame.size.width;
    }
}
