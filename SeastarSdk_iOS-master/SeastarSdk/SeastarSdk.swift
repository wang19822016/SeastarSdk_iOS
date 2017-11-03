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
    @objc public static let current = SeastarSdk()
    
    //var viewController: UIViewController? = nil
    
//    var myOrientation:Bool = true
    
    private var options: [UserModel] = []
    
    @objc public func initialize(viewController: UIViewController, landscape:Bool) {
        PurchaseViewModel.current.initialize()
        Global.current.rootViewController = viewController
        Global.current.myOrientation = landscape;
        UserModel.clearExpire()
    }
    var track:GocpaTracker?
    var GocpaExist:Bool?
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    @objc public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Facebook.current.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let content = Bundle.main.path(forResource: "Info", ofType: "plist");
        let rootDictionary = NSMutableDictionary(contentsOfFile: content!);
        let appsFlyerID = rootDictionary?.object(forKey: "AppsFlyerID")as! String
        let appsFlyerKey = rootDictionary?.object(forKey: "AppsFlyerKey")as! String;
        if let GocpaAppId = rootDictionary?.object(forKey: "GocpaAppId")as? String{
            if let GocpaAdvertiserId = rootDictionary?.object(forKey: "GocpaAdvertiserId")as? String{
                GocpaExist = true;
            track = GocpaTracker(appId: GocpaAppId, advertiserId: GocpaAdvertiserId, referral: false);
            track?.setIDFA(deviceId());
            track?.reportDevice();
                print("reportDevice");
            }
        }else{
            GocpaExist = false;
        }
        if let placementID = rootDictionary?.object(forKey: "placementID")as? String{
            RewardedVideo.current.placementID = placementID
        }
        AppsFlyerTracker.shared().appleAppID = appsFlyerID;
        AppsFlyerTracker.shared().appsFlyerDevKey = appsFlyerKey;
        AppsFlyerTracker.shared().customerUserID = String(AppModel().appId);
        BossClient.current.startTimer();
    }
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    @objc public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any){
        
        Facebook.current.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // 需要fb纪录应用激活事件的调用下面的方法
    @objc public func applicationDidBecomeActive(_ application: UIApplication) {
        Facebook.current.applicationDidBecomeActive(application)
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    //程序进入后台
    @objc public func applicationDidEnterBackground(_ application: UIApplication){
        BossClient.current.lockTimer();
    }
    //程序进入前台
    @objc public func applicationWillEnterForeground(_ application: UIApplication){
        BossClient.current.unlockTimer();
    }
    //统计卸载
    @objc public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AppsFlyerTracker.shared().registerUninstall(deviceToken);
    }
    
    // 掉单重处理
    @objc public func checkLeakPurchase() {
        PurchaseViewModel.current.checkLeakPurchase()
    }
    @objc public func loadRewardedVideoAd(loadRewardedVideoSuccess:@escaping(Bool)->Void){
        RewardedVideo.current.loadRewardedVideo(loadSuccess: {(loadSuccess:Bool) in
            loadRewardedVideoSuccess(loadSuccess);
        })
    }
        
    @objc public func login(loginSuccess:@escaping (Int, String)->Void, loginFailure:@escaping ()->Void) {
        Global.current.loginSuccess = {(userModel:UserModel) in
            loginSuccess(Int(userModel.userId), userModel.token)
            customHud(userModel: userModel, hudView: (Global.current.rootViewController?.view)!)
            //addSuspendedBtn();
            //self.checkEmail();
        }
        Global.current.loginFailure = {()in
            loginFailure();
        }
        var user = UserModel()
        if user.loadCurrentUser() {
            loginSuccess(Int(user.userId), user.token)
            BossClient.current.login(userId: String(user.userId));
        }else{
            if(Global.current.myOrientation){
            let userModel = UserModel.loadAllUsers();
            if userModel.count == 0{
                //没账号
                let storyboard: UIStoryboard = UIStoryboard(name: "seastar", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                
                let vc: MainLoginViewController = storyboard.instantiateInitialViewController()! as! MainLoginViewController
                vc.showBackButton = false;
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
                    vcPortrait.showBackButton = false;
                    Global.current.rootViewController?.present(vcPortrait, animated: true, completion: nil)
                }else{
                    let storyboardPortrait: UIStoryboard = UIStoryboard(name: "changeAccount_p", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                    let vcPortrait: ChangeAccountPortraitViewController = storyboardPortrait.instantiateInitialViewController()! as! ChangeAccountPortraitViewController
                    Global.current.rootViewController?.present(vcPortrait, animated: true, completion: nil)
                }
            }
            }
    }
    
    func checkEmail(){
        let temp = Int(arc4random()%100)+1
        if temp < 60{
            return;
        }
        UserViewModel.current.hasEmail({ 
            //成功
        }) { 
            //显示绑定邮箱界面
        }
    }
    
    @objc public func changeAccount(loginSuccess:@escaping (Int, String)->Void, loginFailure:@escaping ()->Void)
    {
        Global.current.loginSuccess = {(userModel:UserModel) in
            loginSuccess(Int(userModel.userId), userModel.token)
            customHud(userModel: userModel, hudView: (Global.current.rootViewController?.view)!)
            //addSuspendedBtn();
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
    
    @objc public func logout() {
        UserViewModel.current.doLogout()
    }
    
    @objc public func purchase(productId: String, roleId: String, serverId: String, extra: String, paySuccess: @escaping (String, String)->Void, payFailure: @escaping (String)->Void) {
        PurchaseViewModel.current.doPurchase(productId: productId, roleId: roleId, serverId: serverId, extra: extra, purchaseSuccess: {
            order, productIdentifier in
            paySuccess(order, productIdentifier)
            BossClient.current.pay(productId: productId);
        }, purchaseFailure: {
            productIdentifier in
            payFailure(productIdentifier)
        })
    }
    
    @objc public func showFacebookSocialDialog(bindUrl:String, mainPageUrl:String, shareUrl:String,shareImageUrl:String, shareTitle:String,shareDescription:String,inviteSuccess:@escaping(Bool)->Void){
        Global.current.shareSuccess = {(myBool)->Void in
            inviteSuccess(myBool)
        }
        Global.current.contentURL = shareUrl;
        Global.current.contentTitle = shareTitle;
        Global.current.imageURL = shareImageUrl;
        Global.current.contentDescription = shareDescription;
        Global.current.bindUrl = bindUrl;
        Global.current.mainPageUrl = mainPageUrl;
        let storyboard = UIStoryboard(name: "invite", bundle: Bundle(for: SeastarSdk.classForCoder()));
        let vc = storyboard.instantiateInitialViewController() as! InviteViewController;
        Global.current.rootViewController?.present(vc, animated: true, completion: nil);
    }
        
    //统计相关
    @objc public func trackLogin(){
        AppsFlyerTracker.shared().trackEvent(AFEventLogin, withValues: nil);
        if GocpaExist == true{
        track?.reportEvent("Login");
        }
    }
    
    @objc public func trackRegistration(){
        AppsFlyerTracker.shared().trackEvent(AFEventCompleteRegistration, withValues: nil);
        if GocpaExist == true{
        track?.reportEvent("Register");
        }
    }
    
    @objc public func trackPurchase(sku:String,skuType:String,price:Float,currency:String){
        let purchaseDic:[String:Any] = [AFEventParamContentId:sku,
                                        AFEventParamContentType : skuType,
                                        AFEventParamRevenue: price,
                                        AFEventParamCurrency:currency
        ]
        print(purchaseDic);
        AppsFlyerTracker.shared().trackEvent(AFEventPurchase, withValues: purchaseDic);
        if GocpaExist == true{
        track?.reportEvent("Purchase", amount: price, currency: currency)
        }
    }
    
    @objc public func trackLevelAchieved(level:String,score:String){
        let levelDic:[String:Any] = [AFEventParamLevel:level,
                                     AFEventParamScore :score
        ]
        AppsFlyerTracker.shared().trackEvent(AFEventLevelAchieved, withValues: levelDic)
    }
    
    @objc public func trackCustomEvent(customStr:String,customDic:Dictionary<String, Any>){
        AppsFlyerTracker.shared().trackEvent(customStr, withValues: customDic);
        if GocpaExist == true{
        track?.reportEvent(customStr);
        }
    }
    
    //Facebook相关
    
    @objc public func shareFb(viewController controller: UIViewController, contentURL url: String, contentTitle title: String,
                        imageURL image: String, contentDescription description: String, caller:@escaping (Bool)->Void) {
        
        Facebook.current.share(viewController: controller, contentURL: url, contentTitle: title, imageURL: image, contentDescription: description, caller:caller);
    }
    
    @objc public func shareFb(viewController controller: UIViewController, imageURL url: String, imageCaption caption: String, caller: @escaping (Bool)->Void) {
        Facebook.current.share(viewController: controller, imageURL: url, imageCaption: caption, caller: caller);
    }
    
    @objc public func doFbGameRequest(requestMessage message: String, requestTitle title: String, caller: @escaping (Bool)->Void) {
        Facebook.current.doGameRequest(requestMessage: message, requestTitle: title, caller: caller);
    }
    
    @objc public func deleteFbGameRequest() {
        Facebook.current.deleteGameRequest();
    }
    
    @objc public func doFbAppInvite(viewController controller: UIViewController, appLinkURL linkURL:String, appInvitePreviewImageURL imageURL: String,caller:@escaping (Bool)->Void) {
        Facebook.current.doAppInvite(viewController: controller, appLinkURL: linkURL, appInvitePreviewImageURL: imageURL, caller: caller);
    }
    
    @objc public func getFbMeInfo(success:@escaping (Data)->Void, failure:@escaping ()->Void){
        Facebook.current.getMeInfo(success: success, failure: failure);
    }
    
    @objc public func getFbFriendInfo(height:Int, width:Int, limit:Int, success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getFriendInfo(height: height, width: width, limit: limit, success: success, failure: failure);
    }
    
    @objc public func getNextFbFriendInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getNextFriendInfo(success: success, failure: failure);
    }

    @objc public func getPrevFbFriendInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getPrevFriendInfo(success: success, failure: failure);
    }
    
}





