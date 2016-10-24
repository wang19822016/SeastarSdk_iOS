//
//  SeastarSdk.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/28.
//
//



import Foundation

public class SeastarSdk {
    
    var viewController: UIViewController? = nil
    
    func initialize(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return Facebook.current.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return Facebook.current.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // 需要fb纪录应用激活事件的调用下面的方法
    func applicationDidBecomeActive(_ application: UIApplication) {
        Facebook.current.applicationDidBecomeActive(application)
    }
    
    // 如果失败，需要连续请求几次
    func requestSku(productIdentifiers: Set<IAPHelper.ProductIdentifier>) {
        IAPHelper.current.requestProducts(productIdentifiers: productIdentifiers) {
            success in
            
            if success {
                // 添加交易监听
                IAPHelper.current.addPaymentListener()
            }
        }
    }
    
    func login(loginSuccess:@escaping (Int, String)->Void, loginFailure:@escaping ()->Void) {
        let (success, _) = UserModel.loadCurrentUser()
        if success {
            UserViewModel.current.doSessionLogin(success: {
                userModel in loginSuccess(userModel.userId, userModel.session) }, failure: { loginFailure() })
        } else {
            //因为在frame里面其bundle实frame不是工程文件所以这边bundle要按一下写
            let storyboard: UIStoryboard = UIStoryboard(name: "seastar", bundle: Bundle.main)
            let vc: UIViewController = storyboard.instantiateInitialViewController()!
            viewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func logout() {
        UserViewModel.current.doLogout()
    }
    
    func purchase(productId: String, extra: String) {
        let (success, user) = UserModel.loadCurrentUser()
        
        IAPHelper.current.purchase(productIdentifier: "") {
            success, product in
            
        };
    }
}
