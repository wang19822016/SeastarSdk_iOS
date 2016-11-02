//
//  ViewController.swift
//  SDKDemo
//
//  Created by seastar on 16/10/31.
//
//

import UIKit
import SeastarSdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var set = Set<String>()
        set.insert("ss.xyjhtw.app.002");
        set.insert("ss.xyjhtw.app.001");
        SeastarSdk.current.requestSku(productIdentifiers: set)
        
    }

    @IBAction func click(_ sender: AnyObject) {
        SeastarSdk.current.login(loginSuccess: { (int:Int, string:String) in
            print("loginSuccess")
            }) { 
                print("loginFalse");
        }
    }

    @IBAction func logout(_ sender: AnyObject) {
        SeastarSdk.current.logout();
    }
    @IBAction func Buy(_ sender: AnyObject) {
        SeastarSdk.current.purchase(productId: "ss.xyjhtw.app.002", roleId: "role123",serverId: "serverId", extra: "extra123", paySuccess: { (str1:String, str2:String) in
            print(str1,str2);
        }) { (str3:String) in
            print(str3);
        }
    }
    @IBAction func buyOther(_ sender: AnyObject) {
        SeastarSdk.current.checkLeakPurchase();
        
    }
}
