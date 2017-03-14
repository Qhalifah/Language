//
//  FavoriteModel.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class FavoriteModel{
    
    static let localTableString = ["favorite_image" : "TEXT",
                            "favorite_myword" : "TEXT",
                            "favorite_learntword": "TEXT",
                            "favorite_transliteration": "TEXT",
                            "favorite_lessoncodeid": "TEXT",
                            "favorite_audiourl" : "TEXT",
                            Constants.KEY_LANGITEM_STATUS: "INT"]
    
    
    static let localTableName = "favorite"
    static let localTablePrimaryKey = "codeId"
    static let localTableStringTemp = ["codeId":"TEXT",
                                       "isFavorite": "TINYINT",
                                       "languageFrom" : "TEXT",
                                       "languageTo": "TEXT",
                                       "uploaded" : "TINYINT"]
    
    static func getObject(languageFrom: String, languageTo: String, codeId: String, isFavorite: Bool) -> [String: AnyObject]{
        var resultObject : [String: AnyObject] = [:]
        resultObject["codeId"] = codeId as AnyObject
        resultObject["isFavorite"] = isFavorite as AnyObject
        resultObject["languageFrom"] = languageFrom as AnyObject
        resultObject["languageTo"] = languageTo as AnyObject
        resultObject["uploaded"] = false as AnyObject
        return resultObject
    }
    
}


