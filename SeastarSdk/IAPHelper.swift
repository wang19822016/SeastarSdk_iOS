//
//  IapHelper.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/10/12.
//
// 首先使用requestProducts获取product
// 然后使用addPaymentListener设置监听
// 再使用purchase来支付

import Foundation
import StoreKit

class IAPHelper : NSObject {
    
    static let current = IAPHelper()
    
    typealias ProductIdentifier = String
    typealias PurchasedCompletionHandler = (_ success: Bool, _ product: SKProduct?) -> ()
    typealias RequestProductCompletionHandler = (_ success: Bool) -> ()
    typealias RestoreCompletionHandler = (_ success: Bool, _ products: SKProduct?) -> ()
    
    fileprivate var productsRequest: SKProductsRequest? = nil
    fileprivate var products: Dictionary<ProductIdentifier, SKProduct> = Dictionary<ProductIdentifier, SKProduct>()
    fileprivate var purchasedCompletionHandler: PurchasedCompletionHandler? = nil
    fileprivate var requestProductCompletionHandler: RequestProductCompletionHandler? = nil
    fileprivate var restoreCompletionHandler: RestoreCompletionHandler? = nil
    
    func requestProducts(productIdentifiers: Set<ProductIdentifier>, completionHandler: @escaping RequestProductCompletionHandler)  {
        if !productIdentifiers.isEmpty {
            requestProductCompletionHandler = completionHandler
            
            productsRequest?.cancel()
            productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productsRequest!.delegate = self
            productsRequest!.start()
        } else {
            completionHandler(true)
        }
    }
    
    func purchase(productIdentifier: ProductIdentifier, completionHandler: @escaping PurchasedCompletionHandler) {
        if products.isEmpty {
            completionHandler(false, nil)
        } else if let product = products[productIdentifier] {
            purchasedCompletionHandler = completionHandler
            
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            completionHandler(false, nil)
        }
    }
    
    func addPaymentListener() {
        SKPaymentQueue.default().add(self)
    }
    
    func removePaymentListener() {
        SKPaymentQueue.default().remove(self)
    }
    
    func restorePurchases(completionHandler: @escaping RestoreCompletionHandler) {
        restoreCompletionHandler = completionHandler
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
}

extension IAPHelper : SKProductsRequestDelegate {
    internal func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productsRequest = nil
        
        if response.products.count > 0 {
            for p in response.products {
                products[p.productIdentifier] = p
            }
            
            requestProductCompletionHandler?(true)
        } else {
            requestProductCompletionHandler?(false)
        }
        requestProductCompletionHandler = nil
    }
}

extension IAPHelper : SKPaymentTransactionObserver {
    internal func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .failed:
                fail(transaction: transaction)
            case .restored:
                restore(transaction: transaction)
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    // 有可能返回的是之前购买的product，所以这里不能使用purchase传入的productidentifier
    private func complete(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        
        if let trans = transaction.original {
            if let product = products[trans.payment.productIdentifier] {
                purchasedCompletionHandler?(true, product)
            } else {
                purchasedCompletionHandler?(false, nil)
            }
        } else {
            purchasedCompletionHandler?(false, nil)
        }
        
        purchasedCompletionHandler = nil
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        
        if let trans = transaction.original {
            if let product = products[trans.payment.productIdentifier] {
                restoreCompletionHandler?(true, product)
            } else {
                restoreCompletionHandler?(false, nil)
            }
        } else {
            restoreCompletionHandler?(false, nil)
        }
        
        restoreCompletionHandler = nil
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription)")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
        if let trans = transaction.original {
            if let product = products[trans.payment.productIdentifier] {
                purchasedCompletionHandler?(false, product)
            } else {
                purchasedCompletionHandler?(false, nil)
            }
        } else {
            purchasedCompletionHandler?(false, nil)
        }
        
        purchasedCompletionHandler = nil
    }
}
