//
//  UserProgress.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class UserProgressModel{
    static let localTableName = "userProgress"
    static let localTablePrimaryKey = "lessonId"
    static let localTableString = ["lessonId" : "TEXT",
                                   "uploaded" : "TINYINT"]
}
