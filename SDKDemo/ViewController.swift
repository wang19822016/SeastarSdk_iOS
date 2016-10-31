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
        
    }

    @IBAction func click(_ sender: AnyObject) {
        SeastarSdk.current.login(loginSuccess: { (int:Int, string:String) in
            print("loginSuccess")
            }) { 
                print("loginFalse");
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

