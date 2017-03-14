//
//  StringUtils.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation


class StringUtils{


    static func isValid(string: String?) -> Bool{
        if(string != nil && string?.characters.count != 0)
        {
            return true
        }
        return false
    }

    static func getKeyForFirebase(string: String) -> String{
        var resultString = ""
        resultString = string.replacingOccurrences(of: " ", with: "")
        resultString = resultString.replacingOccurrences(of: ".", with: "-")
        resultString = resultString.replacingOccurrences(of: "#", with: "-")
        resultString = resultString.replacingOccurrences(of: "$", with: "-")
        resultString = resultString.replacingOccurrences(of: "[", with: "-")
        return resultString
    }
    /*
    static func getLangugaeInAppPurchaseName()
    {

    }*/

    static func getLanguageImageName(languageName : String) -> String{
        return "language_" + languageName.lowercased().replacingOccurrences(of: "(", with: "").replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: ")", with: "")
    }

    static func getLanguageShortNameLowerCase(languageName : String) -> String{
        return languageName.lowercased().replacingOccurrences(of: " " , with: "_").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }

    static func getTalkNowLanguageName(language: String) -> String{
        return Constants.TALK_NOW_PREFIX + language.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }

    static func getDate(){
        
    }

    static func jumbleWords(items: [String]) -> [String]{
        let resultArray :[String] = []
        return resultArray
    }
    
    static func getLanguageShortNameFrom(_ storedFileName: String) -> String{
        
        for language in Languages().language_names{
            let localname = getTalkNowLanguageName(language: language)
            if localname == storedFileName{
                return getLanguageShortNameLowerCase(languageName: language)
            }
        }
        return "   "
        
    }
    
    
    
    static func getUserActivityObjectId(languageFrom: String, languageTo: String, verb: String, lessonId: String, code: String, activityType: Int) -> (String, String, String){
        
        var objectFrom = ""
        var objectTo = ""
        var id = ""
        
        switch activityType {
        case Constants.VALUE_ACTIVITY_LESSON_COMPLETED:
            objectFrom = "language/\(languageFrom)/lesson\(lessonId)"
            objectTo = "language/\(languageTo)/lesson\(lessonId)"
            id = "\(objectFrom)_\(objectTo)"
            break
        case Constants.VALUE_ACTIVITY_ITEMVIEWED:
            objectFrom = "language/\(languageFrom)/\(code)"
            objectTo = "language/\(languageTo)/\(code)"
            id = "\(objectFrom)_\(objectTo)_\(verb)"
            break
        case Constants.VALUE_ACTIVITY_CORRECT:
            objectFrom = "language/\(languageFrom)/\(Constants.USER_ACTIVITY_VERB_QUIZ_LABEL)/\(lessonId)/\(code)"
            objectTo = "language/\(languageTo)/\(Constants.USER_ACTIVITY_VERB_QUIZ_LABEL)/\(lessonId)/\(code)"
            id = "\(objectFrom)_\(objectTo)_\(verb)"
            break
        case Constants.VALUE_ACTIVITY_WRONG:
            objectFrom = "language/\(languageFrom)/\(Constants.USER_ACTIVITY_VERB_QUIZ_LABEL)/\(lessonId)/\(code)"
            objectTo = "language/\(languageTo)/\(Constants.USER_ACTIVITY_VERB_QUIZ_LABEL)/\(lessonId)/\(code)"
            let tableObject = fmdbManager.getDataFromFMDB(with: "SELECT count(*) as countOfWrongAnswer FROM \(UserActivityModel.localTableName)  WHERE \(UserActivityModel.TABLE_KEY_OBJECT_FROM) = '\(objectFrom)' AND \(UserActivityModel.TABLE_KEY_OBJECT_TO) = '\(objectTo)' AND \(UserActivityModel.TABLE_KEY_VERB) = '\(Constants.USER_ACTIVITY_VERB_QUIZ_WRONG)'", tableObject: ["countOfWrongAnswer": "INT"])
            
            let countOfWrongAnswer = tableObject[0].value(forKey: "countOfWrongAnswer") as! Int + 1
            id = "\(objectFrom)_\(objectTo)_\(verb)_\(countOfWrongAnswer)"
            break
            
        default:
            break
        }
        
        return (objectFrom, objectTo, id)
    }
    
    static func getUserActivityId(){
        
    }

    
    
}
