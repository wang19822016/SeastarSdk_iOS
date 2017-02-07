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
    
    var viewController: UIViewController? = nil
    
    var myOrientation:Bool = true
    
    
    public func initialize(viewController: UIViewController, landscape:Bool) {
        PurchaseViewModel.current.initialize()
        self.viewController = viewController
        myOrientation = landscape;
    }

    // 需要切换到Facebook应用或者Safari的应调用下面方法
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Facebook.current.application(application, didFinishLaunchingWithOptions: launchOptions)
        let app = AppModel()
        AppsFlyerTracker.shared().appleAppID = app.appsFlyerID
        AppsFlyerTracker.shared().appsFlyerDevKey = app.appsFlyerKey
    }
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any){
        
        Facebook.current.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // 需要fb纪录应用激活事件的调用下面的方法
    public func applicationDidBecomeActive(_ application: UIApplication) {
        Facebook.current.applicationDidBecomeActive(application)
    }
    
    // 掉单重处理
    public func checkLeakPurchase() {
        PurchaseViewModel.current.checkLeakPurchase()
    }
    
    public func login(loginSuccess:@escaping (Int, String)->Void, loginFailure:@escaping ()->Void) {
        var user = UserModel()
        if user.loadCurrentUser() {
            UserViewModel.current.doSessionLogin(usermodel:user,success: {
                userModel in loginSuccess(userModel.userId, userModel.session)
                hud(hudString: "LoginSuccess", hudView: self.viewController!.view)
            }, failure: { str in
                    if self.myOrientation == true{
                        let storyboard: UIStoryboard = UIStoryboard(name: "seastar", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                        
                        let vc: MainLoginViewController = storyboard.instantiateInitialViewController()! as! MainLoginViewController
                        
                        vc.loginSuccess = {(userModel:UserModel) in
                            loginSuccess(userModel.userId, userModel.session)
                            hud(hudString: "LoginSuccess", hudView: self.viewController!.view)
                        }
                        
                        vc.loginFailure = {()in
                            loginFailure();
                        }
                        
                        self.viewController?.present(vc, animated: true, completion: nil)
                    }else{
                        let storyboardPortrait: UIStoryboard = UIStoryboard(name: "seastar_p", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                        
                        let vcPortrait: MainPortraitViewController = storyboardPortrait.instantiateInitialViewController()! as! MainPortraitViewController
                        
                        vcPortrait.LoginSuccess = {(userModel:UserModel) in
                            loginSuccess(userModel.userId, userModel.session)
                            hud(hudString: "LoginSuccess", hudView: self.viewController!.view)
                        }
                        
                        vcPortrait.LoginFailure = {()in
                            loginFailure();
                        }
                        
                        self.viewController?.present(vcPortrait, animated: true, completion: nil)
                    }
                    
            })
        } else {
            //因为在frame里面其bundle默认是framework的，不是工程mainBundle，所以这边bundle要按一下写
            
            if myOrientation == true{
                let storyboard: UIStoryboard = UIStoryboard(name: "seastar", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                
                let vc: MainLoginViewController = storyboard.instantiateInitialViewController()! as! MainLoginViewController
                
                vc.loginSuccess = {(userModel:UserModel) in
                    loginSuccess(userModel.userId, userModel.session)
                    hud(hudString: "LoginSuccess", hudView: self.viewController!.view)
                }
                
                vc.loginFailure = {()in
                    loginFailure();
                }
                
                viewController?.present(vc, animated: true, completion: nil)
            }else{
                let storyboardPortrait: UIStoryboard = UIStoryboard(name: "seastar_p", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                let vcPortrait: MainPortraitViewController = storyboardPortrait.instantiateInitialViewController()! as! MainPortraitViewController
                vcPortrait.LoginSuccess = {(userModel:UserModel) in
                    loginSuccess(userModel.userId, userModel.session)
                    hud(hudString: "LoginSuccess", hudView: self.viewController!.view)
                }
                vcPortrait.LoginFailure = {()in
                    loginFailure();
                }
                viewController?.present(vcPortrait, animated: true, completion: nil)
            }
        }
    }
    
    public func changeAccount(loginSuccess:@escaping (Int, String)->Void, loginFailure:@escaping ()->Void)
    {
            if self.myOrientation == true{
                let storyboard: UIStoryboard = UIStoryboard(name: "changeAccount", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                let vc: ChangeAccountViewController = storyboard.instantiateInitialViewController()! as! ChangeAccountViewController
                vc.ChangeAccountloginSuccess = {(userModel:UserModel) in
                    loginSuccess(userModel.userId, userModel.session)
                    hud(hudString: "LoginSuccess", hudView: self.viewController!.view)
                }
                vc.ChangeAccountloginFailure = {()in
                    loginFailure();
                }
                viewController?.present(vc, animated: true, completion: nil)
            }else{
                let storyboardPortrait: UIStoryboard = UIStoryboard(name: "changeAccount_p", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)
                let vcPortrait: ChangeAccountPortraitViewController = storyboardPortrait.instantiateInitialViewController()! as! ChangeAccountPortraitViewController
                vcPortrait.ChangeAccountloginSuccess = {(userModel:UserModel) in
                    loginSuccess(userModel.userId, userModel.session)
                    hud(hudString: "LoginSuccess", hudView: self.viewController!.view)
                }
                vcPortrait.ChangeAccountloginFailure = {()in
                    loginFailure();
                }
                viewController?.present(vcPortrait, animated: true, completion: nil)
            }
    }
    
    public func logout() {
        UserViewModel.current.doLogout()
    }
    
    public func purchase(productId: String, roleId: String, serverId: String, extra: String, paySuccess: @escaping (String, String)->Void, payFailure: @escaping (String)->Void) {
        PurchaseViewModel.current.doPurchase(productId: productId, roleId: roleId, serverId: serverId, extra: extra, purchaseSuccess: {
            order, productIdentifier in
            paySuccess(order, productIdentifier)
            }, purchaseFailure: {
                productIdentifier in
                payFailure(productIdentifier)
        })
    }
    
    //统计相关
    public func trackActive(){
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    public func trackRegisterUninstall(deviceToken:Data){
        AppsFlyerTracker.shared().registerUninstall(deviceToken);
    }
    
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

    func shareFb(viewController controller: UIViewController, contentURL url: String, contentTitle title: String,
               imageURL image: String, contentDescription description: String, caller:@escaping (Bool)->Void) {
    
        Facebook.current.share(viewController: controller, contentURL: url, contentTitle: title, imageURL: image, contentDescription: description, caller:caller);
    }
    
    func shareFb(viewController controller: UIViewController, imageURL url: String, imageCaption caption: String, caller: @escaping (Bool)->Void) {
        Facebook.current.share(viewController: controller, imageURL: url, imageCaption: caption, caller: caller);
    }
    
    func doFbGameRequest(requestMessage message: String, requestTitle title: String, caller: @escaping (Bool)->Void) {
        Facebook.current.doGameRequest(requestMessage: message, requestTitle: title, caller: caller);
    }
    
    func deleteFbGameRequest() {
        Facebook.current.deleteGameRequest();
    }
    
    func doFbAppInvite(viewController controller: UIViewController, appLinkURL linkURL:String, appInvitePreviewImageURL imageURL: String,caller:@escaping (Bool)->Void) {
        Facebook.current.doAppInvite(viewController: controller, appLinkURL: linkURL, appInvitePreviewImageURL: imageURL, caller: caller);
    }
    
    func getFbMeInfo(success:@escaping (String)->Void, failure:@escaping ()->Void){
        Facebook.current.getMeInfo(success: success, failure: failure);
    }
    
    func getFbFriendInfo(height:Int, width:Int, limit:Int, success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getFriendInfo(height: height, width: width, limit: limit, success: success, failure: failure);
    }
    
    func getNextFbFriendInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getNextFriendInfo(success: success, failure: failure);
    }
    
    func getPrevFbFriendInfo(success:@escaping (String)->Void, failure:@escaping ()->Void) {
        Facebook.current.getPrevFriendInfo(success: success, failure: failure);
    }

}





