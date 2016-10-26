//
//  SeastarSdk.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/28.
//
//



import Foundation

public class SeastarSdk : NSObject {
    public static let current = SeastarSdk()
    
    var viewController: UIViewController? = nil
    
    public func initialize(viewController: UIViewController) {
        PurchaseViewModel.current.initialize()
        self.viewController = viewController
    }
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return Facebook.current.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // 需要切换到Facebook应用或者Safari的应调用下面方法
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return Facebook.current.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // 需要fb纪录应用激活事件的调用下面的方法
    public func applicationDidBecomeActive(_ application: UIApplication) {
        Facebook.current.applicationDidBecomeActive(application)
    }
    
    // 请求支付商品，需要在合适的地方调用，可以缩短每次支付消耗的时间
    func requestSku(productIdentifiers: Set<IAPHelper.ProductIdentifier>) {
        PurchaseViewModel.current.requestProducts(productIdentifiers: productIdentifiers)
    }
    
    // 掉单重处理
    func checkLeakPurchase() {
        PurchaseViewModel.current.checkLeakPurchase()
    }
    
    public func login(loginSuccess:@escaping (Int, String)->Void, loginFailure:@escaping ()->Void) {
        let user = UserModel()
        if user.loadCurrentUser() {
            UserViewModel.current.doSessionLogin(success: {
                userModel in loginSuccess(userModel.userId, userModel.session) }, failure: { loginFailure() })
        } else {
            //因为在frame里面其bundle默认是framework的，不是工程mainBundle，所以这边bundle要按一下写
            let storyboard: UIStoryboard = UIStoryboard(name: "seastar", bundle: Bundle(for: SeastarSdk.classForCoder()))//Bundle.main)

            let vc: MainLoginViewController = storyboard.instantiateInitialViewController()! as! MainLoginViewController
            
            vc.loginBack = {(userModel:UserModel) in
                loginSuccess(userModel.userId, userModel.session)
            }
            
            vc.loginFailure = {()in
                loginFailure();
            }
            
            viewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    public func logout() {
        UserViewModel.current.doLogout()
    }
    
    public func purchase(productId: String, roleId: String, extra: String, paySuccess: @escaping (String, String)->Void, payFailure: @escaping (String)->Void) {
        PurchaseViewModel.current.doPurchase(productId: productId, roleId: roleId, extra: extra, purchaseSuccess: {
                order, productIdentifier in
            
                paySuccess(order, productIdentifier)
            
            }, purchaseFailure: {
                productIdentifier in
                
                payFailure(productIdentifier)
        })
    }
}





