//
//  LanguageModel.swift
//  Langu.ag
//
//  Created by Huijing on 19/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation


class UserLanguageModel{

    var language_name = ""
    var language_imagename = ""
    var language_free = false
    var language_shortname = ""
    var language_storename = ""
    var language_migratedlanguage = false
    var language_loaded = false
    var language_uploaded = false
    var language_valid = false
    var language_purchasetime : Int64 = 0
    
    
    static let localTableName = Constants.DIRECTORY_USER_LANGUAGES
    static let localPrimaryKey = Constants.KEY_PURCHASE_TIME
    static let localTableString = [Constants.KEY_LANGUAGE_ISFREE: "TINYINT",
                                   Constants.KEY_LANGUAGE_NAME: "TEXT",
                                   Constants.KEY_LANGUAGE_SHORTNAME: "TEXT",
                                   Constants.KEY_LANGUAGE_LOADED: "TINYINT",
                                   Constants.KEY_LANGUAGE_MIGRATEDLANGUAGE: "TINYINT",
                                   Constants.KEY_LANGUAGE_STORENAME: "TEXT",
                                   Constants.KEY_LANGUAGE_UPLOADED: "TINYINT",
                                   Constants.KEY_LANGUAGE_VALID: "TINYINT",
                                   Constants.KEY_PURCHASE_TIME: "BIGINT"]
    
    func getObject() -> [String: AnyObject]{
        
        var result: [String: AnyObject] = [:]
        result[Constants.KEY_LANGUAGE_ISFREE] = language_free as AnyObject
        result[Constants.KEY_LANGUAGE_NAME] = language_name as AnyObject
        result[Constants.KEY_LANGUAGE_SHORTNAME] = language_shortname as AnyObject
        result[Constants.KEY_LANGUAGE_LOADED] = language_loaded as AnyObject
        result[Constants.KEY_LANGUAGE_MIGRATEDLANGUAGE] = language_migratedlanguage as AnyObject
        result[Constants.KEY_LANGUAGE_STORENAME] = language_storename as AnyObject
        result[Constants.KEY_LANGUAGE_UPLOADED] = language_uploaded as AnyObject
        result[Constants.KEY_LANGUAGE_VALID] = language_valid as AnyObject
        result[Constants.KEY_PURCHASE_TIME] = language_purchasetime as AnyObject
        NSLog("\(result)")
        return result
        
    }


}



