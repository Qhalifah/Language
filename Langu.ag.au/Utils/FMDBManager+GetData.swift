//
//  FMDBManager+GetData.swift
//  Langu.ag
//
//  Created by Huijing on 27/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation



class GetDataFromFMDBManager{

    static func getCategoryDataFromLocal()
    {
        categoryBeginnerCount = 0
        categoryIntermidietCount = 0
        categoryExpertCount = 0
        let categoryObject = fmdbManager.getDataFromFMDB(with: "SELECT * FROM \(Constants.DIRECTORY_CATEGORIES) ORDER BY \(Constants.KEY_CATEGORY_ORDER) * 1" , tableObject: CategoryModel.localTableString)

        var categories : [CategoryModel] = []
        for categoryData in categoryObject{
        
            let category = ParseEntity.getCategory(rawData: categoryData as! [String : AnyObject])            
            
            category.category_lessons = getLessonsFromCategory(categoryId: category.category_id)
            if category.category_lessons.count == 0
            {
                continue
            }
            if category.category_level == "beginner"{
                categoryBeginnerCount += 1
            }
            else if category.category_level == "intermediate"
            {
                categoryIntermidietCount += 1
            }
            else{
                categoryExpertCount += 1
            }
            for lesson in category.category_lessons{
                if lesson.lesson_completed{
                    category.category_completedlessoncount += 1
                }
            }
            categories.append(category)
        }
        shared_categories = categories
    }

    static func getLessonsFromCategory(categoryId: String) -> [LessonModel]{
        var lessons : [LessonModel] = []

        var query = "SELECT *FROM \(Constants.DIRECTORY_LESSONS) WHERE \(Constants.KEY_CATEGORY_ID) = \(categoryId) ORDER BY \(Constants.KEY_LESSON_ORDER)"

        let lessonsObject = fmdbManager.getDataFromFMDB(with:query , tableObject: LessonModel.localTableString)

        for lessonData in lessonsObject{
            
            let lesson = ParseEntity.getLesson(rawData: lessonData as! [String: AnyObject])
            query = "SELECT *FROM \(Constants.DIRECTORY_CODES) WHERE \(Constants.KEY_LESSON_ID) = \(lesson.lesson_id) ORDER BY \(Constants.KEY_LESSON_CODEORDER)"
            let cateObject = fmdbManager.getDataFromFMDB(with: query , tableObject: LessonCodesModel.localTableString)

            for codeData in cateObject{
                let lessonCode = ParseEntity.getLessonCodes(rawData: codeData as! [String: AnyObject])
                lesson.lesson_codes.append(lessonCode)
            }
            lessons.append(lesson)

        }
        return lessons

    }

    static func getCodesFromLesson(lessonId: String) -> [LessonCodesModel]{
        var lessonCodes : [LessonCodesModel] = []
        let query = "SELECT *FROM \(LessonCodesModel.localTableName) WHERE \(Constants.KEY_LESSON_ID) = \(lessonId) ORDER BY \(Constants.KEY_LESSON_CODEORDER)"
        let cateObject = fmdbManager.getDataFromFMDB(with: query , tableObject: LessonCodesModel.localTableString)
        for codeData in cateObject{
            let lessonCode = ParseEntity.getLessonCodes(rawData: codeData as! [String: AnyObject])
            lessonCodes.append(lessonCode)
        }
        return lessonCodes

    }

    static func getLanguageItemFromCodes(language: String, lessonId: String) -> [[String: AnyObject]]{
        var languageItems : [[String: AnyObject]] = []
        let query = "SELECT * from \(LessonCodesModel.localTableName) a INNER JOIN \(LanguageItemModel.localTableName) b ON a.\(Constants.KEY_LESSON_CODEID) = b.\(Constants.KEY_LESSON_CODEID) WHERE a.\(Constants.KEY_LESSON_ID) = '\(lessonId)' and b.\(Constants.KEY_LANGUAGE_SHORTNAME) = '\(language)' ORDER BY a.\(Constants.KEY_LESSON_CODEORDER)"
        let languageItemsObject = fmdbManager.getDataFromFMDB(with: query , tableObject: LanguageItemModel.localTableString)
        for languItemData in languageItemsObject{
            languageItems.append(ParseEntity.getObjectFrom(object: languItemData, to: LanguageItemModel.localTableString))
        }
        return languageItems
    }

    static func getLanguItemsFor(lessonId: String, languageFrom: String, languageTo: String) -> [[String: AnyObject]]{

        let query = "SELECT *FROM \(LanguItem.localTableName) a INNER JOIN \(LessonCodesModel.localTableName) b ON a.\(Constants.KEY_LESSON_CODEID) = b.\(Constants.KEY_LESSON_CODEID) WHERE b.\(Constants.KEY_LESSON_ID) = '\(lessonId)' AND a.\(Constants.KEY_USER_LANGUAGEFROM) = '\(languageFrom)' AND a.\(Constants.KEY_USER_LANGUAGETO) = '\(languageTo)' ORDER BY a.\(Constants.KEY_LANGITEM_TYPE), b.\(Constants.KEY_LESSON_CODEORDER)"

        let result = fmdbManager.getDataFromFMDB(with: query , tableObject: LanguItem.localTableString) as! [[String: AnyObject]]
        return result
    }

    static func getRatingObject(lessonId : String, languageFrom: String, languageTo: String) -> [[String: AnyObject]] {
        let query = "SELECT COUNT(*) AS \(Constants.KEY_RATINGCOUNTS), *FROM \(LanguItem.localTableName) a INNER JOIN \(LessonCodesModel.localTableName) b ON a.\(Constants.KEY_LESSON_CODEID) = b.\(Constants.KEY_LESSON_CODEID) WHERE b.\(Constants.KEY_LESSON_ID) = '\(lessonId)' AND a.\(Constants.KEY_USER_LANGUAGEFROM) = '\(languageFrom)' AND a.\(Constants.KEY_USER_LANGUAGETO) = '\(languageTo)' AND (a.\(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_CORRECT) OR a.\(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_FAVORITE)) GROUP BY a.\(Constants.KEY_LANGITEM_TYPE)"
        let result = fmdbManager.getDataFromFMDB(with: query , tableObject: RatingModel.localTableString) as! [[String: AnyObject]]
        return result

    }

    static func getRatingValueFrom(ratingObject: [[String: AnyObject]]) -> (Int, Int){
        var correctphasescount = 0
        var viewedphasecount = 0
        for item in ratingObject{
            if (item[Constants.KEY_LANGITEM_TYPE] as! Int) == Constants.VALUE_LANGUITEM_STANDARD{
                viewedphasecount = viewedphasecount + (item[Constants.KEY_RATINGCOUNTS] as! Int)
            }
            else{
                correctphasescount = correctphasescount + (item[Constants.KEY_RATINGCOUNTS] as! Int)
            }
        }

        return (viewedphasecount, correctphasescount)
    }

    static func getPharseCompletedCount(lessonId : String, languageFrom: String, languageTo: String) -> (Int, Int){
        let ratingObject = getRatingObject(lessonId: lessonId, languageFrom: languageFrom, languageTo: languageTo)
        let result = getRatingValueFrom(ratingObject: ratingObject)
        return result
    }

    static func getTotalLearnt(languageFrom: String, languageTo: String) -> (Int, Int){
        let query = "SELECT COUNT(*) AS \(Constants.KEY_RATINGCOUNTS), *FROM \(LanguItem.localTableName) a INNER JOIN \(LessonCodesModel.localTableName) b ON a.\(Constants.KEY_LESSON_CODEID) = b.\(Constants.KEY_LESSON_CODEID) WHERE a.\(Constants.KEY_USER_LANGUAGEFROM) = '\(languageFrom)' AND a.\(Constants.KEY_USER_LANGUAGETO) = '\(languageTo)' AND (a.\(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_CORRECT) OR a.\(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_FAVORITE)) GROUP BY a.\(Constants.KEY_LANGITEM_TYPE)"
        let ratingObject = fmdbManager.getDataFromFMDB(with: query , tableObject: RatingModel.localTableString) as! [[String: AnyObject]]
        var correctphasescount = 0
        var viewedphasecount = 0
        for item in ratingObject{
            if (item[Constants.KEY_LANGITEM_TYPE] as! Int) == Constants.VALUE_LANGUITEM_STANDARD{
                viewedphasecount = viewedphasecount + (item[Constants.KEY_RATINGCOUNTS] as! Int)
            }
            else{
                correctphasescount = correctphasescount + (item[Constants.KEY_RATINGCOUNTS] as! Int)
            }
        }
        return(viewedphasecount, correctphasescount)

    }

    static func getPoints(_ learnt:(Int, Int)) -> Int{
        return learnt.0 * 5 + learnt.1 * 10
    }
    
    static func getFavoriteItems(languageFrom: String, languageTo: String) -> [[String: AnyObject]]
    {
        let query = "SELECT a.\(Constants.KEY_LESSON_CODEID) as favorite_lessoncodeid,a.\(Constants.KEY_LANGITEM_STATUS), b.\(Constants.KEY_LANGUAGEITEM_IMAGE) as favorite_image, c.\(Constants.KEY_LANGUAGEITEM_TEXT) as favorite_myword,b.\(Constants.KEY_LANGUAGEITEM_TEXT) as favorite_learntword, b.\(Constants.KEY_LANGUAGEITEM_TRANSLITERATION) as favorite_transliteration, b.\(Constants.KEY_LANGUAGEITEM_AUDIOF) as  favorite_audiourl FROM \(LanguItem.localTableName) a INNER JOIN \(LanguageItemModel.localTableName) c ON c.\(Constants.KEY_LESSON_CODEID) = a.\(Constants.KEY_LESSON_CODEID) AND c.\(Constants.KEY_LANGUAGE_SHORTNAME) = '\(StringUtils.getLanguageShortNameLowerCase(languageName: languageFrom))' INNER JOIN \(LanguageItemModel.localTableName) b ON b.\(Constants.KEY_LANGUAGE_SHORTNAME) = '\(StringUtils.getLanguageShortNameLowerCase(languageName: languageTo))' AND b.\(Constants.KEY_LESSON_CODEID) = a.\(Constants.KEY_LESSON_CODEID) WHERE a.\(Constants.KEY_LANGITEM_STATUS) = '\(Constants.VALUE_LANGUSTATUS_FAVORITE)' AND a.\(Constants.KEY_USER_LANGUAGEFROM) = '\(languageFrom)' AND a.\(Constants.KEY_USER_LANGUAGETO) = '\(languageTo)' ORDER BY c.\(Constants.KEY_LANGUAGEITEM_TEXT)"
        
        let result = fmdbManager.getDataFromFMDB(with: query , tableObject: FavoriteModel.localTableString) as! [[String: AnyObject]]
        
        return result
    }
    
    static func getMatchedItems(languageFrom: String, languageTo: String, match: String) -> [[String: AnyObject]]
    {
        var query = ""
        if (getLanguagePurchased(language: languageTo)){
            query = "SELECT a.\(Constants.KEY_LANGITEM_STATUS), a.\(Constants.KEY_LESSON_CODEID) as favorite_lessoncodeid, b.\(Constants.KEY_LANGUAGEITEM_IMAGE) as favorite_image, c.\(Constants.KEY_LANGUAGEITEM_TEXT) as favorite_myword,b.\(Constants.KEY_LANGUAGEITEM_TEXT) as favorite_learntword, b.\(Constants.KEY_LANGUAGEITEM_TRANSLITERATION) as favorite_transliteration, b.\(Constants.KEY_LANGUAGEITEM_AUDIOF) as  favorite_audiourl FROM \(Constants.DIRECTORY_CODES) d INNER JOIN \(LanguageItemModel.localTableName) b ON d.\(Constants.KEY_LESSON_CODEID) = b.\(Constants.KEY_LESSON_CODEID) AND b.\(Constants.KEY_LANGUAGE_SHORTNAME) = '\(StringUtils.getLanguageShortNameLowerCase(languageName: languageTo))' AND b.\(Constants.KEY_LANGUAGEITEM_TRANSLITERATION) LIKE '%\(match)%' INNER JOIN \(LanguageItemModel.localTableName) c ON d.\(Constants.KEY_LESSON_CODEID) = c.\(Constants.KEY_LESSON_CODEID) and c.\(Constants.KEY_LANGUAGE_SHORTNAME) = '\(StringUtils.getLanguageShortNameLowerCase(languageName: languageFrom))' LEFT JOIN \(LanguItem.localTableName) a ON a.\(Constants.KEY_LESSON_CODEID) = d.\(Constants.KEY_LESSON_CODEID) AND a.\(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_FAVORITE)"
        }
        else{
            query = "SELECT a.\(Constants.KEY_LANGITEM_STATUS), a.\(Constants.KEY_LESSON_CODEID) as favorite_lessoncodeid, b.\(Constants.KEY_LANGUAGEITEM_IMAGE) as favorite_image, c.\(Constants.KEY_LANGUAGEITEM_TEXT) as favorite_myword,b.\(Constants.KEY_LANGUAGEITEM_TEXT) as favorite_learntword, b.\(Constants.KEY_LANGUAGEITEM_TRANSLITERATION) as favorite_transliteration, b.\(Constants.KEY_LANGUAGEITEM_AUDIOF) as  favorite_audiourl FROM \(Constants.DIRECTORY_CODES) d INNER JOIN \(LanguageItemModel.localTableName) b ON d.\(Constants.KEY_LESSON_CODEID) = b.\(Constants.KEY_LESSON_CODEID) AND b.\(Constants.KEY_LANGUAGE_SHORTNAME) = '\(StringUtils.getLanguageShortNameLowerCase(languageName: languageTo))' AND b.\(Constants.KEY_LANGUAGEITEM_TRANSLITERATION) LIKE '%\(match)%' INNER JOIN \(LanguageItemModel.localTableName) c ON d.\(Constants.KEY_LESSON_CODEID) = c.\(Constants.KEY_LESSON_CODEID) and c.\(Constants.KEY_LANGUAGE_SHORTNAME) = '\(StringUtils.getLanguageShortNameLowerCase(languageName: languageFrom))' INNER JOIN \(LessonModel.localTableName) e ON e.\(Constants.KEY_LANGUAGEITEM_LESSONID) = c.\(Constants.KEY_LANGUAGEITEM_LESSONID) INNER JOIN \(CategoryModel.localTableName) f ON f.\(Constants.KEY_CATEGORY_ID) = e.\(Constants.KEY_CATEGORY_ID) AND f.\(Constants.KEY_CATEGORY_LEVEL) = 'beginner' LEFT JOIN \(LanguItem.localTableName) a ON a.\(Constants.KEY_LESSON_CODEID) = d.\(Constants.KEY_LESSON_CODEID) AND a.\(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_FAVORITE)"
        }
        
        
        NSLog("Query = \(query)")
        
        let result = fmdbManager.getDataFromFMDB(with: query , tableObject: FavoriteModel.localTableString) as! [[String: AnyObject]]
        
        return result
    }
    
    static func getUnloadedLoginActivity() -> [UserLoginActivityModel]{
        var result : [UserLoginActivityModel] = []
        let objects = fmdbManager.getDataFromFMDB(with: "SELECT * FROM \(UserLoginActivityModel.localTableName) WHERE \(Constants.KEY_USER_LOGINACTIVITY_UPLOADED) = 0 ", tableObject: UserLoginActivityModel.localTableString)
        for object in objects{
            result.append(UserLoginActivityModel.getModelFromData(object: object))
        }
        return result
        
    }
    
    static func getDaysOfActivity() -> [Int]{
        var daysOfWeek : [Int] = []
        let currentTime = getGlobalTime()
        let dateString = getTimeStringfromGMTTimeMillis(time: currentTime).description
        guard var currentWeekDay = Date.getDayOfWeek(today: dateString) else{
            return []
        }
      
        let time = Date.getTime(dateString)
        
        let hour = Int64(time.0)
        let minute = Int64(time.1)
        let second = Int64(time.2)
        if currentWeekDay == 0
        {
            currentWeekDay = 7
        }
        let secondInDay = (Int64(currentWeekDay) - 1) * 86400 - 3600 * hour! + 60 * minute! + second!
        let mondayTimeStamp = currentTime - secondInDay * 1000
        
        let objects = fmdbManager.getDataFromFMDB(with: "SELECT * FROM \(UserLoginActivityModel.localTableName) WHERE \(Constants.KEY_USER_LOGINACTIVITY_TIMESTAMP) > \(mondayTimeStamp) ORDER BY \(Constants.KEY_USER_LOGINACTIVITY_TIMESTAMP)", tableObject: UserLoginActivityModel.localTableString)
        for object in objects{
            let dateString = getTimeStringfromGMTTimeMillis(time: object.value(forKey: Constants.KEY_USER_LOGINACTIVITY_TIMESTAMP) as! Int64).description
            guard let weekDay = Date.getDayOfWeek(today: dateString) else{
                continue
            }
            if daysOfWeek.count == 0{
                daysOfWeek.append(weekDay)
                
            }
            else  if daysOfWeek[daysOfWeek.count - 1] == weekDay{
                continue
            }
            else{
                daysOfWeek.append(weekDay)
            }
        }
        return daysOfWeek
        
    }
    
    static func getPendingUserLanguageFromLocal(language: String) -> AnyObject?{
        let query = "SELECT * FROM \(UserLanguageModel.localTableName) WHERE \(Constants.KEY_LANGUAGE_NAME) = '\(language)' AND \(Constants.KEY_LANGUAGE_UPLOADED) = 0"
        let objects = fmdbManager.getDataFromFMDB(with: query, tableObject: UserLanguageModel.localTableString)
        if(objects.count == 0){
            return nil
        }
        var languageObject = objects[0] as! [String: AnyObject]
        let purchaseTime = languageObject[Constants.KEY_PURCHASE_TIME] as! Int64
        languageObject.removeValue(forKey: Constants.KEY_PURCHASE_TIME)//.removeObject(forKey: Constants.KEY_PURCHASE_TIME)
        let queryPurchase = "SELECT * FROM \(UserPurchase.localTableName) WHERE \(Constants.KEY_PURCHASE_TIME) = \(purchaseTime)"
        let purchaseObjects = fmdbManager.getDataFromFMDB(with: queryPurchase, tableObject: UserPurchase.localTableString)
        if purchaseObjects.count > 0{
            //languageObject.value(forKey: Constants.KEY_LANGUAGE_USERPURCHASE)
            languageObject[Constants.KEY_LANGUAGE_USERPURCHASE] = purchaseObjects[0] as AnyObject
        }
        
        languageObject[Constants.KEY_LANGUAGE_UPLOADED] = true as AnyObject
        
        return languageObject as AnyObject
    }
    
    static func getLanguagePurchased(language: String) -> Bool{
        let query = "SELECT * FROM \(UserLanguageModel.localTableName) WHERE (\(Constants.KEY_LANGUAGE_NAME) = '\(language)' OR \(Constants.KEY_LANGUAGE_NAME) = '\(Languages.LANGUAGE_ALL)') AND \(Constants.KEY_LANGUAGE_ISFREE) = 0"
        let count = fmdbManager.getDataFromFMDB(with: query, tableObject: UserLanguageModel.localTableString).count
        if count > 0{
            return true
        }
        return false
    }
    
    static func getPurchases() -> [[String: AnyObject]]{
        let query = "SELECT * FROM \(UserLanguageModel.localTableName) WHERE \(Constants.KEY_LANGUAGE_ISFREE) = 0"
        return fmdbManager.getDataFromFMDB(with: query, tableObject: UserLanguageModel.localTableString) as! [[String : AnyObject]]
        
    }
    
    static func getLessonFrom(codeId: String) -> String{
        let query = "SELECT \(Constants.KEY_LESSON_ID) as lessonId FROM \(LessonCodesModel.localTableName) WHERE \(Constants.KEY_LESSON_CODEID) = '\(codeId)'"
        let tableObject = fmdbManager.getDataFromFMDB(with: query, tableObject: ["lessonId":"TEXT"])
        if tableObject.count > 0{
            return tableObject[0].value(forKey: "lessonId") as! String
        }
        else{
            return ""
        }
    }
    
    static func getPendingUserActivities() -> [AnyObject]{
        return fmdbManager.getDataFromFMDB(with: "select * from \(UserActivityModel.localTableName) where \(UserActivityModel.TABLE_KEY_UPLOADED) = 0", tableObject: UserActivityModel.localTableString)
    }
    
    static func isLessonCompleted(lessonId: String) -> Bool{
        var query = "select count(*) as itemCount from \(LessonCodesModel.localTableName) where \(Constants.KEY_LESSON_ID) = '\(lessonId)'"
        var queryResult = fmdbManager.getDataFromFMDB(with: query, tableObject: ["itemCount":"INT"])
        let itemCount = queryResult[0].value(forKey: "itemCount") as! Int
        query = "select count(*) as correctCount from \(LanguItem.localTableName) a inner join \(LessonCodesModel.localTableName) b on b.\(Constants.KEY_LESSON_ID) = '\(lessonId)' and b.\(Constants.KEY_LESSON_CODEID) = a.\(Constants.KEY_LESSON_CODEID) where a.\(Constants.KEY_LANGITEM_STATUS) = \(Constants.VALUE_LANGUSTATUS_CORRECT)"
        queryResult = fmdbManager.getDataFromFMDB(with: query, tableObject: ["correctCount":"INT"])
        let correctCount = queryResult[0].value(forKey: "correctCount") as! Int
        
        if itemCount * 3 == correctCount{
            return true
        }
        else{
            return false
        }
    }
    
    
    static func getPendingFavorites(languageFrom: String, languageTo: String) -> [AnyObject]{
        return fmdbManager.getDataFromFMDB(with: "select * from \(FavoriteModel.localTableName) where uploaded = 0", tableObject: FavoriteModel.localTableStringTemp)
    }



}

