
//
//  LessonCodesModel.swift
//  Langu.ag
//
//  Created by Huijing on 25/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class LessonCodesModel{

    var lessoncode_value = ""
    var lessoncode_lessonid = ""
    var lessoncode_order = 0

    static let localTableName = Constants.DIRECTORY_CODES
    static let localTablePrimaryKey = Constants.KEY_LESSON_CODEID
    static let localTableString = [Constants.KEY_LESSON_CODEID: "TEXT",
                                   Constants.KEY_LESSON_ID: "TEXT",
                                   Constants.KEY_LESSON_CODEORDER: "INT(4)"]
}
