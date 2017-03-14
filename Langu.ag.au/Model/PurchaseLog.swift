//
//  PurchaseLog.swift
//  Langu.ag
//
//  Created by Big Shark on 17/02/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import Foundation

class PurchaseLog{
    
    static let localTableName = Constants.DIRECTORY_PURCHASE_LOG
    static let localPrimaryKey = Constants.KEY_PURCHASELOG_ID
    static let localTableString = [Constants.KEY_PURCHASELOG_ERROR: "TEXT",
                                   Constants.KEY_PURCHASELOG_ERRORCODE: "INT",
                                   Constants.KEY_PURCHASELOG_ID: "INT",
                                   Constants.KEY_PURCHASELOG_LANGUAGE: "INT",
                                   Constants.KEY_PURCHASELOG_LOADED: "TINYINT",
                                   Constants.KEY_PURCHASELOG_PRODUCTID: "TEXT",
                                   Constants.KEY_PURCHASELOG_TIMESTAMP: "TEXT",
                                   Constants.KEY_PURCHASELOG_UPLOADED: "TEXT",
                                   Constants.KEY_PURCHASELOG_USERID: "TEXT",
                                   Constants.KEY_PURCHASELOG_USERID: "TEXT"]
}
