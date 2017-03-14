

//
//  LanguageItem.swift
//  Langu.ag
//
//  Created by Huijing on 22/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation


class LanguageItemModel{

    static let localTableName = "languageitems"
    static let localTablePrimaryKey = Constants.KEY_LANGUAGE_NAME
    static let localTableString = [Constants.KEY_LANGUAGEITEM_AUDIOF        :"TEXT",
                                   Constants.KEY_LANGUAGEITEM_CATEGORY      :"TEXT",
                                   Constants.KEY_LANGUAGEITEM_COMPLEXITY    :"INT",
                                   Constants.KEY_LANGUAGEITEM_IMAGE         :"TEXT",
                                   Constants.KEY_LANGUAGEITEM_LESSONID      :"TEXT",
                                   Constants.KEY_LANGUAGEITEM_LOCKED        :"TINYINT",
                                   Constants.KEY_LANGUAGEITEM_RATING        :"INT",
                                   Constants.KEY_LANGUAGEITEM_TEXT          :"TEXT",
                                   Constants.KEY_LANGUAGEITEM_TRANSLITERATION :"TEXT",
                                   Constants.KEY_LANGUAGEITEM_VIEWED        :"TINYINT",
                                   Constants.KEY_LANGUAGE_SHORTNAME: "TEXT",
                                   Constants.KEY_LESSON_CODEID: "TEXT"]
}
