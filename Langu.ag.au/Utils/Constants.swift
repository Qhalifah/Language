//
//  Constants.swift
//  Langu.ag
//
//  Created by Huijing on 15/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation

class Constants{



    //user infomation keys
    static let USER_EMAIL           = "user_email"
    static let USER_PASSWORD        = "user_password"
    static let USER_ID              = "user_id"
    static let USER_LANGUAGEFROM    = "user_languagefrom"
    static let USER_LANGUAGETO      = "user_languageto"

    static let BILLING_REQUEST_CODE = 12345;

    static let IMAGE_PICKER_REQUEST_CODE = 999;

    static let FONT_NAME = "Comfortaa-Light";

    static let PREFERENCE_LOGGED_IN = "logged_in";
    static let PREFERENCE_SETUP_COMPLETE = "setup_complete";

    //    static let PREFERENCE_LANGUAGE_FROM = "language_from";
    //    static let PREFERENCE_LANGUAGE_TO = "language_to";

    static let INTENT_OPTION_PREPARE_APP = "prepare_app";
    static let INTENT_OPTION_UPDATE_LOGIN = "update_login";

    static let PREFERENCE_MY_USERID = "my_userid";
    static let PREFERENCE_MY_DEVICEID = "my_deviceid";
    static let PREFERENCE_MY_NOTIFICATION_ID = "my_notification_id";

    static let CATEGORY_EVERYDAY_WORDS = "everyday words";
    static let CATEGORY_AT_HOME = "at home";
    static let CATEGORY_NUMBERS = "numbers";
    static let CATEGORY_COLOURS_1 = "colours";
    static let CATEGORY_COLOURS_2 = "colors";
    static let CATEGORY_TIME = "time";
    static let CATEGORY_FOOD_DRINK = "food & drink";
    static let CATEGORY_PARTS_OF_THE_BODY = "parts of the body";
    static let CATEGORY_CLOTHES = "clothes";
    static let CATEGORY_HELP = "help";
    static let CATEGORY_COUNTRIES = "countries";
    static let CATEGORY_TRAVELLING = "travelling";

    static let USER_ACTIVITY_VERB_LOGGED_IN = "Logged in";
    static let USER_ACTIVITY_VERB_VIEWED = "Viewed";
    static let USER_ACTIVITY_VERB_QUIZ_LABEL = "quiz";
    static let USER_ACTIVITY_VERB_QUIZ_CORRECT = "Correct Answer";
    static let USER_ACTIVITY_VERB_QUIZ_WRONG = "Wrong Answer";
    static let USER_ACTIVITY_VERB_COMPLETED = "Completed";

    static let USER_XP = "xp";

    static let TALK_NOW_PREFIX = "Talk_Now_";

    static let IAP_USER_CANCELED_CODE = -1;
    static let IAP_USER_CANCELED = "Purchase canceled by user";


    static let dbname = "Langu.db"

    //categories name


    //Main directory names

    static let DIRECTORY_EURO_TALK = "eurotalk"
    static let DIRECTORY_LOGIN_HISTORY = "login_history"
    static let DIRECTORY_MIGRATED_USERS = "migrated_users"
    static let DIRECTORY_PURCHASE_LOG = "purchase_log"
    static let DIRECTORY_USER_LANGUAGES = "user_languages"
    static let DIRECTORU_USERS = "users"

    //Eurotalk sub directories

    static let DIRECTORY_CATEGORIES = "categories"


        static let DIRECTORY_LESSONS = "lessons"
        static let DIRECTORY_CODES = "codes"

    static let DIRECTORY_LANGUAGES = "languages"

    static let DIRECTORY_USER_DATA = "user_data"
    static let DIRECTORY_FAVORITES = "favorites"
    static let DIRECTORY_USER_ACTIVITY = "userActivity"
    static let DIRECTORY_USER_PROGRESS = "userProgress"
    


    //keys for values categories
    static let KEY_CATEGORY_CODE = "categoryCode"
    static let KEY_CATEGORY_ID = "categoryId"
    static let KEY_CATEGORY_ORDER = "categoryOrder"
    static let KEY_CATEGORY_IMAGE = "image"
    static let KEY_CATEGORY_LEVEL = "level"
    static let KEY_CATEGORY_LOCKED = "locked"
    static let KEY_CATEGORY_NAME = "name"


    static let KEY_LESSON_ID = "lessonId"
    static let KEY_LESSON_ORDER = "lessonOrder"
    static let KEY_FAVORITE_ID = "id"

    static let KEY_LESSON_CODEID = "codeId"
    static let KEY_LESSON_CODEORDER = "codeOrder"



    //keys for UserModel

    static let KEY_USER_ADMIN = "admin"
    static let KEY_USER_DISPLAYNAME = "displayName"
    static let KEY_USER_EMAIL = "email"
    static let KEY_USER_ISADMIN = "isAdmin"
    static let KEY_USER_LANGUAGEFROM = "languageFrom"
    static let KEY_USER_LANGUAGETO = "languageTo"
    static let KEY_USER_LOADED = "loaded"
    static let KEY_USER_MIGRATED = "migrated"
    static let KEY_USER_PHOTOURL = "photoUrl"
    static let KEY_USER_PROVIDEID = "provideId"
    static let KEY_USER_UID = "uid"
    static let KEY_USER_UPDATETIMESTAMP = "updateTimeStamp"
    static let KEY_USER_VALID = "valid"
    static let KEY_USER_CURRENTVERSION = "current_version"

    //keys for User login activity

    static let KEY_USER_LOGINACTIVITY_LOADED = "loaded"
    static let KEY_USER_LOGINACTIVITY_TIMESTAMP = "timestamp"
    static let KEY_USER_LOGINACTIVITY_USER = "user"
    static let KEY_USER_LOGINACTIVITY_UPLOADED = "uploaded"
    static let KEY_USER_LOGINACTIVITY_VALID = "valid"

    //keys for language 

    static let KEY_LANGUAGE_NAME = "languageName"
    static let KEY_LANGUAGE_SHORTNAME = "languageShortName"
    static let KEY_LANGUAGE_USERID = "userId"
    static let KEY_LANGUAGE_ISFREE = "free"
    static let KEY_LANGUAGE_MIGRATEDLANGUAGE = "migratedLanguage"
    static let KEY_LANGUAGE_STORENAME = "storeName"
    static let KEY_LANGUAGE_USERPURCHASE = "userPurchase"
    static let KEY_LANGUAGE_UPLOADED = "uploaded"
    static let KEY_LANGUAGE_LOADED = "loaded"
    static let KEY_LANGUAGE_VALID = "valid"

    //keys for languageitem

    static let KEY_LANGUAGEITEM_AUDIOF = "audioF"
    static let KEY_LANGUAGEITEM_CATEGORY = "category"
    static let KEY_LANGUAGEITEM_COMPLEXITY = "complexity"
    static let KEY_LANGUAGEITEM_IMAGE = "image"
    static let KEY_LANGUAGEITEM_LESSONID = "lessonId"
    static let KEY_LANGUAGEITEM_LOCKED = "locked"
    static let KEY_LANGUAGEITEM_RATING = "rating"
    static let KEY_LANGUAGEITEM_TEXT = "text"
    static let KEY_LANGUAGEITEM_TRANSLITERATION = "transliteration"
    static let KEY_LANGUAGEITEM_VIEWED = "viewed"


    //keys for user purchase 
    
    static let KEY_PURCHASE_AMOUNT = "amountPaid"
    static let KEY_PURCHASE_LOADED = "loaded"
    static let KEY_PURCHASE_ORDERID = "orderId"
    static let KEY_PURCHASE_PRODUCTID = "productId"
    static let KEY_PURCHASE_TIME = "purchaseTime"
    static let KEY_PURCHASE_TOKEN = "purchaseToken"
    static let KEY_PURCHASE_RESPONSEDATA = "responseData"
    static let KEY_PURCHASE_SIGNATURE = "signature"
    static let KEY_PURCHASE_UPLOADED = "uploaded"
    static let KEY_PURCHASE_VALID = "valid"
    
    
    //keys for purchase log
    static let KEY_PURCHASELOG_ERROR = "error"
    static let KEY_PURCHASELOG_ERRORCODE = "errorCode"
    static let KEY_PURCHASELOG_ID = "id"
    static let KEY_PURCHASELOG_LANGUAGE = "language"
    static let KEY_PURCHASELOG_LOADED = "loaded"
    static let KEY_PURCHASELOG_PRODUCTID = "productId"
    static let KEY_PURCHASELOG_TIMESTAMP = "timestamp"
    static let KEY_PURCHASELOG_UPLOADED = "uploaded"
    static let KEY_PURCHASELOG_USERID = "userId"
    
    static let KEY_PURCHASELOG_VALID = "valid"
    
    
    //keys for ratings

    static let KEY_RATINGCOUNTS = "rating_count"

    // file Directories

    static let LOCAL_FILE_ROOT_DIR = "file:\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])"
    static let LOCAL_FILE_IMAGE_DIR = LOCAL_FILE_ROOT_DIR + "/Images"
    static let LOCAL_FILE_AUDIO_DIR = LOCAL_FILE_ROOT_DIR + "/Audio"


    //static let DIRECTORY_LANGU


    //Lang Item Local save keys

    /**
     
     This means the items user can see in the study pages.
     It contains Standard(read - only), Quiz, Jumble items.
     Standard items are always defined as one for each but others will appear automatically when user enter into the study page.
     

     **/

    static let KEY_LANGITEM_TYPE    = "itemType"
    static let KEY_LANGITEM_STATUS  = "answerStatus"
    

    static let VALUE_LANGUITEM_STANDARD = 0
    static let VALUE_LANGUITEM_QUIZ     = 1
    static let VALUE_LANGUITEM_JUMBLE   = 2

    static let VALUE_LANGUSTATUS_CORRECT    = 1
    static let VALUE_LANGUSTATUS_INCORRECT  = 2
    static let VALUE_LANGUSTATUS_FAVORITE   = 3
    static let VALUE_LANGUSTATUS_NOTDETECTED = 0 // initial value


    static let KEY_DIRECTROY_NAME = "name"
    static let KEY_DIRECTORY_SIZE = "size"
    
    static let VALUE_ACTIVITY_LESSON_COMPLETED  = 0
    static let VALUE_ACTIVITY_ITEMVIEWED        = 1
    static let VALUE_ACTIVITY_CORRECT           = 2
    static let VALUE_ACTIVITY_WRONG             = 3
    
    
    

}
