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

typealias ProductIdentifier = String

protocol IAPHelperDelegate {
    func purchasedComplete(_ success: Bool, _ productIdentifier: ProductIdentifier, _ applicationUsername: String, _ transactionIdentifier: String, _ receipt: String)
    //func restoreComplete(_ success: Bool)
}

class IAPHelper : NSObject {
    
    static let current = IAPHelper()
    
    typealias ProductIdentifier = String
    typealias RequestProductCompletionHandler = (_ success: Bool) -> ()
    
    var delegate: IAPHelperDelegate? = nil
    
    fileprivate var productsRequest: SKProductsRequest? = nil
    fileprivate var products: Dictionary<ProductIdentifier, SKProduct> = Dictionary<ProductIdentifier, SKProduct>()
    fileprivate var requestProductCompletionHandler: RequestProductCompletionHandler? = nil
    
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
    
    func purchase(productIdentifier: ProductIdentifier, applicationUsername: String) {
        if let product = products[productIdentifier] {
            
            let payment = SKMutablePayment(product: product)
            payment.applicationUsername = applicationUsername
            SKPaymentQueue.default().add(payment)
        } else {
            delegate?.purchasedComplete(false, productIdentifier, applicationUsername, "", "")
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func addListener() {
        SKPaymentQueue.default().add(self)
    }
    
    func removeListener() {
        SKPaymentQueue.default().remove(self)
    }
    
    func getProduct(productIdentifer: ProductIdentifier) -> SKProduct? {
        return products[productIdentifer]
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
        
        let productId = transaction.payment.productIdentifier
        if let receiptURL = Bundle.main.appStoreReceiptURL {
            if let receiptData = try? Data(contentsOf: receiptURL) {
                let receipt = receiptData.base64EncodedString(options: .endLineWithLineFeed)
                if let applicationUsername = transaction.payment.applicationUsername {
                    delegate?.purchasedComplete(true, productId, applicationUsername, transaction.transactionIdentifier!, receipt)
                    return
                }
            }
        }
        
        delegate?.purchasedComplete(true, productId, "", "", "")
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        
        //if transaction.original != nil {
        //    delegate?.restoreComplete(true)
        //} else {
        //    delegate?.restoreComplete(false)
        //}
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                Log("Transaction Error: \(transaction.error?.localizedDescription)")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
        let productId = transaction.payment.productIdentifier
        if let applicationUsername = transaction.payment.applicationUsername {
            delegate?.purchasedComplete(false, productId, applicationUsername, "", "")
        } else {
            delegate?.purchasedComplete(false, productId, "", "", "")
        }
    }
}
