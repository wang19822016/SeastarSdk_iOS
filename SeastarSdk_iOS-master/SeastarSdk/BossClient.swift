//
//  BossClient.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2017/4/14.
//
//

import Foundation
import AppsFlyerLib
class BossClient:NSObject{
    
    static let current = BossClient();
    
    let app = AppModel();
    var myUserId:String = "000";
    
    func register(userId:String){
        let time = getTime();
        let appsUID:String = AppsFlyerTracker.shared().getAppsFlyerUID()
        let url = serverUrl + "/user/register";
        let dic = ["api":"user/register",
                   "appId":app.appId,
                   "userId":userId,
                   "deviceId":appsUID,
                   "clientTime":time,
                   "platform":"ios"
            ] as [String : Any]
        myUserId = userId;
        myPost(dic: dic, urlStr: url);
        print(userId);
    }
    
    func login(userId:String){
        let time = getTime();
        let url = serverUrl + "/user/login";
        let dic = [ "api":"user/login",
                    "appId":app.appId,
                    "userId":userId,
                    "clientTime":time
            ] as [String : Any]
        myUserId = userId;
        myPost(dic: dic, urlStr: url);
    }
    
    func pay(productId:String){
        let time = getTime();
        let url = serverUrl + "/user/pay";
        let dic = [ "api":"user/pay",
                    "appId":app.appId,
                    "userId":myUserId,
                    "payMoney":"0",
                    "goodsId":productId,
                    "clientTime":time
            ] as [String : Any]
        myPost(dic: dic, urlStr: url);
    }
    
    func online(){
        let time = getTime();
        let url = serverUrl + "/user/online";
        let dic = [ "api":"user/online",
                    "appId":app.appId,
                    "userId":myUserId,
                    "clientTime":time
            ] as [String : Any]
        myPost(dic: dic, urlStr: url);
        
    }
    
    func getTime()->String{
        let serverTime = NSDate().timeIntervalSince1970;
        let timeStr:String = String(serverTime);
        let index = timeStr.index(timeStr.startIndex, offsetBy: 10);
        let time = timeStr.substring(to: index);
        return time;
    }
    var seastarTimer = Timer();
    
    let serverUrl:String = "https://report.vrseastar.com";
    //启动定时器
    func startTimer(){
        //print(Thread.current);
        self.seastarTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(self.postData), userInfo: nil, repeats: true);
        //print(Thread.current);
    }
    
    //永久关闭定时器
    func stopTimer(){
        seastarTimer.invalidate();
    }
    
    //暂停定时器
    func lockTimer(){
        seastarTimer.fireDate = NSDate.distantPast;
    }
    
    //开启定时器
    func unlockTimer(){
        seastarTimer.fireDate = NSDate.distantFuture;
        
    }
    
    @objc func postData(){
        DispatchQueue.global().async {
            print(Thread.current);
            self.online();
        }
    }
    
    func myPost(dic:[String:Any],urlStr:String){
        let postData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted);
        let url = URL(string: urlStr);
        var request = URLRequest(url: url!);
        request.httpMethod = "POST";
        request.timeoutInterval = 15;
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        request.setValue("application/json", forHTTPHeaderField: "Accept");
        request.httpBody = postData;
        
        let session = URLSession.shared;
        let task = session.dataTask(with: request) { (data, response, error) in
                        print(data ?? NSData());
            print(response ?? URLResponse());
                        print(error ?? Error.self);
        };
        task.resume();
    }
}
