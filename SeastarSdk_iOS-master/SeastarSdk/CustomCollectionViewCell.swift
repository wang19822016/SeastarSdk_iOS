//
//  CustomCollectionViewCell.swift
//  5456456
//
//  Created by seastar on 2017/4/11.
//  Copyright © 2017年 seastar. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    var imageView = UIImageView();
    var label = UILabel();
    var button = UIButton();
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
        contentView.addSubview(imageView);
        
        label = UILabel(frame: CGRect(x: 45, y: 5, width: 65, height: 30));
        label.font = UIFont.systemFont(ofSize: 10);
        contentView.addSubview(label);
        
        button = UIButton(type: .custom);
        let rect = CGRect(x: 115, y: 5, width: 30, height: 30);
        button.frame = rect;
        contentView.addSubview(button);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
