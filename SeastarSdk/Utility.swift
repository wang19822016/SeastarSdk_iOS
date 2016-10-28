//
//  Utility.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation
import AdSupport
import CryptoSwift

func Log(_ message: String, fileName: String = #file, methodName: String =  #function, lineNumber: Int = #line)
{
    print("\(fileName) \(methodName) [\(lineNumber)]: \(message)")
}

func deviceId() -> String {
    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
}

func deviceInfo() -> String {
    return "System: \(UIDevice.current.systemName):\(UIDevice.current.systemVersion), Model: \(UIDevice.current.model)"
}

func locale() -> String {
    return UserDefaults.standard.object(forKey: "AppleLanguages") as? String ?? ""
}

func md5(string data: String) -> String {
    return data.md5()
}

func hud(hudString :String,hudView:UIView)
{
    let hud = MBProgressHUD.showAdded(to: hudView, animated: true);
    hud.mode = MBProgressHUDMode.text;
    hud.label.text = NSLocalizedString(hudString, comment: "");
    hud.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
    hud .hide(animated: true, afterDelay: 3.0);
}
