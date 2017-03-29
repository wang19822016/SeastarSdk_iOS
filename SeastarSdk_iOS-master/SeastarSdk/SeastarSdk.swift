//
//  SeastarSdk.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/28.
//
//



import Foundation
import UIKit
import AppsFlyerLib

public class SeastarSdk : NSObject {
    public static let current = SeastarSdk()
    
    //var viewController: UIViewController? = nil
    
//    var myOrientation:Bool = true
    
    private var options: [UserModel] = []
    
    public func initialize(viewController: UIViewController, landscape:Bool) {
        PurchaseViewModel.current.initialize()
        Global.current.rootViewController = viewController
        Global.current.myOrientation = landscape;
        UserModel.clearExpire()
    }
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Facebook.current.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let content = Bundle.main.path(forResource: "Info", ofType: "plist");
        let rootDictionary = NSMutableDictionary(contentsOfFile: content!);
        let appsFlyerID = rootDictionary?.object(forKey: "AppsFlyerID")as! String;
        let appsFlyerKey = rootDictionary?.object(forKey: "AppsFlyerKey")as! String;
        AppsFlyerTracker.shared().appleAppID = appsFlyerID;
        AppsFlyerTracker.shared().appsFlyerDevKey = appsFlyerKey;
    }
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any){
        
        Facebook.current.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // 需要fb纪录应用激活事件的调用下面的方法
    public func applicationDidBecomeActive(_ application: UIApplication) {
        Facebook.current.applicationDidBecomeActive(application)
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    //统计卸载
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AppsFlyerTracker.shared().registerUninstall(deviceToken);
    }
    
    // 掉单重处理
    public func checkLeakPurchase() {
        PurchaseViewModel.current.checkLeakPurchase()
    }
    
    public func login(loginSuccess:@escaping (Int, String)->Void, loginFailure:@escaping ()->Void) {
        Global.current.loginSuccess = {(userModel:UserModel) in
            loginSuccess(Int(userModel.userId), userModel.token)
            hud(hudString: "LoginSuccess", hudView: (Global.current.rootViewController?.view)!)
        }
        Global.current.loginFailure = {()in
            loginFailure();
        }
        var user = UserModel()
        if user.loadCurrentUser() {
            loginSuccess(Int(user.userId), user.token)
        }else{
            if(Global.current.myOrientation){
            let userModel = UserModel.loadAllUsers();
            if userModel.count == 0{
                //没账号
                let storyboard: UIStoryboard = UIStoryboard(name: "seastar", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                
                let vc: MainLoginViewController = storyboard.instantiateInitialViewController()! as! MainLoginViewController

                Global.current.rootViewController?.present(vc, animated: true, completion: nil)
            }else{
                //有账号
                let storyboard: UIStoryboard = UIStoryboard(name: "changeAccount", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                let vc: ChangeAccountViewController = storyboard.instantiateInitialViewController()! as! ChangeAccountViewController
                Global.current.rootViewController?.present(vc, animated: true, completion: nil)
            }
            }else{
                let userModel = UserModel.loadAllUsers()
                if userModel.count == 0{
                    let storyboardPortrait: UIStoryboard = UIStoryboard(name: "seastar_p", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                    let vcPortrait: MainPortraitViewController = storyboardPortrait.instantiateInitialViewController()! as! MainPortraitViewController

                    Global.current.rootViewController?.present(vcPortrait, animated: true, completion: nil)
                }else{
                    let storyboardPortrait: UIStoryboard = UIStoryboard(name: "changeAccount_p", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                    let vcPortrait: ChangeAccountPortraitViewController = storyboardPortrait.instantiateInitialViewController()! as! ChangeAccountPortraitViewController
                    Global.current.rootViewController?.present(vcPortrait, animated: true, completion: nil)
                }
            }
            }
    }
    
    public func changeAccount(loginSuccess:@escaping (Int, String)->Void, loginFailure:@escaping ()->Void)
    {
        Global.current.loginSuccess = {(userModel:UserModel) in
            loginSuccess(Int(userModel.userId), userModel.token)
            hud(hudString: "LoginSuccess", hudView: (Global.current.rootViewController?.view)!)
        }
        Global.current.loginFailure = {()in
            loginFailure();
        }
        if Global.current.myOrientation == true{
            let storyboard: UIStoryboard = UIStoryboard(name: "changeAccount", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
            let vc: ChangeAccountViewController = storyboard.instantiateInitialViewController()! as! ChangeAccountViewController

            Global.current.rootViewController?.present(vc, animated: true, completion: nil)
        }else{
            let storyboardPortrait: UIStoryboard = UIStoryboard(name: "changeAccount_p", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
            let vcPortrait: ChangeAccountPortraitViewController = storyboardPortrait.instantiateInitialViewController()! as! ChangeAccountPortraitViewController
            Global.current.rootViewController?.present(vcPortrait, animated: true, completion: nil)
        }
    }
    
    public func logout() {
        UserViewModel.current.doLogout()
    }
    
    public func purchase(productId: String, roleId: String, serverId: String, extra: String, paySuccess: @escaping (String, String)->Void, payFailure: @escaping (String)->Void) {
        PurchaseViewModel.current.doPurchase(productId: productId, roleId: roleId, serverId: serverId, extra: extra, purchaseSuccess: {
            order, productIdentifier in
            paySuccess(order, productIdentifier)
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "", message: "Success, you will get the purchases in 1-3 min. If have questions, please contact streetball.seastar@gamil.com", preferredStyle: .alert);
                let confirm = UIAlertAction(title: "Confirm", style: .default, handler: nil);
                alert.addAction(confirm);
                Global.current.rootViewController?.present(alert, animated: true, completion: nil);
            }
            
        }, purchaseFailure: {
            productIdentifier in
            payFailure(productIdentifier)
        })
    }
    
    //统计相关
    public func trackLogin(){
        AppsFlyerTracker.shared().trackEvent(AFEventLogin, withValues: nil);
    }
    
    public func trackRegistration(){
        AppsFlyerTracker.shared().trackEvent(AFEventCompleteRegistration, withValues: nil);
    }
    
    public func trackPurchase(sku:String,skuType:String,price:Int,currency:String){
        let purchaseDic:[String:Any] = [AFEventParamContentId:sku,
                                        AFEventParamContentType : skuType,
                                        AFEventParamRevenue: price,
                                        AFEventParamCurrency:currency
        ]
        AppsFlyerTracker.shared().trackEvent(AFEventPurchase, withValues: purchaseDic);
    }
    
    public func trackLevelAchieved(level:String,score:String){
        let levelDic:[String:Any] = [AFEventParamLevel:level,
                                     AFEventParamScore :score
        ]
        AppsFlyerTracker.shared().trackEvent(AFEventLevelAchieved, withValues: levelDic)
    }
    
    //Facebook相关
    
    public func shareFb(viewController controller: UIViewController, contentURL url: String, contentTitle title: String,
                        imageURL image: String, contentDescription description: String, caller:@escaping (Bool)->Void) {
        
        Facebook.current.share(viewController: controller, contentURL: url, contentTitle: title, imageURL: image, contentDescription: description, caller:caller);
    }
    
    public func shareFb(viewController controller: UIViewController, imageURL url: String, imageCaption caption: String, caller: @escaping (Bool)->Void) {
        Facebook.current.share(viewController: controller, imageURL: url, imageCaption: caption, caller: caller);
    }
    
    public func doFbGameRequest(requestMessage message: String, requestTitle title: String, caller: @escaping (Bool)->Void) {
        Facebook.current.doGameRequest(requestMessage: message, requestTitle: title, caller: caller);
    }
    
    public func deleteFbGameRequest() {
        Facebook.current.deleteGameRequest();
    }
    
    public func doFbAppInvite(viewController controller: UIViewController, appLinkURL linkURL:String, appInvitePreviewImageURL imageURL: String,caller:@escaping (Bool)->Void) {
        Facebook.current.doAppInvite(viewController: controller, appLinkURL: linkURL, appInvitePreviewImageURL: imageURL, caller: caller);
    }
    
    public func getFbMeInfo(success:@escaping (String)->Void, failure:@escaping ()->Void){
        Facebook.current.getMeInfo(success: success, failure: failure);
    }
    
    public func getFbFriendInfo(height:Int, width:Int, limit:Int, success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getFriendInfo(height: height, width: width, limit: limit, success: success, failure: failure);
    }
    
    public func getNextFbFriendInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getNextFriendInfo(success: success, failure: failure);
    }
    
    public func getPrevFbFriendInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getPrevFriendInfo(success: success, failure: failure);
    }
    
}





