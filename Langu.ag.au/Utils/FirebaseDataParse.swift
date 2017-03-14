//
//  FirebaseDataParse.swift
//  Langu.ag
//
//  Created by Huijing on 25/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class FirebaseDataParse{

    static func saveCategoryDataToLocal (rawData: NSDictionary){
        fmdbManager.insertRecord(tableObject: CategoryModel.localTableString, tableName: CategoryModel.localTableName, tableData: rawData, primaryKey: CategoryModel.localTablePrimaryKey)
        let categoryId = rawData[Constants.KEY_CATEGORY_ID] as! String

        if (rawData[Constants.DIRECTORY_LESSONS] != nil){
            let lessonsObject = rawData[Constants.DIRECTORY_LESSONS] as! [AnyObject]
            
            var order = 0

            for lessonObject in lessonsObject{
                let lessonDict = lessonObject as! NSDictionary
                let lesson = LessonModel()
                lesson.lesson_id = lessonDict[Constants.KEY_LESSON_ID] as! String
                lesson.lesson_order = order
                lesson.lesson_categoryid = categoryId
                fmdbManager.insertLesson(lesson: lesson)
                let codesData = lessonDict[Constants.DIRECTORY_CODES] as! [AnyObject]

                var codeOrder = 0
                for codeData in codesData{
                    codeOrder += 1
                    let value = codeData as! String
                    let code = LessonCodesModel()
                    code.lessoncode_lessonid = lesson.lesson_id
                    code.lessoncode_order = codeOrder
                    code.lessoncode_value = value
                    fmdbManager.insertCode(code: code)

                }
                order += 1

            }
        }
    }

    static func saveLanugageDataToLocal(rawData: [String: AnyObject], language: String){
        var parseData = rawData
        parseData[Constants.KEY_LANGUAGE_NAME] = language as AnyObject
        //parseData[Constants.KEY_LANGUAGE_NAME] = language
        fmdbManager.insertRecord(tableObject: LanguageItemModel.localTableString, tableName: LanguageItemModel.localTableName, tableData: parseData, primaryKey: LanguageItemModel.localTablePrimaryKey)
    }
    
    static func saveUserLanguagesLocally(rawData: NSDictionary){
        fmdbManager.insertRecord(tableObject: UserLanguageModel.localTableString, tableName: UserLanguageModel.localTableName, tableData: rawData, primaryKey: UserLanguageModel.localPrimaryKey)
    }
    
    static func saveUserActivityToLocal(rawData: [String: AnyObject],languageFrom: String, languageTo: String){
        
    
        fmdbManager.insertRecord(tableObject: UserActivityModel.localTableString, tableName: UserActivityModel.localTableName, tableData: rawData, primaryKey: UserActivityModel.localTablePrimaryKey)
        }
    
    static func setLanguItemsFromUserActivity(objectToPrefix: String){
        
        let lessonsObject = fmdbManager.getDataFromFMDB(with: "SELECT distinct(b.\(Constants.KEY_LESSON_ID)) FROM \(UserActivityModel.localTableName) a inner join \(LessonCodesModel.localTableName) b on a.\(UserActivityModel.TABLE_KEY_OBJECT_TO) = '\(objectToPrefix)' || b.\(Constants.KEY_LESSON_CODEID)", tableObject: [Constants.KEY_LESSON_ID: "TEXT"])
        NSLog("\(lessonsObject)")
        
        for lessonObject in lessonsObject{
            let lessonId = lessonObject.value(forKey: Constants.KEY_LESSON_ID) as! String
            let myLangItems = GetDataFromFMDBManager.getLanguageItemFromCodes(language: StringUtils.getLanguageShortNameLowerCase(languageName: currentUser.user_languagefrom), lessonId: lessonId)
            for item in myLangItems{
                FMDBManagerSetData.insertLangItems(user: currentUser, itemType: Constants.VALUE_LANGUITEM_STANDARD, itemStatus: Constants.VALUE_LANGUSTATUS_NOTDETECTED, itemViewed: false, lessonCodeId: item[Constants.KEY_LESSON_CODEID] as! String)
                FMDBManagerSetData.insertLangItems(user: currentUser, itemType: Constants.VALUE_LANGUITEM_QUIZ, itemStatus: Constants.VALUE_LANGUSTATUS_NOTDETECTED, itemViewed: false, lessonCodeId: item[Constants.KEY_LESSON_CODEID] as! String)
                FMDBManagerSetData.insertLangItems(user: currentUser, itemType: Constants.VALUE_LANGUITEM_JUMBLE, itemStatus: Constants.VALUE_LANGUSTATUS_NOTDETECTED, itemViewed: false, lessonCodeId: item[Constants.KEY_LESSON_CODEID] as! String)
            }
        }
        
        var itemsObject = fmdbManager.getDataFromFMDB(with: "select \(UserActivityModel.TABLE_KEY_OBJECT_TO) from \(UserActivityModel.localTableName) where \(UserActivityModel.TABLE_KEY_VERB) = '\(Constants.USER_ACTIVITY_VERB_VIEWED)' group by \(UserActivityModel.TABLE_KEY_ID)", tableObject: [UserActivityModel.TABLE_KEY_OBJECT_TO: "TEXT"])
        
        for itemObject in itemsObject {
            let code = itemObject.value(forKey: UserActivityModel.TABLE_KEY_OBJECT_TO) as! String
            let codes = code.components(separatedBy: "/")
            let codeId = codes[codes.count - 1]
            fmdbManager.executeQuery("update \(LanguItem.localTableName) set \(Constants.KEY_LANGUAGEITEM_VIEWED) = 1, \(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_CORRECT) where \(Constants.KEY_LESSON_CODEID) = '\(codeId)' and \(Constants.KEY_LANGITEM_TYPE) = \(Constants.VALUE_LANGUITEM_STANDARD) ")
        }
        
        
        itemsObject = fmdbManager.getDataFromFMDB(with: "select \(UserActivityModel.TABLE_KEY_OBJECT_TO) from \(UserActivityModel.localTableName) where \(UserActivityModel.TABLE_KEY_VERB) = '\(Constants.USER_ACTIVITY_VERB_QUIZ_CORRECT)' group by \(UserActivityModel.TABLE_KEY_ID)", tableObject: [UserActivityModel.TABLE_KEY_OBJECT_TO: "TEXT"])
        for itemObject in itemsObject{
            let objectJumbleKey = "_jumbled"
            let objectImageKey = "_mcq_image_options"
            let objectSoundKey = "_mcq_sound_options"
            
            let codeObject = itemObject.value(forKey: UserActivityModel.TABLE_KEY_OBJECT_TO) as! String
            let codes = codeObject.components(separatedBy: "/")
            let code = codes[codes.count - 1]
            
            if code.hasSuffix(objectImageKey)
            {
                let codeId = code.replacingOccurrences(of: objectImageKey, with: "")
                fmdbManager.executeQuery("update \(LanguItem.localTableName) set \(Constants.KEY_LANGUAGEITEM_VIEWED) = 1, \(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_CORRECT) where \(Constants.KEY_LESSON_CODEID) = '\(codeId)' and \(Constants.KEY_LANGITEM_TYPE) = \(Constants.VALUE_LANGUITEM_QUIZ) ")
            }
            else if code.hasSuffix(objectSoundKey)
            {
                let codeId = code.replacingOccurrences(of: objectSoundKey, with: "")
                fmdbManager.executeQuery("update \(LanguItem.localTableName) set \(Constants.KEY_LANGUAGEITEM_VIEWED) = 1, \(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_CORRECT) where \(Constants.KEY_LESSON_CODEID) = '\(codeId)' and \(Constants.KEY_LANGITEM_TYPE) = \(Constants.VALUE_LANGUITEM_QUIZ)")
                
            }
            else if code.hasSuffix(objectJumbleKey){
                let codeId = code.replacingOccurrences(of: objectJumbleKey, with: "")
                fmdbManager.executeQuery("update \(LanguItem.localTableName) set \(Constants.KEY_LANGUAGEITEM_VIEWED) = 1, \(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_CORRECT) where \(Constants.KEY_LESSON_CODEID) = '\(codeId)' and \(Constants.KEY_LANGITEM_TYPE) = \(Constants.VALUE_LANGUITEM_JUMBLE)")
            }
        }
    }


}
