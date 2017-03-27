//
//  PayViewModel.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/10/25.
//
//

import Foundation

class PurchaseViewModel : IAPHelperDelegate {
    typealias SuccessCB = (_ order:String, _ productIdentifier: String)->Void
    typealias FailureCB = (_ productIdentifier: String)->Void
    
    static let current = PurchaseViewModel()
    
    var purchase = PurchaseModel()
    
    //    var productIdentifiers: Set<ProductIdentifier> = Set<ProductIdentifier>()
    var purchaseSuccess: SuccessCB? = nil
    var purchaseFailure: FailureCB? = nil
    
    func initialize() {
        IAPHelper.current.addListener()
        IAPHelper.current.delegate = self;
    }
    
    func destroy() {
        IAPHelper.current.removeListener()
    }
    
    func checkLeakPurchase() {
        // 每次主动上传支付漏单
        let app = AppModel()
        if !app.load() {
            Log("no app config")
            return
        }
        let purchases = PurchaseModel.loadAll()
        for purchase in purchases {
            if !purchase.transactionIdentifier.isEmpty && !purchase.receipt.isEmpty {
                let req: [String : Any] = [
                    "transactionId" : purchase.transactionIdentifier,
                    "productId": purchase.productIdentifier,
                    "receipt" : purchase.receipt,
                    "gameRoleId": purchase.roleId,
                    "cparam": purchase.extra,
                    "price": purchase.price,
                    "serverId":purchase.serverId,
                    "currencyCode": purchase.currency
                ]
                Log("appleOrder: \(purchase.transactionIdentifier) session:\(purchase.token) productId:\(purchase.productIdentifier)")
                MyNetwork.current.post(app.serverUrl + "/api/pay/apple", ["Authorization" : "Bearer \(purchase.token)"], req, { code, resposne in
                    // 验证成功，清除数据
                    //remove
                    purchase.remove()
                    Log("verify: \(code) \(resposne["order"]) \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                }, {
                    Log("verify: network error \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                })
            }
        }
    }
    
    
    func doPurchase(productId: String, roleId: String, serverId: String, extra: String, purchaseSuccess: @escaping SuccessCB, purchaseFailure: @escaping FailureCB) {
        var user = UserModel()
        if !user.loadCurrentUser() || purchase.productIdentifier.isEmpty {
            purchaseFailure(productId)
            
            return
        }
        
        if let product = IAPHelper.current.getProduct(productIdentifer: productId) {
            //有商品信息
            let formatter = NumberFormatter()
            formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.locale = product.priceLocale
            
            purchase.roleId = roleId
            purchase.productIdentifier = productId
            purchase.extra = extra;
            purchase.serverId = serverId
            purchase.price = String(describing: product.price)
            purchase.token = user.token
            
            let index = product.priceLocale.identifier.index(product.priceLocale.identifier.endIndex, offsetBy: -3);
            purchase.currency = product.priceLocale.identifier.substring(from: index);
            
            purchase.applicationUsername = String(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 100000)
            
            self.purchaseSuccess = purchaseSuccess
            self.purchaseFailure = purchaseFailure
            
            // 启动支付
            IAPHelper.current.purchase(productIdentifier: productId, applicationUsername: purchase.applicationUsername)
        }else{
            IAPHelper.current.requestProducts(productIdentifiers: productId, completionHandler: { (success:Bool) in
                if success{
                    if let product = IAPHelper.current.getProduct(productIdentifer: productId){
                        let formatter = NumberFormatter()
                        formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
                        formatter.numberStyle = NumberFormatter.Style.currency
                        formatter.locale = product.priceLocale
                        
                        self.purchase.roleId = roleId
                        self.purchase.productIdentifier = productId
                        self.purchase.extra = extra
                        self.purchase.serverId = serverId
                        self.purchase.price = String(describing: product.price)
                        let index = product.priceLocale.identifier.index((product.priceLocale.identifier.endIndex), offsetBy: -3);
                        self.purchase.currency = (product.priceLocale.identifier.substring(from: index));
                        self.purchase.applicationUsername = String(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 100000)
                        self.purchase.token = user.token
                        
                        self.purchaseSuccess = purchaseSuccess
                        self.purchaseFailure = purchaseFailure
                        
                        // 启动支付
                        IAPHelper.current.purchase(productIdentifier: productId, applicationUsername: self.purchase.applicationUsername)
                    }
                }else{
                    purchaseFailure(productId)
                }
            })
        }
    }
    
    func purchasedComplete(_ success: Bool, _ productIdentifier: ProductIdentifier, _ applicationUsername: String,
                           _ transactionIdentifier: String, _ receipt: String) {
        if success {
            // 补全交易信息，重新存储
            purchase.transactionIdentifier = transactionIdentifier
            purchase.receipt = receipt
            
            let app = AppModel()
            app.load()
            let req: [String : Any] = [
                "transactionId" : purchase.transactionIdentifier,
                "productId": purchase.productIdentifier,
                "receipt" : receipt,
                "gameRoleId": purchase.roleId,
                "cparam": purchase.extra,
                "price": purchase.price,
                "currencyCode": purchase.currency,
                "serverId": purchase.serverId
            ]
            
            Log("verify: \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
            MyNetwork.current.post(app.serverUrl + "/api/pay/apple", ["Authorization" : "Bearer \(purchase.token)"], req, { code, result in
                
                let order: String = (result["order"] as? String) ?? ""
                // 成功清除数据，失败也清除数据，因为失败了说明数据有问题，没有再存储的必要了
                
                if code == 200 {
                    Log("verify: ok, \(self.purchase.transactionIdentifier) \(self.purchase.productIdentifier) \(order)")
                    self.purchase.productIdentifier = ""
                    self.purchaseSuccess?(productIdentifier, order)
                    self.purchaseSuccess = nil
                    self.purchaseFailure = nil
                } else {
                    Log("verify: fail, \(self.purchase.transactionIdentifier) \(self.purchase.productIdentifier) \(code)")
                    self.purchase.productIdentifier = ""
                    self.purchaseFailure?(productIdentifier)
                    self.purchaseSuccess = nil
                    self.purchaseFailure = nil
                }
            }, {
                Log("verify: network error, \(self.purchase.transactionIdentifier) \(self.purchase.productIdentifier)")
                self.purchase.save()
                self.purchase.productIdentifier = ""
                self.purchaseFailure?(productIdentifier)
                self.purchaseSuccess = nil
                self.purchaseFailure = nil
            })
        } else {
            Log("verify: purchase fail, \(transactionIdentifier) \(productIdentifier)")
            self.purchase.productIdentifier = ""
            self.purchaseFailure?(productIdentifier)
            self.purchaseSuccess = nil
            self.purchaseFailure = nil
        }
    }
}
