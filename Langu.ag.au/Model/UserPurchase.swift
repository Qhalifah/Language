//
//  UserPurchase.swift
//  Langu.ag
//
//  Created by Big Shark on 17/02/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import Foundation

class UserPurchase{
    
    var purchase_amount = ""
    var purchase_loaded = true
    var purchase_orderId = ""
    var purchase_productId = "product id"
    var purchase_time : Int64 = 0
    var purchase_purchaseToken = "purchase token"
    var purchase_responseData = "response data"
    var purchase_signature = "signature"
    var purchase_uploaded = true
    var purchase_valid = false
    
    
    static let localTableName = Constants.KEY_LANGUAGE_USERPURCHASE
    static let localPrimaryKey = Constants.KEY_PURCHASE_TIME
    static let localTableString = [Constants.KEY_PURCHASE_AMOUNT: "TEXT",
                                   Constants.KEY_PURCHASE_LOADED: "TINYINT",
                                   Constants.KEY_PURCHASE_ORDERID: "TEXT",
                                   Constants.KEY_PURCHASE_PRODUCTID: "TEXT",
                                   Constants.KEY_PURCHASE_TIME: "BIGINT",
                                   Constants.KEY_PURCHASE_TOKEN: "TEXT",
                                   Constants.KEY_PURCHASE_RESPONSEDATA: "TEXT",
                                   Constants.KEY_PURCHASE_SIGNATURE: "TEXT",
                                   Constants.KEY_PURCHASE_UPLOADED: "TINYINT",
                                   Constants.KEY_PURCHASE_VALID: "TINYINT"]
    
    func getObject() -> [String: AnyObject]{
        var result : [String: AnyObject] = [:]
        result[Constants.KEY_PURCHASE_AMOUNT] = purchase_amount as AnyObject
        result[Constants.KEY_PURCHASE_LOADED] = purchase_loaded as AnyObject
        result[Constants.KEY_PURCHASE_ORDERID] = purchase_orderId as AnyObject
        result[Constants.KEY_PURCHASE_PRODUCTID] = purchase_productId as AnyObject
        result[Constants.KEY_PURCHASE_TOKEN] = purchase_purchaseToken as AnyObject
        result[Constants.KEY_PURCHASE_RESPONSEDATA] = purchase_responseData as AnyObject
        result[Constants.KEY_PURCHASE_SIGNATURE] = purchase_signature as AnyObject
        result[Constants.KEY_PURCHASE_UPLOADED] = purchase_uploaded as AnyObject
        result[Constants.KEY_PURCHASE_TIME] = purchase_time as AnyObject
        result[Constants.KEY_PURCHASE_VALID] = purchase_valid as AnyObject
        NSLog("\(result)")
        return result
    }
}
