//
//  LanguItem.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation


class LanguItem{

    //var itemObject:[String: AnyObject] = [:]

    /* This model is for save and use lesson items to use in lesson item view.
     
     it is created when lesson will configured from categories
     
     And it is updated when user view that item or check answer.
 
     From this model I'll not use instance variables for model
     It will be use as object and keys to use
     And the utils for values will work well
     This will make easy to use object data and make all the functions with keys and objects well
     I think this will make important change and sense for coding for me.
     */

    static let localTableName = "langItems"
    static let localPrimaryKey = Constants.KEY_LESSON_CODEID
    static let localTableString = [Constants.KEY_USER_LANGUAGEFROM: "TEXT",
                                   Constants.KEY_USER_LANGUAGETO: "TEXT",
                                   Constants.KEY_LANGITEM_TYPE: "INT",
                                   Constants.KEY_LANGITEM_STATUS: "INT",
                                   Constants.KEY_LANGUAGEITEM_VIEWED: "TINYINT",
                                   Constants.KEY_LESSON_CODEID: "TEXT"]
    

    static func getJumbleArray(text: String) -> ([String], Bool){
        let result = getCorrectJumbleArray(text: text)
        return (CommonUtils.getRandomizedObject(from: result.0 as [AnyObject]) as! [String],result.1)
    }

    static func getAnswerArray(stringArray:[String], jumbleOrigin:Bool) -> String{
        var answerString = stringArray[0]
        if jumbleOrigin == JumblesView.JUMBLE_ORIGIN_SENTENCE{
            for i in 1..<stringArray.count{
                answerString.append(" \(stringArray[i])")
            }
        }
        else {
            for i in 1..<stringArray.count{
                answerString.append(stringArray[i])
            }
        }

        return answerString
    }

    static func getCorrectJumbleArray(text: String) -> ([String], Bool){

        var stringArray:[String] = []
        let trimmedText = text.trimmed
        let items = trimmedText.components(separatedBy: " ")
        var isItemCharacter = false
        if(items.count > 1)
        {
            stringArray = items
            isItemCharacter = JumblesView.JUMBLE_ORIGIN_SENTENCE
        }
        else
        {
            for character in trimmedText.characters{
                stringArray.append("\(character)")
            }
            isItemCharacter = JumblesView.JUMBLE_ORIGIN_WORD
        }
        return (stringArray, isItemCharacter)
        
    }

    static func getQuizArray(from stringArray: [AnyObject], correctAnswer: String) -> [String]{
        var tempStringArray : [String] = []
        for item in stringArray{
            let itemString = item[Constants.KEY_LANGUAGEITEM_TEXT] as! String
            if itemString == correctAnswer{
                continue
            }
            tempStringArray.append(itemString)
        }
        let tempResultArray = CommonUtils.getRandomizedObject(from: tempStringArray as [AnyObject])
        var quizTempArray : [AnyObject] = []
        for i in 0..<3{
            quizTempArray.append(tempResultArray[i] as AnyObject)
        }
        quizTempArray.append(correctAnswer as AnyObject)
        return CommonUtils.getRandomizedObject(from: quizTempArray) as! [String]

    }


}
