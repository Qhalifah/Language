//
//  LessonModel.swift
//  Langu.ag
//
//  Created by Huijing on 19/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class LessonModel
{
    var lesson_order = 0
    var lesson_id = ""
    var lesson_categoryid = ""
    var lesson_codes : [LessonCodesModel] = []
    var lesson_ratings = 0
    var lesson_completed = false
    var lesson_viewedphasecount = 0
    var lesson_correctphasecount = 0
    static let localTableName = Constants.DIRECTORY_LESSONS
    static let localTablePrimaryKey = Constants.KEY_CATEGORY_ID
    static let localTableString = [Constants.KEY_LESSON_ID: "TEXT",
                                   Constants.KEY_CATEGORY_ID: "TEXT",
                                   Constants.KEY_LESSON_ORDER:"INT(4)"]
}
