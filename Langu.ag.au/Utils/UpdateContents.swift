//
//  UpdateContents.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation


class UpdateContents {

    var userid = ""
    var userEmail = ""
    var languageFrom = ""
    var languageTo = ""

    init(){

    }

    static func uploadExistingContent(){
        FMDBManager.uploadPendingContent(userid: currentUser.user_uid, userEmail: currentUser.user_email, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, completion: {
            success in
        })
    }

    static func updateUser()
    {
        FirebaseUtils.getUserFromDatabase(userid: currentUser.user_uid, completion: {
            success, user in
            currentUser = user
        })
        
    }

    static func updateFirebaseUser(user: UserModel, completion: @escaping() -> ())
    {
        fmdbManager.executeQuery("DELETE FROM \(UserActivityModel.localTableName)")
        UserAuthUtils.saveUserInfoToLocal(user: user)
        FirebaseUtils.insertOrUpdateUser(user: user, checkTimeStamp: true)
        FirebaseUtils.saveUserActivityLocally(userid: user.user_uid, languageFrom: user.user_languagefrom, languageTo: user.user_languageto, completion: {
            _ in
            completion()
        })
    }
    
    static func uploadPendingFavoriteItems(completion : @escaping() -> ()){
        let objects = GetDataFromFMDBManager.getPendingFavorites(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
        if objects.count == 0{
            completion()
        }
        else{
            var completed = 0
            for object in objects{
                let codeId = object.value(forKey: "codeId") as! String
                let isFavorite = object.value(forKey: "isFavorite") as! Bool
                if isFavorite{
                    FirebaseUtils.addFavorite(userid: currentUser.user_uid, favorite: codeId, completion: {
                        success in
                        
                        if success{
                            FMDBManagerSetData.setFavoriteItemUploaded(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, codeId: codeId)
                        }
                        
                        completed += 1
                        if completed == objects.count{
                            completion()
                        }
                    })
                }
                else{
                    FirebaseUtils.removeFavorite(userid: currentUser.user_uid, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, code: codeId, completion: {
                        success in
                        if success{
                            FMDBManagerSetData.setFavoriteItemUploaded(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, codeId: codeId)
                        }
                        
                        completed += 1
                        if completed == objects.count{
                            completion()
                        }
                    })
                }
            }
        }
    }


    
}
