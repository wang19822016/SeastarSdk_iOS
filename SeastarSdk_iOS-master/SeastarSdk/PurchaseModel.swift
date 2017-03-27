//
//  PurchaseModel.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/10/21.
//
//

import Foundation

struct PurchaseModel {
    private let PURCHASE_MODEL_NAME = "purchases"
    
    var roleId: String = ""
    
    var productIdentifier: String = ""
    // 可以存放附加数据，在充值成功后会推送给充值服务器
    var extra: String = ""
    // 存储每笔订单的标志
    var applicationUsername: String = ""
    var transactionIdentifier: String = ""
    var receipt: String = ""
//    var userId: Int = 0
    var token: String = ""
    var price: String = ""
    var currency: String = ""
    var serverId: String = ""
    
    func save() {
        var purchases = UserDefaults.standard.dictionary(forKey: PURCHASE_MODEL_NAME) ?? [String : Any]()
        
        var purchase: [ String : Any ] = [:]
        purchase["roleId"] = roleId
        purchase["productIdentifier"] = productIdentifier
        purchase["extra"] = extra
        purchase["applicationUsername"] = applicationUsername
        purchase["transactionIdentifier"] = transactionIdentifier
        purchase["receipt"] = receipt
//        purchase["userId"] = userId
        purchase["token"] = token
        purchase["price"] = price
        purchase["currency"] = currency
        purchase["serverId"] = serverId
        
        purchases[applicationUsername] = purchase
        
        UserDefaults.standard.set(purchases, forKey: PURCHASE_MODEL_NAME)
        UserDefaults.standard.synchronize()
    }
    
    mutating func load(applicationUsername: String) -> Bool {
        if let purchases = UserDefaults.standard.dictionary(forKey: PURCHASE_MODEL_NAME) {
            if let purchase = (purchases[applicationUsername] as? [String : Any]) {
                roleId = (purchase["roleId"] as? String) ?? ""
                productIdentifier = (purchase["productIdentifier"] as? String) ?? ""
                extra = (purchase["extra"] as? String) ?? ""
                self.applicationUsername = (purchase["applicationUsername"] as? String) ?? ""
                transactionIdentifier = (purchase["transactionIdentifier"] as? String) ?? ""
                receipt = (purchase["receipt"] as? String) ?? ""
//                userId = (purchase["userId"] as? Int) ?? 0
                token = (purchase["token"] as? String) ?? ""
                price = (purchase["price"] as? String) ?? ""
                currency = (purchase["currency"] as? String) ?? ""
                serverId = (purchase["serverId"] as? String) ?? ""
                
                return true
            }
        }
        
        return false
    }
    
    func remove() {
        if let purchases = UserDefaults.standard.dictionary(forKey: PURCHASE_MODEL_NAME) {
            if purchases[applicationUsername] != nil {
                var tempPurchases = purchases
                tempPurchases.removeValue(forKey: applicationUsername)
                UserDefaults.standard.set(tempPurchases, forKey: PURCHASE_MODEL_NAME)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    static func remove(applicationUsername: String) {
        if let purchases = UserDefaults.standard.dictionary(forKey: "purchases") {
            if purchases[applicationUsername] != nil {
                var tempPurchases = purchases
                tempPurchases.removeValue(forKey: applicationUsername)
                UserDefaults.standard.set(tempPurchases, forKey: "purchases")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    static func loadAll() -> [PurchaseModel] {
        var purchaseArray: [PurchaseModel] = []
        if let purchases = UserDefaults.standard.dictionary(forKey: "purchases") {
            for (_, value) in purchases {
                if let purchase = (value as? [String : Any]) {
                    var model = PurchaseModel()
                    model.roleId = (purchase["roleId"] as? String) ?? ""
                    model.productIdentifier = (purchase["productIdentifier"] as? String) ?? ""
                    model.extra = (purchase["extra"] as? String) ?? ""
                    model.applicationUsername = (purchase["applicationUsername"] as? String) ?? ""
                    model.transactionIdentifier = (purchase["transactionIdentifier"] as? String) ?? ""
                    model.receipt = (purchase["receipt"] as? String) ?? ""
//                    model.userId = (purchase["userId"] as? Int) ?? 0
                    model.token = (purchase["token"] as? String) ?? ""
                    model.price = (purchase["price"] as? String) ?? ""
                    model.currency = (purchase["currency"] as? String) ?? ""
                    model.serverId = (purchase["serverId"] as? String) ?? ""
                    
                    purchaseArray.append(model)
                }
            }
        }
        
        return purchaseArray
    }
    
}
