//
//  UserActivity.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class UserActivityModel{
    
    static let TABLE_NAME = "userAcitivity"
    
    
    static let TABLE_KEY_ID = "id"
    static let TABLE_PRIMARY_KEY = TABLE_KEY_ID
    //static let TABLE_KEY_LOADED = "loaded"
    static let TABLE_KEY_OBJECT_FROM = "objectFrom"
    static let TABLE_KEY_OBJECT_TO = "objectTo"
    static let TABLE_KEY_TIMESTAMP = "timestamp"
    static let TABLE_KEY_UPLOADED = "uploaded"
    static let TABLE_KEY_VALID = "valid"
    static let TABLE_KEY_VERB = "verb"
    
    static let localTableName = TABLE_NAME
    static let localTablePrimaryKey = TABLE_PRIMARY_KEY
    static let localTableString = [TABLE_KEY_ID: "TEXT",
                                   //TABLE_KEY_LOADED: "TINYINT",
                                   TABLE_KEY_OBJECT_FROM: "TEXT",
                                   TABLE_KEY_OBJECT_TO: "TEXT",
                                   TABLE_KEY_TIMESTAMP: "BIGINT",
                                   TABLE_KEY_UPLOADED: "TINYINT",
                                   TABLE_KEY_VALID: "TINYINT",
                                   TABLE_KEY_VERB: "TEXT"]
    

}
