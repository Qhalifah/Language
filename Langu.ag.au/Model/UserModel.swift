//
//  UserData.swift
//  Langu.ag
//
//  Created by Huijing on 19/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation



class UserModel{

    var user_admin = false
    var user_displayname = ""
    var user_email = ""
    var user_isAdmin = false
    var user_languagefrom = ""
    var user_languageto = ""
    var user_loaded = false
    var user_migrated = false
    var user_photourl = ""
    var user_provideid = "firebase"
    var user_uid = ""
    var user_updatetimestamp: Int64 = 0
    var user_valid = false
    var user_password = ""

    func getObject() -> [String: AnyObject] {
        var resultObject: [String: AnyObject] = [:]
        resultObject[Constants.KEY_USER_ADMIN] = self.user_admin as AnyObject?
        resultObject[Constants.KEY_USER_CURRENTVERSION] = ["versionCode": 0, "versionName":"0"] as AnyObject
        resultObject[Constants.KEY_USER_DISPLAYNAME] = self.user_displayname  as AnyObject?
        resultObject[Constants.KEY_USER_EMAIL] = self.user_email as AnyObject?
        resultObject[Constants.KEY_USER_ISADMIN] = self.user_isAdmin as AnyObject?
        resultObject[Constants.KEY_USER_LANGUAGEFROM] = self.user_languagefrom as AnyObject?
        resultObject[Constants.KEY_USER_LANGUAGETO] = self.user_languageto as AnyObject?
        resultObject[Constants.KEY_USER_LOADED] = self.user_loaded as AnyObject?
        resultObject[Constants.KEY_USER_MIGRATED] = self.user_migrated as AnyObject?
        resultObject[Constants.KEY_USER_PHOTOURL] = self.user_photourl as AnyObject?
        resultObject[Constants.KEY_USER_PROVIDEID] = self.user_provideid as AnyObject?
        resultObject[Constants.KEY_USER_UID] = self.user_uid as AnyObject?
        resultObject[Constants.KEY_USER_UPDATETIMESTAMP] = getGlobalTime() as AnyObject?
        resultObject[Constants.KEY_USER_VALID] = self.user_valid as AnyObject?
        return resultObject
    }


}


var currentUser = UserModel()
