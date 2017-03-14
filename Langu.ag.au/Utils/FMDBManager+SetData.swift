//
//  FMDBManager+SetData.swift
//  Langu.ag
//
//  Created by Huijing on 10/01/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import Foundation

class FMDBManagerSetData{

    static func updateLangItems(item: AnyObject, completion: @escaping () -> ()){
        var tableData : [String: AnyObject] = [:]

        for key in LanguItem.localTableString.keys{
            tableData[key] = item.value(forKey: key) as AnyObject!
        }
        fmdbManager.UpdateRecord(tableObject: LanguItem.localTableString, tableName: LanguItem.localTableName, tableData: tableData, matchKeys: [Constants.KEY_LESSON_CODEID, Constants.KEY_USER_LANGUAGEFROM, Constants.KEY_USER_LANGUAGETO, Constants.KEY_LANGITEM_TYPE])
        
        let activityData = getUserActivityObject(item: item)
        let codeId = item.value(forKey: Constants.KEY_LESSON_CODEID) as! String
        let lessonId = GetDataFromFMDBManager.getLessonFrom(codeId: codeId)
        if GetDataFromFMDBManager.isLessonCompleted(lessonId: lessonId){
            
        }
        
        fmdbManager.insertRecord(tableObject: UserActivityModel.localTableString, tableName: UserActivityModel.localTableName, tableData: activityData, primaryKey: UserActivityModel.localTablePrimaryKey)
        uploadUserActivities(completion: {
            completion()
            
        })
        
    }    
    
    //static func setUserActivityObjectFrom([[String: AnyObject]])
    
    static func getUserActivityObject(item: AnyObject) -> [String: AnyObject]
    {
        //this function works for standard item view and correct and wrong result
        var activityData: [String: AnyObject] = [:]
        //activityData[]
        //activityData[UserActivityModel.TABLE_KEY_OBJECT_FROM] =
        var codeId = item.value(forKey: Constants.KEY_LESSON_CODEID) as! String
        let languageFrom = item.value(forKey: Constants.KEY_USER_LANGUAGEFROM) as! String
        let languageTo = item.value(forKey: Constants.KEY_USER_LANGUAGETO) as! String
        var verb = ""
        var activityType = 0
        
        let itemType = item.value(forKey: Constants.KEY_LANGITEM_TYPE) as! Int
        let itemStatus = item.value(forKey: Constants.KEY_LANGITEM_STATUS) as! Int
        let itemViewed = item.value(forKey: Constants.KEY_LANGUAGEITEM_VIEWED) as! Bool
        
        let lessonId = GetDataFromFMDBManager.getLessonFrom(codeId: codeId)
        if itemType == Constants.VALUE_LANGUITEM_STANDARD
        {
            if itemViewed{
                verb = Constants.USER_ACTIVITY_VERB_VIEWED
            }
            else{
                verb = "UnViewed"
            }
            activityType = Constants.VALUE_ACTIVITY_ITEMVIEWED
        }
        else if itemType == Constants.VALUE_LANGUITEM_QUIZ{
            codeId = codeId + "_mcq_image_options"
            if itemStatus == Constants.VALUE_LANGUSTATUS_CORRECT{
                activityType = Constants.VALUE_ACTIVITY_CORRECT
                verb = Constants.USER_ACTIVITY_VERB_QUIZ_CORRECT
            }
            else{
                activityType = Constants.VALUE_ACTIVITY_WRONG
                verb = Constants.USER_ACTIVITY_VERB_QUIZ_WRONG
            }
        }
        else if itemType == Constants.VALUE_LANGUITEM_JUMBLE{
            codeId = codeId + "_jumbled"
            if itemStatus == Constants.VALUE_LANGUSTATUS_CORRECT{
                activityType = Constants.VALUE_ACTIVITY_CORRECT
                verb = Constants.USER_ACTIVITY_VERB_QUIZ_CORRECT
            }
            else{
                activityType = Constants.VALUE_ACTIVITY_WRONG
                verb = Constants.USER_ACTIVITY_VERB_QUIZ_WRONG
            }
        }
        
        
        let objectId =
            StringUtils.getUserActivityObjectId(languageFrom: languageFrom, languageTo: languageTo, verb: verb, lessonId: lessonId, code: codeId, activityType: activityType)
        
        activityData[UserActivityModel.TABLE_KEY_VERB] = verb as AnyObject
        activityData[UserActivityModel.TABLE_KEY_OBJECT_FROM] = objectId.0 as AnyObject
        activityData[UserActivityModel.TABLE_KEY_OBJECT_TO] = objectId.1 as AnyObject
        activityData[UserActivityModel.TABLE_KEY_ID] = objectId.2 as AnyObject
        activityData[UserActivityModel.TABLE_KEY_VALID] = false as AnyObject
        activityData[UserActivityModel.TABLE_KEY_TIMESTAMP] = getGlobalTime() as AnyObject
        activityData[UserActivityModel.TABLE_KEY_UPLOADED] = false as AnyObject
        return activityData
    }
    
    static func getLessonCompleteObject(languageFrom: String, languageTo: String, lessonId: String) -> [String: AnyObject]{
        let idObject = StringUtils.getUserActivityObjectId(languageFrom: languageFrom, languageTo: languageTo, verb: Constants.USER_ACTIVITY_VERB_COMPLETED, lessonId: lessonId, code: "", activityType: Constants.VALUE_ACTIVITY_LESSON_COMPLETED)
        var activityData: [String: AnyObject] = [:]
        activityData[UserActivityModel.TABLE_KEY_VERB] = Constants.USER_ACTIVITY_VERB_COMPLETED as AnyObject
        activityData[UserActivityModel.TABLE_KEY_OBJECT_FROM] = idObject.0 as AnyObject
        activityData[UserActivityModel.TABLE_KEY_OBJECT_TO] = idObject.1 as AnyObject
        activityData[UserActivityModel.TABLE_KEY_ID] = idObject.2 as AnyObject
        activityData[UserActivityModel.TABLE_KEY_VALID] = false as AnyObject
        activityData[UserActivityModel.TABLE_KEY_TIMESTAMP] = getGlobalTime() as AnyObject
        activityData[UserActivityModel.TABLE_KEY_UPLOADED] = false as AnyObject
        return activityData
        
    }
    
    
    static func insertLangItems(user: UserModel, itemType:Int, itemStatus: Int, itemViewed : Bool, lessonCodeId: String){
        var tableData : [String: AnyObject] = [:]
        //initialize table object information
        tableData[Constants.KEY_USER_LANGUAGEFROM] = user.user_languagefrom as AnyObject?
        tableData[Constants.KEY_USER_LANGUAGETO] = user.user_languageto as AnyObject?
        tableData[Constants.KEY_LANGITEM_TYPE] = itemType as AnyObject?
        tableData[Constants.KEY_LANGITEM_STATUS] = itemStatus as AnyObject?
        tableData[Constants.KEY_LANGUAGEITEM_VIEWED] = itemViewed as AnyObject?
        tableData[Constants.KEY_LESSON_CODEID] = lessonCodeId as AnyObject?
        fmdbManager.insertRecord(tableObject: LanguItem.localTableString, tableName: LanguItem.localTableName, tableData: tableData, primaryKey: LanguItem.localPrimaryKey)
        
        
    }
    
    //static func addItem
    
    static func refreshLessonData(lessonId: String, languageFrom : String, languageTo: String){
        let query = "DELETE FROM \(LanguItem.localTableName) WHERE \(Constants.KEY_USER_LANGUAGEFROM) = '\(languageFrom)' AND \(Constants.KEY_USER_LANGUAGETO) = '\(languageTo)' AND EXISTS(SELECT * FROM \(LanguageItemModel.localTableName) b WHERE b.\(Constants.KEY_LESSON_CODEID) = \(LanguItem.localTableName).\(Constants.KEY_LESSON_CODEID) AND b.\(Constants.KEY_LESSON_ID) = \(lessonId))"
        fmdbManager.executeQuery(query)
        //NSLog(query)
    }
    
    static func saveUserLoginActivity(loginActivity: UserLoginActivityModel){
        fmdbManager.insertRecord(tableObject: UserLoginActivityModel.localTableString, tableName: UserLoginActivityModel.localTableName, tableData: loginActivity.getObject(), primaryKey: UserLoginActivityModel.localTablePrimaryKey)
        
    }
    
    static func setActivitieUploaded(_ timestamp: Int64){
        fmdbManager.executeQuery("UPDATE \(UserLoginActivityModel.localTableName) SET \(Constants.KEY_USER_LOGINACTIVITY_UPLOADED) = 1 WHERE \(Constants.KEY_USER_LOGINACTIVITY_TIMESTAMP) = \(timestamp)")
    }
    
    static func insertUserLanguage(_ userLanguage: UserLanguageModel)
    {
        fmdbManager.insertRecord(tableObject: UserLanguageModel.localTableString, tableName: UserLanguageModel.localTableName, tableData: userLanguage.getObject(), primaryKey: UserLanguageModel.localPrimaryKey)
    }
    
    static func setUserLanguageUplaoded(language: String){
        let query = "UPDATE \(UserLanguageModel.localTableName) SET \(Constants.KEY_LANGUAGE_UPLOADED) = 1 WHERE \(Constants.KEY_LANGUAGE_NAME) = '\(language)'"
        fmdbManager.executeQuery(query)
    }
    
    //static let user
    
    static func insertUserPurchase(_ userPurchase: UserPurchase){
        fmdbManager.insertRecord(tableObject: UserPurchase.localTableString, tableName: UserPurchase.localTableName, tableData: userPurchase.getObject(), primaryKey: UserPurchase.localPrimaryKey)
    }
    
    static func removeLangaugedata(_ language: String){
        let query = "DELETE FROM \(LanguageItemModel.localTableName) WHERE \(Constants.KEY_LANGUAGE_SHORTNAME) = '\(language)'"
        fmdbManager.executeQuery(query)
    }
    
    static func uploadUserActivities(completion: @escaping () -> ()){
        let objects = GetDataFromFMDBManager.getPendingUserActivities()
        var count = 0
        if objects.count == 0{
            completion()
        }
        for object in objects{
            FirebaseUtils.saveUserActivity(userid: currentUser.user_uid, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, userActivity: object, completion: {
                success in
                count += 1
                let timestamp = object.value(forKey: UserActivityModel.TABLE_KEY_TIMESTAMP) as! Int64
                if success{
                    fmdbManager.executeQuery("update \(UserActivityModel.localTableName) set \(UserActivityModel.TABLE_KEY_UPLOADED) = 1 where \(UserActivityModel.TABLE_KEY_TIMESTAMP) = \(timestamp)")
                }
                if count == objects.count{
                    completion()
                }
            })
        }
    }
    
    static func setItemFavorite(languageFrom: String, languageTo: String, codeId: String, status: Bool){
        let tableObject = FavoriteModel.getObject(languageFrom: languageFrom, languageTo: languageTo, codeId: codeId, isFavorite: status)
        let favoriteObject = fmdbManager.getDataFromFMDB(with: "select *from \(FavoriteModel.localTableName) where languageFrom = '\(languageFrom)' and languageTo = '\(languageTo)' and codeId = '\(codeId)'", tableObject: FavoriteModel.localTableStringTemp)
        if favoriteObject.count == 0{
            fmdbManager.insertRecord(tableObject: FavoriteModel.localTableStringTemp, tableName: FavoriteModel.localTableName, tableData: tableObject, primaryKey: FavoriteModel.localTablePrimaryKey)
        }
        else{
            fmdbManager.executeQuery("update \(FavoriteModel.localTableName) set isFavorite = \(status), uploaded = 0 where languageFrom = '\(languageFrom)' and languageTo = '\(languageTo)' and codeId = '\(codeId)'")
        }
        if status{
            FirebaseUtils.addFavorite(userid: currentUser.user_uid, favorite: codeId,completion: {
                success in
                if success{
                    setFavoriteItemUploaded(languageFrom: languageFrom, languageTo: languageTo, codeId : codeId)
                }
            })
        }
        else{
            FirebaseUtils.removeFavorite(userid: currentUser.user_uid, languageFrom: languageFrom, languageTo: languageTo, code: codeId, completion: {
                success in
                if success{
                    setFavoriteItemUploaded(languageFrom: languageFrom, languageTo: languageTo, codeId: codeId)
                }
            })
        }
    }
    
    static func setFavoriteItemUploaded(languageFrom: String, languageTo: String, codeId: String){
        fmdbManager.executeQuery("update \(FavoriteModel.localTableName) set uploaded = 1 where languageFrom = '\(languageFrom)' and languageTo = '\(languageTo)' and codeId = '\(codeId)'")
    }
    
    
    
    
    
}
