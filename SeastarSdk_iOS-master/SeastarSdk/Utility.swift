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
    if ASIdentifierManager.shared().isAdvertisingTrackingEnabled{
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }else{
        let str = UserDefaults.standard.string(forKey: "uuid")
        if str != nil{
            return str!
        }else{
        let uuid = UUID().uuidString;
        UserDefaults.standard.set(uuid, forKey: "uuid");
        UserDefaults.standard.synchronize();
        return uuid;
        }
    }
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
        hud.label.font = UIFont.systemFont(ofSize: 13);
        hud.label.numberOfLines = 0;
        hud.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
        hud.hide(animated: true, afterDelay: 2.0);
    }
}

func customHud(userModel:UserModel,hudView:UIView){
    DispatchQueue.main.async {
        //NSString
        let font = UIFont.systemFont(ofSize: 13);
        let welcomeStr = NSLocalizedString("LoginSuccess", comment: "");
        let noticeStr:NSString = userModel.userName + "," + welcomeStr as NSString
        let size = CGSize(width: 900, height: 40);
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strsize = noticeStr.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as?[String:AnyObject], context: nil).size
        //UIView
        let view = UIView(frame: CGRect(x: 0, y: 0, width: strsize.width + 60, height: 40));
        view.center = CGPoint(x: hudView.frame.size.width / 2, y: 40);
        hudView.addSubview(view);
        //UIImageView
        let bundle = Bundle(for: SeastarSdk.classForCoder());
        let fileStr = bundle.path(forResource: "loginAlert", ofType: "png");
        let imageView = UIImageView(image: UIImage(named: fileStr!));
        imageView.frame = view.bounds;
        view.addSubview(imageView);
        //HeaderImage
        var imageStr = "";
        switch userModel.loginType{
        case 0:
            imageStr = "seastar";
            break;
        case 1:
            imageStr = "guest";
            break;
        case 4:
            imageStr = "facebook";
            break;
        default:
            break;
        }
        let myBundle = Bundle(for: SeastarSdk.classForCoder());
        let imagePath = myBundle.path(forResource: imageStr, ofType: "png");
        let image = UIImage(named:imagePath!);
        let headerImageView = UIImageView(image: image);
        headerImageView.frame = CGRect(x: 10, y: 4, width: 32, height: 32);
        view.addSubview(headerImageView);
        //UIlabel
        let label = UILabel(frame: CGRect(x: 46, y: 4, width: strsize.width, height: 32));
        label.text = noticeStr as String;
        label.font = font
        view.addSubview(label);
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            view.removeFromSuperview();
        })
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
    var decodeString = encodedString.replacingOccurrences(of: "-", with: "+")
    decodeString = decodeString.replacingOccurrences(of: "_", with: "/")
    switch (decodeString.lengthOfBytes(using: .utf8) % 4) {
    case 0:
        break
    case 2:
        decodeString.append("==")
        break
    case 3:
        decodeString.append("=")
        break
    default:
        break
    }
    if let data = Data(base64Encoded: decodeString, options: NSData.Base64DecodingOptions(rawValue: 0)) {
        return String(data: data, encoding: .utf8)
    }
    return nil
}

func b64UrlEncode(_ originString: String) -> String? {
    var str: String = Data(originString.utf8).base64EncodedString()
    let strArray = str.components(separatedBy: "=")
    if (strArray.count > 0) {
        str = strArray[0]
        str = str.replacingOccurrences(of: "+", with: "-")
        str = str.replacingOccurrences(of: "/", with: "_")
        return str
    }
    
    return str
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

func addSuspendedBtn(){
    let btn = SuspendedButton(type: .custom);
    btn.frame = CGRect(x: -25, y: 50, width: 50, height: 50);
    btn.setBackgroundImage(UIImage(named:"suspended"), for: .normal)
    btn.setBackgroundImage(UIImage(named:"suspended_highlighted"), for: .highlighted);
    btn.alpha = 0.5
    Global.current.rootViewController?.view.addSubview(btn);
}


