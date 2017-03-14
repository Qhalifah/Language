//
//  UserUtils.swift
//  Langu.ag
//
//  Created by Huijing on 15/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase



class UserAuthUtils
{

    static let userDefault = UserDefaults.standard

    static func setDataFromUserDefault() -> Bool{

        guard let user_id = userDefault.value(forKey: Constants.USER_ID) else {
            return false
        }
        currentUser.user_uid = user_id as! String
        guard let user_email = userDefault.value(forKey: Constants.USER_EMAIL) else{
            return false
        }
        currentUser.user_email = user_email as! String
        guard let user_password = userDefault.value(forKey: Constants.USER_PASSWORD) else{
            return false
        }
        currentUser.user_password = user_password as! String
        guard let user_languageFrom = userDefault.value(forKey: Constants.USER_LANGUAGEFROM) else{
            return true
        }
        currentUser.user_languagefrom = user_languageFrom as! String
        guard let user_languageTo = userDefault.value(forKey: Constants.USER_LANGUAGETO) else{
            return true
        }
        currentUser.user_languageto = user_languageTo as! String
        guard let user_displayName = userDefault.value(forKey: Constants.KEY_USER_DISPLAYNAME) else
        {
            return true
        }

        currentUser.user_displayname = user_displayName as! String
        guard let user_photoUrl = userDefault.value(forKey: Constants.KEY_USER_PHOTOURL) else
        {
            return true
        }
        currentUser.user_photourl = user_photoUrl as! String

        return true


    }


    static func removeUserInfo(){

        currentUser = UserModel()
        userDefault.removeObject(forKey: Constants.USER_ID)
        userDefault.removeObject(forKey: Constants.USER_EMAIL)
        userDefault.removeObject(forKey: Constants.USER_PASSWORD)
        userDefault.removeObject(forKey: Constants.USER_LANGUAGEFROM)
        userDefault.removeObject(forKey: Constants.USER_LANGUAGETO)
    }

    static func saveUserInfoToLocal(user: UserModel){

        userDefault.set(user.user_uid, forKey: Constants.USER_ID)
        userDefault.set(user.user_email, forKey: Constants.USER_EMAIL)
        userDefault.set(user.user_password, forKey: Constants.USER_PASSWORD)
        userDefault.set(user.user_languagefrom, forKey: Constants.USER_LANGUAGEFROM)
        userDefault.set(user.user_languageto, forKey: Constants.USER_LANGUAGETO)
        userDefault.set(user.user_displayname, forKey: Constants.KEY_USER_DISPLAYNAME)
        userDefault.set(user.user_photourl, forKey: Constants.KEY_USER_PHOTOURL)
        
    }
}
