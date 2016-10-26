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
    
    var productIdentifiers: Set<IAPHelper.ProductIdentifier> = Set<IAPHelper.ProductIdentifier>()
    var purchaseSuccess: SuccessCB? = nil
    var purchaseFailure: FailureCB? = nil
    
    func initialize() {
        IAPHelper.current.addListener()
    }
    
    func destroy() {
        IAPHelper.current.removeListener()
    }
    
    // 如果失败，再请求一次
    func requestProducts(productIdentifiers: Set<IAPHelper.ProductIdentifier>) {
        self.productIdentifiers = productIdentifiers
        
        IAPHelper.current.requestProducts(productIdentifiers: self.productIdentifiers) { success in
            if !success {
                Log("request product fail, retry.")
                IAPHelper.current.requestProducts(productIdentifiers: self.productIdentifiers) { success in }
            }
        }
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
                    "appId" : app.appId,
                    "userId" : purchase.userId,
                    "appleOrder" : purchase.transactionIdentifier,
                    "session" : purchase.session,
                    "productId": purchase.productIdentifier,
                    "receipt" : purchase.receipt,
                    "gameRoleId": purchase.roleId,
                    "cparam": purchase.extra,
                    "price": purchase.price,
                    "currencyCode": purchase.currency
                ]
                
                Log("verify: userId:\(purchase.userId) appleOrder: \(purchase.transactionIdentifier) session:\(purchase.session) productId:\(purchase.productIdentifier)")
                Network.post(url: app.serverUrl, json: req, success: { result in
                    // 验证成功，清除数据
                    purchase.remove()
                    Log("verify: \(result["code"]) \(result["order"]) \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                    }, failure: {
                        Log("verify: network error \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                })
            }
        }
    }

    
    func doPurchase(productId: String, roleId: String, extra: String, purchaseSuccess: @escaping SuccessCB, purchaseFailure: @escaping FailureCB) {
        let user = UserModel()
        if user.loadCurrentUser() {
            purchaseFailure(productId)
            
            return
        }
        
        let extraData = extra.data(using: .utf8)!
        let extraB64String = extraData.base64EncodedString(options: .endLineWithLineFeed)
        
        if let product = IAPHelper.current.getProduct(productIdentifer: productId) {
            // 有商品信息
            let formatter = NumberFormatter()
            formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.locale = product.priceLocale
            
            var purchase = PurchaseModel()
            purchase.roleId = roleId
            purchase.productIdentifier = productId
            purchase.extra = extraB64String
            purchase.session = user.session
            purchase.userId = user.userId
            purchase.price = formatter.string(from: product.price)!
            purchase.currency = product.priceLocale.identifier
            purchase.applicationUsername = String(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 1000)
            purchase.save()
            
            self.purchaseSuccess = purchaseSuccess
            self.purchaseFailure = purchaseFailure
            
            // 启动支付
            IAPHelper.current.purchase(productIdentifier: productId, applicationUsername: purchase.applicationUsername)
        } else {
            IAPHelper.current.requestProducts(productIdentifiers: self.productIdentifiers) { success in
                if success {
                    if let product = IAPHelper.current.getProduct(productIdentifer: productId) {
                        // 有商品信息
                        let formatter = NumberFormatter()
                        formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
                        formatter.numberStyle = NumberFormatter.Style.currency
                        formatter.locale = product.priceLocale
                        
                        var purchase = PurchaseModel()
                        purchase.roleId = roleId
                        purchase.productIdentifier = productId
                        purchase.extra = extraB64String
                        purchase.session = user.session
                        purchase.userId = user.userId
                        purchase.price = formatter.string(from: product.price)!
                        purchase.currency = product.priceLocale.identifier
                        purchase.applicationUsername = String(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 1000)
                        purchase.save()
                        
                        self.purchaseSuccess = purchaseSuccess
                        self.purchaseFailure = purchaseFailure
                        
                        // 启动支付
                        IAPHelper.current.purchase(productIdentifier: productId, applicationUsername: purchase.applicationUsername)
                    } else {
                        purchaseFailure(productId)
                    }
                } else {
                    purchaseFailure(productId)
                }
            }
        }
    }
    
    func purchasedComplete(_ success: Bool, _ productIdentifier: ProductIdentifier, _ applicationUsername: String,
                           _ transactionIdentifier: String, _ receipt: String) {
        if success {
            if !applicationUsername.isEmpty {
                var purchase = PurchaseModel()
                if purchase.load(applicationUsername: applicationUsername) {
                    
                    // 补全交易信息，重新存储
                    purchase.transactionIdentifier = transactionIdentifier
                    purchase.receipt = receipt
                    purchase.save()
                    
                    let app = AppModel()
                    if app.load() {
                        let req: [String : Any] = [
                            "appId" : app.appId,
                            "userId" : purchase.userId,
                            "appleOrder" : purchase.transactionIdentifier,
                            "session" : purchase.session,
                            "productId": purchase.productIdentifier,
                            "receipt" : receipt,
                            "gameRoleId": purchase.roleId,
                            "cparam": purchase.extra,
                            "price": purchase.price,
                            "currencyCode": purchase.currency
                        ]
                        
                        Log("verify: \(purchase.userId) \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                        Network.post(url: app.serverUrl, json: req, success: { result in
                            let code: Int = (result["code"] as? Int) ?? 0
                            let order: String = (result["order"] as? String) ?? ""
                            // 成功清除数据，失败也清除数据，因为失败了说明数据有问题，没有再存储的必要了
                            purchase.remove()
                            
                            if code == 1 {
                                Log("verify: ok, \(purchase.transactionIdentifier) \(purchase.productIdentifier) \(order)")
                                self.purchaseSuccess?(productIdentifier, order)
                                self.purchaseSuccess = nil
                                self.purchaseFailure = nil
                            } else {
                                Log("verify: fail, \(purchase.transactionIdentifier) \(purchase.productIdentifier) \(code)")
                                self.purchaseFailure?(productIdentifier)
                                self.purchaseSuccess = nil
                                self.purchaseFailure = nil
                            }
                            }, failure: {
                                Log("verify: network error, \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                                self.purchaseFailure?(productIdentifier)
                                self.purchaseSuccess = nil
                                self.purchaseFailure = nil
                        })
                    } else {
                        // app信息加载失败
                        Log("verify: no app config, \(purchase.transactionIdentifier) \(purchase.productIdentifier)")
                        self.purchaseFailure?(productIdentifier)
                        self.purchaseSuccess = nil
                        self.purchaseFailure = nil
                    }
                } else {
                    // 支付信息加载失败
                    Log("verify: no purchase with applicationUsername, \(transactionIdentifier) \(productIdentifier)")
                    self.purchaseFailure?(productIdentifier)
                    self.purchaseSuccess = nil
                    self.purchaseFailure = nil
                }
            } else {
                // 支付返回的信息缺少
                Log("verify: no applicationUsername, \(transactionIdentifier) \(productIdentifier)")
                self.purchaseFailure?(productIdentifier)
                self.purchaseSuccess = nil
                self.purchaseFailure = nil
            }
        } else {
            if !applicationUsername.isEmpty {
                PurchaseModel.remove(applicationUsername: applicationUsername)
            }
            Log("verify: purchase fail, \(transactionIdentifier) \(productIdentifier)")
            self.purchaseFailure?(productIdentifier)
            self.purchaseFailure?(productIdentifier)
            self.purchaseSuccess = nil
            self.purchaseFailure = nil
        }
    }
}
