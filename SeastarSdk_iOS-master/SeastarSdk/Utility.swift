//
//  Utility.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation
import AdSupport

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
    let languages = NSLocale.preferredLanguages;
    return languages[0];
    
}

func md5(string data: String) -> String {
    return data.md5()
}

func hud(hudString :String,hudView:UIView)
{
    DispatchQueue.main.async {
        let hud = MBProgressHUD.showAdded(to: hudView, animated: true);
        hud.mode = MBProgressHUDMode.text;
        hud.label.text = NSLocalizedString(hudString, comment: "");
        hud.label.numberOfLines = 0;
        hud.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
        hud.hide(animated: true, afterDelay: 3.0);
    }
}

func seastarCompare(admin Str:String) ->Bool{
    let Regex = "[a-zA-Z][a-zA-Z0-9]{5,22}";
    let Test = NSPredicate(format: "SELF MATCHES %@" ,Regex);
    if Test.evaluate(with: Str){
        return true;
    }else{
        return false;
    }
}

func seastarCompare(password Str:String) ->Bool{
    let Regex = "[a-zA-Z0-9]{8,32}";
    let Test = NSPredicate(format: "SELF MATCHES %@" ,Regex);
    if Test.evaluate(with: Str){
        return true;
    }else{
        return false;
    }
}

func seastarCompare(email Str:String) ->Bool{
    let Regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    let Test = NSPredicate(format: "SELF MATCHES %@" ,Regex);
    if Test.evaluate(with: Str){
        return true;
    }else{
        return false;
    }
}

func b64UrlDecode(_ encodedString: String) -> String? {
    if let decodeString = encodedString.removingPercentEncoding {
        if let data = Data(base64Encoded: decodeString) {
            return String(data: data, encoding: .utf8)
        }
    }

    return nil
}

func b64UrlEncode(_ originString: String) -> String? {
    let str: String = Data(originString.utf8).base64EncodedString()
    return str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
}

func b64Decode(_ encodedString: String) -> String? {
    if let data = Data(base64Encoded: encodedString) {
        return String(data: data, encoding: .utf8)
    }

    
    return nil
}

func b64Encode(_ originString: String) -> String? {
    return Data(originString.utf8).base64EncodedString()
}
