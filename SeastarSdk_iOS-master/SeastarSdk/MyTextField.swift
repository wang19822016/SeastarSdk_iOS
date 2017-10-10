//
//  MyTextField.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2017/5/2.
//
//

import UIKit

class MyTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let customRect = CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.size.width - 25, height: bounds.size.height);
        return customRect;
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let customRect = CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.size.width - 25, height: bounds.size.height);
        return customRect;
    }
}
