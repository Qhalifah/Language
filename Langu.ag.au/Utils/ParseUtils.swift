//
//  CategoryUtils.swift
//  Langu.ag
//
//  Created by Huijing on 19/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation




class ParseEntity{

    static func getCategory(rawData: [String: AnyObject]) -> CategoryModel
    {
        
        let category = CategoryModel()
        category.category_id = rawData[Constants.KEY_CATEGORY_ID] as! String
        category.category_code = rawData[Constants.KEY_CATEGORY_CODE] as! String
        category.category_name = rawData[Constants.KEY_CATEGORY_NAME] as! String
        category.category_image = rawData[Constants.KEY_CATEGORY_IMAGE] as! String
        category.category_level = rawData[Constants.KEY_CATEGORY_LEVEL] as! String
        category.category_locked = rawData[Constants.KEY_CATEGORY_LOCKED] as! Bool
        category.category_order = rawData[Constants.KEY_CATEGORY_ORDER] as! String
        return category
    }

    static func getLesson(rawData: [String: AnyObject]) -> LessonModel{
        let lesson = LessonModel()
        lesson.lesson_categoryid = rawData[Constants.KEY_CATEGORY_ID] as! String
        lesson.lesson_id = rawData[Constants.KEY_LESSON_ID] as! String
        lesson.lesson_order = rawData[Constants.KEY_LESSON_ORDER] as! Int
        let phaseCompletedCount = GetDataFromFMDBManager.getPharseCompletedCount(lessonId: lesson.lesson_id, languageFrom: currentUser.user_languagefrom, languageTo:  currentUser.user_languageto)
        lesson.lesson_viewedphasecount = phaseCompletedCount.0
        lesson.lesson_correctphasecount = phaseCompletedCount.1
        if (phaseCompletedCount.0 > 0 && phaseCompletedCount.0 * 2 == phaseCompletedCount.1)
        {
            lesson.lesson_completed = true
        }
        else{
            lesson.lesson_completed = false
        }
        lesson.lesson_ratings = 5 * lesson.lesson_viewedphasecount + lesson.lesson_correctphasecount
        return lesson
    }

    static func getLessonCodes(rawData: [String: AnyObject]) -> LessonCodesModel
    {
        let lessonCode = LessonCodesModel()
        lessonCode.lessoncode_lessonid = rawData[Constants.KEY_LESSON_ID] as! String
        lessonCode.lessoncode_order = rawData[Constants.KEY_LESSON_CODEORDER] as! Int
        lessonCode.lessoncode_value = rawData[Constants.KEY_LESSON_CODEID] as! String
        return lessonCode
    }

    static func getObjectFrom(object : AnyObject, to keyObject: [String : String]) -> [String: AnyObject]{
        var resultObject : [String: AnyObject] = [:]
        for key in keyObject.keys{
            resultObject[key] = object.value(forKey: key) as AnyObject
        }
        return resultObject
    }

}
