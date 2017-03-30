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
    
    var curPurchase = PurchaseModel()
    
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
        let purchases = PurchaseModel.loadAll()
        for purchase in purchases {
            purchase.remove()
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
                    Log("verify: \(code) \(resposne["order"]) \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                }, {
                    Log("verify: network error \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                })
            }
        }
    }
    
    
    func doPurchase(productId: String, roleId: String, serverId: String, extra: String, purchaseSuccess: @escaping SuccessCB, purchaseFailure: @escaping FailureCB) {
        var user = UserModel()
        if !user.loadCurrentUser() || !curPurchase.applicationUsername.isEmpty {
            purchaseFailure(productId)
            return
        }
        
        if let product = IAPHelper.current.getProduct(productIdentifer: productId) {
            //有商品信息
            let formatter = NumberFormatter()
            formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.locale = product.priceLocale
            
            curPurchase.roleId = roleId
            curPurchase.productIdentifier = productId
            curPurchase.extra = extra;
            curPurchase.token = user.token

            curPurchase.serverId = serverId
            curPurchase.price = String(describing: product.price)
            curPurchase.token = user.token
            
            let index = product.priceLocale.identifier.index(product.priceLocale.identifier.endIndex, offsetBy: -3);
            curPurchase.currency = product.priceLocale.identifier.substring(from: index);
            
            curPurchase.applicationUsername = String(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 100000)
            
            self.purchaseSuccess = purchaseSuccess
            self.purchaseFailure = purchaseFailure
            
            // 启动支付
            IAPHelper.current.purchase(productIdentifier: productId, applicationUsername: curPurchase.applicationUsername)
        }else{
            IAPHelper.current.requestProducts(productIdentifiers: productId, completionHandler: { (success:Bool) in
                if success{
                    if let product = IAPHelper.current.getProduct(productIdentifer: productId){
                        let formatter = NumberFormatter()
                        formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
                        formatter.numberStyle = NumberFormatter.Style.currency
                        formatter.locale = product.priceLocale

                        self.curPurchase.roleId = roleId
                        self.curPurchase.productIdentifier = productId
                        self.curPurchase.extra = extra
                        self.curPurchase.token = user.token
                        self.curPurchase.serverId = serverId
                        self.curPurchase.price = String(describing: product.price)

                        let index = product.priceLocale.identifier.index((product.priceLocale.identifier.endIndex), offsetBy: -3);
                        self.curPurchase.currency = (product.priceLocale.identifier.substring(from: index));
                        self.curPurchase.applicationUsername = String(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 100000)
                        self.curPurchase.token = user.token
                        
                        self.purchaseSuccess = purchaseSuccess
                        self.purchaseFailure = purchaseFailure
                        
                        // 启动支付
                        IAPHelper.current.purchase(productIdentifier: productId, applicationUsername: self.curPurchase.applicationUsername)
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
            curPurchase.transactionIdentifier = transactionIdentifier
            curPurchase.receipt = receipt
            
            let app = AppModel()
            let req: [String : Any] = [
                "transactionId" : curPurchase.transactionIdentifier,
                "productId": curPurchase.productIdentifier,
                "receipt" : receipt,
                "gameRoleId": curPurchase.roleId,
                "cparam": curPurchase.extra,
                "price": curPurchase.price,
                "currencyCode": curPurchase.currency,
                "serverId": curPurchase.serverId
            ]
            
            Log("verify: \(curPurchase.transactionIdentifier) \(curPurchase.productIdentifier)")
            MyNetwork.current.post(app.serverUrl + "/api/pay/apple", ["Authorization" : "Bearer \(curPurchase.token)"], req, { code, result in
                self.curPurchase.applicationUsername = ""
                let order: String = (result["order"] as? String) ?? ""
                if code == 200 {
                    Log("verify: ok, \(self.curPurchase.transactionIdentifier) \(self.curPurchase.productIdentifier) \(order)")
                    self.purchaseSuccess?(productIdentifier, order)
                    self.purchaseSuccess = nil
                    self.purchaseFailure = nil
                } else {
                    Log("verify: fail, \(self.curPurchase.transactionIdentifier) \(self.curPurchase.productIdentifier) \(code)")
                    self.purchaseFailure?(productIdentifier)
                    self.purchaseSuccess = nil
                    self.purchaseFailure = nil
                }
            }, {
                Log("verify: network error, \(self.curPurchase.transactionIdentifier) \(self.curPurchase.productIdentifier)")
                self.curPurchase.save()
                self.curPurchase.applicationUsername = ""
                self.purchaseFailure?(productIdentifier)
                self.purchaseSuccess = nil
                self.purchaseFailure = nil
            })
        } else {
            Log("verify: purchase fail, \(transactionIdentifier) \(productIdentifier)")
            self.curPurchase.applicationUsername = ""
            self.purchaseFailure?(productIdentifier)
            self.purchaseSuccess = nil
            self.purchaseFailure = nil
        }
    }
}
