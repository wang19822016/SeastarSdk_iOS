//
//  PayViewModel.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/10/25.
//
//

import Foundation

class PurchaseViewModel : IAPHelperDelegate {
    static let current = PurchaseViewModel()
    
    var productIdentifiers: Set<IAPHelper.ProductIdentifier> = Set<IAPHelper.ProductIdentifier>()
    
    init() {
        IAPHelper.current.addListener()
    }
    
    deinit {
        IAPHelper.current.removeListener()
    }
    
    // 如果失败，再请求一次
    func requestProducts(productIdentifiers: Set<IAPHelper.ProductIdentifier>) {
        self.productIdentifiers = productIdentifiers
        
        IAPHelper.current.requestProducts(productIdentifiers: self.productIdentifiers) { success in
            if !success {
                IAPHelper.current.requestProducts(productIdentifiers: self.productIdentifiers) { success in }
            }
        }
    }
    
    func sendLeakPurchase() {
        // 每次主动上传支付漏单
    }

    
    func doPurchase(productId: String, extra: String, purchaseSuccess: @escaping ()->Void, purchaseFailure: @escaping ()->Void) {
        let (success, user) = UserModel.loadCurrentUser()
        if !success || (user?.session.isEmpty)! {
            purchaseFailure()
            
            return
        }
        
        if let product = IAPHelper.current.getProduct(productIdentifer: productId) {
            // 有商品信息
            let formatter = NumberFormatter()
            formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.locale = product.priceLocale
            
            var purchase = PurchaseModel()
            purchase.productIdentifier = productId
            purchase.extra = extra
            purchase.session = (user?.session)!
            purchase.userId = (user?.userId)!
            purchase.price = formatter.string(from: product.price)!
            purchase.currency = product.priceLocale.identifier
            purchase.order = String(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 1000)
            purchase.save()
            
            // 启动支付
            IAPHelper.current.purchase(productIdentifier: productId, applicationUsername: purchase.order)
            return
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
                        purchase.productIdentifier = productId
                        purchase.extra = extra
                        purchase.session = (user?.session)!
                        purchase.userId = (user?.userId)!
                        purchase.price = formatter.string(from: product.price)!
                        purchase.currency = product.priceLocale.identifier
                        purchase.order = String(Date(timeIntervalSinceNow: 0).timeIntervalSince1970 * 1000)
                        purchase.save()
                        
                        // 启动支付
                        IAPHelper.current.purchase(productIdentifier: productId, applicationUsername: purchase.order)
                        return
                    }
                }
            }
        }
    }
    
    func purchasedComplete(_ success: Bool, _ productIdentifier: ProductIdentifier, _ applicationUsername: String) {
        let (success, purchase) = PurchaseModel.load(order: applicationUsername)
        if success {
            // 启动验证
        } else {
            // 支付失败
        }
    }
}
