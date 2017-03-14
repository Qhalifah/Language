//
//  UserLoginActivity.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class UserLoginActivityModel{

    var userloginactivity_loaded = false
    var userloginactivity_timestamp: Int64 = 0
    var userloginactivity_uploaded = false
    var userloginactivity_user = UserModel()
    var userloginactivity_valid = false

    func getObject() -> [String: AnyObject]
    {
        var resultObject: [String: AnyObject] = [:]
        resultObject[Constants.KEY_USER_LOGINACTIVITY_LOADED] = self.userloginactivity_loaded as AnyObject?
        resultObject[Constants.KEY_USER_LOGINACTIVITY_TIMESTAMP] = self.userloginactivity_timestamp as AnyObject?
        resultObject[Constants.KEY_USER_LOGINACTIVITY_UPLOADED] = self.userloginactivity_uploaded as AnyObject?
        resultObject[Constants.KEY_USER_LOGINACTIVITY_USER] = self.userloginactivity_user.getObject() as AnyObject?
        resultObject[Constants.KEY_USER_LOGINACTIVITY_VALID] = self.userloginactivity_valid as AnyObject?
        return resultObject
    }
    
    static let localTableName = Constants.DIRECTORY_LOGIN_HISTORY
    static let localTablePrimaryKey = Constants.KEY_USER_LOGINACTIVITY_TIMESTAMP
    static let localTableString = [Constants.KEY_USER_UID: "TEXT",
                                   Constants.KEY_USER_LOGINACTIVITY_TIMESTAMP: "BIGINT",
                                   Constants.KEY_USER_LOGINACTIVITY_LOADED: "TINYINT",
                                   Constants.KEY_USER_LOGINACTIVITY_VALID: "TINYINT",
                                   Constants.KEY_USER_LOGINACTIVITY_UPLOADED: "TINYINT"]
    
    static func getModelFromData(object: AnyObject) -> UserLoginActivityModel
    {
        let loginActivity = UserLoginActivityModel()
        loginActivity.userloginactivity_loaded = object.value(forKey: Constants.KEY_USER_LOGINACTIVITY_LOADED) as! Bool
        loginActivity.userloginactivity_timestamp = object.value(forKey: Constants.KEY_USER_LOGINACTIVITY_TIMESTAMP) as! Int64
        loginActivity.userloginactivity_uploaded = object.value(forKey: Constants.KEY_USER_LOGINACTIVITY_UPLOADED) as! Bool
        loginActivity.userloginactivity_valid = object.value(forKey: Constants.KEY_USER_LOGINACTIVITY_VALID) as! Bool
        loginActivity.userloginactivity_user = currentUser
        return loginActivity
        
    }
    
    
}
