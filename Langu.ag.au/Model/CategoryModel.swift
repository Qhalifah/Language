//
//  TaskModel.swift
//  Langu.ag
//
//  Created by Huijing on 16/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class CategoryModel{

    var category_code = ""
    var category_id = ""
    var category_order = ""
    var category_image = ""
    var category_lessons: [LessonModel] = []
    var category_level = ""
    var category_locked = false
    var category_name = ""
    var category_loaded_on_cell = false
    var category_completedlessoncount = 0

    static let localTableName = Constants.DIRECTORY_CATEGORIES

    static let localTablePrimaryKey = Constants.KEY_CATEGORY_ID

    static let localTableString = [Constants.KEY_CATEGORY_CODE: "TEXT",
                                   Constants.KEY_CATEGORY_ID: "TEXT",
                                   Constants.KEY_CATEGORY_ORDER:"TEXT",
                                   Constants.KEY_CATEGORY_IMAGE:"TEXT",
                                   Constants.KEY_CATEGORY_LEVEL:"TEXT",
                                   Constants.KEY_CATEGORY_LOCKED:"TINYINT",
                                   Constants.KEY_CATEGORY_NAME:"TEXT"]        

}

var shared_categories: [CategoryModel] = []

var categoryBeginnerCount = 0
var categoryIntermidietCount = 0
var categoryExpertCount = 0



