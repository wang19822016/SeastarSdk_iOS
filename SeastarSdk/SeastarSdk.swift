//
//  SeastarSdk.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/28.
//
//



import Foundation
import UIKit

public class SeastarSdk : NSObject {
    public static let current = SeastarSdk()
    
    var viewController: UIViewController? = nil
    
    var myOrientation:Bool = true
    
    
    public func initializelll(viewController: UIViewController, landscape:Bool) {
        PurchaseViewModel.current.initialize()
        self.viewController = viewController
        myOrientation = landscape;
    }

    // 需要切换到Facebook应用或者Safari的应调用下面方法
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Facebook.current.application(application, didFinishLaunchingWithOptions: launchOptions)
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
                userModel in loginSuccess(userModel.userId, userModel.session) }, failure: { str in
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
}





