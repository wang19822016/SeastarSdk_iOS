//
//  PurchaseModel.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/10/21.
//
//

import Foundation

struct PurchaseModel {
    private static let PURCHASE_MODEL_NAME = "purchases"
    
    var productIdentifier: String = ""
    // 可以存放附加数据，在充值成功后会推送给充值服务器
    var extra: String = ""
    // 订单号，跟服务器订单号无关，等于applicationUsername
    var order: String = ""
    var userId: Int = 0
    var session: String = ""
    var price: String = ""
    var currency: String = ""
    
    func save() {
        var purchases = UserDefaults.standard.dictionary(forKey: PurchaseModel.PURCHASE_MODEL_NAME) ?? [String : Any]()
        
        var purchase: [ String : Any ] = [:]
        purchase["productIdentifier"] = productIdentifier
        purchase["extra"] = extra
        purchase["order"] = order
        purchase["userId"] = userId
        purchase["session"] = session
        purchase["price"] = price
        purchase["currency"] = currency
        
        purchases[order] = purchase
        
        UserDefaults.standard.set(purchases, forKey: PurchaseModel.PURCHASE_MODEL_NAME)
        UserDefaults.standard.synchronize()
    }
    
    static func load(order: String) -> (Bool, PurchaseModel?) {
        if let purchases = UserDefaults.standard.dictionary(forKey: PurchaseModel.PURCHASE_MODEL_NAME) {
            if let purchase = (purchases[order] as? [String : Any]) {
                var model = PurchaseModel()
                model.productIdentifier = (purchase["productIdentifier"] as? String) ?? ""
                model.extra = (purchase["extra"] as? String) ?? ""
                model.order = (purchase["order"] as? String) ?? ""
                model.userId = (purchase["userId"] as? Int) ?? 0
                model.session = (purchase["session"] as? String) ?? ""
                model.price = (purchase["price"] as? String) ?? ""
                model.currency = (purchase["currency"] as? String) ?? ""
                
                return (true, model)
            }
        }
        
        return (false, nil)
    }
    
}
