//
//  FMDBManager.swift
//  Langu.ag
//
//  Created by Huijing on 14/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//



import Foundation
import FMDB

class FMDBManager{

    var fileURL: URL!
    var database : FMDatabase!

    init(){
        
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(Constants.dbname)

        database = FMDatabase(path: fileURL.path)
        if(database == nil)
        {
            return
        }

        //emptyTables()

        createTables()

    }


    func createTables()
    {
        database.open()
        do {
            //create categories table


            try database.executeUpdate(createTableString(tableName: CategoryModel.localTableName, tableObject: CategoryModel.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: LessonModel.localTableName, tableObject: LessonModel.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: LessonCodesModel.localTableName, tableObject: LessonCodesModel.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: LanguageItemModel.localTableName, tableObject: LanguageItemModel.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: LanguItem.localTableName, tableObject: LanguItem.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: UserLoginActivityModel.localTableName, tableObject: UserLoginActivityModel.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: UserLanguageModel.localTableName, tableObject: UserLanguageModel.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: UserPurchase.localTableName, tableObject: UserPurchase.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: UserActivityModel.localTableName, tableObject: UserActivityModel.localTableString), values: nil)
            try database.executeUpdate(createTableString(tableName: FavoriteModel.localTableName, tableObject: FavoriteModel.localTableStringTemp), values: nil)
             

        } catch {
            print("failed: \(error.localizedDescription)")
        }
        database.close()

    }

    func emptyTables()
    {
        database.open()
        do{
            try database.executeUpdate("DROP TABLE " + CategoryModel.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + LessonModel.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + LessonCodesModel.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + LanguageItemModel.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + LanguItem.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + UserLoginActivityModel.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + UserLanguageModel.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + UserPurchase.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + UserActivityModel.localTableName, values: nil)
            try database.executeUpdate("DROP TABLE " + FavoriteModel.localTableName, values: nil)
        }
        catch{
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }

    func deleteUserData()
    {
        database.open()
        do{
            try database.executeUpdate("DELETE FROM " + LanguItem.localTableName, values: nil)
            try database.executeUpdate("DELETE FROM " + UserLoginActivityModel.localTableName, values: nil)
            try database.executeUpdate("DELETE FROM " + UserLanguageModel.localTableName, values: nil)
            try database.executeUpdate("DELETE FROM " + UserPurchase.localTableName, values: nil)
            try database.executeUpdate("DELETE FROM " + UserActivityModel.localTableName, values: nil)
            try database.executeUpdate("DELETE FROM " + FavoriteModel.localTableName, values: nil)
        }
        catch{
            print("failed: \(error.localizedDescription)")
        }

        database.close()
    }

    func truncateTable(tableName: String)
    {
       executeQuery("DELETE FROM \(tableName)")
    }
    
    func executeQuery(_ query: String){
        database.open()
        do {
            try database.executeUpdate(query, values: nil)
        }
        catch{
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }

    func createTableString(tableName: String, tableObject: Any?) -> String{
        let tableDict  = tableObject as! NSDictionary
        let keys = tableDict.allKeys
        var resultString = "CREATE TABLE IF NOT EXISTS " + tableName + "("
        for i in 0..<keys.count{
            resultString = resultString + (keys[i] as! String) + " " + (tableDict[keys[i]] as! String) + " ,"
        }

        resultString.remove(at: resultString.index(before: resultString.endIndex))
        resultString.append(")")

        return resultString
    }

    func insertRecord(tableObject: Any?, tableName: String, tableData: Any, primaryKey: String) {

        database.open()
        let tableDict = tableObject as! NSDictionary
        let keys = tableDict.allKeys

        let values = tableData as! NSDictionary

        var insertString = "INSERT INTO \(tableName) "
        var keysString = "("
        var valuesString = "("

        for key in keys{

            keysString.append("\(key),")
            valuesString += " '"
            var valueString = "\(values[key] as AnyObject)"
            valueString = valueString.replacingOccurrences(of: "'", with: "''")

            valuesString += valueString + "' ,"

        }
        keysString.remove(at: keysString.index(before: keysString.endIndex))
        keysString.append(") values ")

        valuesString.remove(at: valuesString.index(before: valuesString.endIndex))
        valuesString.append(")")

        insertString.append(keysString)
        insertString.append(valuesString.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")',", with: "',"))

        do{
            try database.executeUpdate(insertString, values: nil)
        }
        catch{
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
    }


    func UpdateRecord(tableObject: Any?, tableName: String, tableData: Any,  matchKeys:[String]){

        database.open()
        let tableDict = tableObject as! NSDictionary
        let keys = tableDict.allKeys

        let values = tableData as! NSDictionary
        var insertString = "UPDATE \(tableName) SET "
        var valuesString = ""
        var matchItemsCompareString = " WHERE "
        for matchKey in matchKeys{
            matchItemsCompareString += "\(matchKey as AnyObject) = '\(values[matchKey] as AnyObject)' AND "
        }
        matchItemsCompareString.append("====")
        matchItemsCompareString = matchItemsCompareString.replacingOccurrences(of: "AND ====", with: "")

        for key in keys{
            var valueString = ""


            valuesString += "\(key) = '"
            valueString = "\(values[key] as AnyObject)"
            valueString = valueString.replacingOccurrences(of: "'", with: "''")
            valueString.append("'")

            valuesString += valueString + " ,"

        }

        valuesString.remove(at: valuesString.index(before: valuesString.endIndex))
        insertString.append(valuesString.replacingOccurrences(of: ")',", with: "',"))
        insertString.append(matchItemsCompareString)

        do{
            try database.executeUpdate(insertString, values: nil)
        }
        catch{
            print("failed: \(error.localizedDescription)")
        }
        database.close()

    }
    

    func insertLesson(lesson: LessonModel) {

        database.open()

        let insertString = "INSERT INTO \(LessonModel.localTableName) (\(Constants.KEY_LESSON_ID),\(Constants.KEY_CATEGORY_ID), \(Constants.KEY_LESSON_ORDER)) VALUES (\(lesson.lesson_id),'\(lesson.lesson_categoryid)',\(lesson.lesson_order))"

        do{
            try database.executeUpdate(insertString, values: nil)
        }
        catch{
            print("failed: \(error.localizedDescription)")
        }


        database.close()
        
    }

    func insertCode(code: LessonCodesModel){
        database.open()
        let insertString = "INSERT INTO " + Constants.DIRECTORY_CODES + " (\(Constants.KEY_LESSON_ID),\(Constants.KEY_LESSON_CODEID), \(Constants.KEY_LESSON_CODEORDER)) VALUES ('\(code.lessoncode_lessonid)'" + ",'" + code.lessoncode_value + "','\(code.lessoncode_order)')"


        do{
            try database.executeUpdate(insertString, values: nil)
        }
        catch{
            print("failed: \(error.localizedDescription)")
        }
        database.close()
    }
    
    func getDataFromFMDB(with query: String, tableObject: [String: String]) -> [AnyObject]{

        var result : [AnyObject] = []

        database.open()
        do{
            let rs = try database.executeQuery(query, values: nil)

            while rs.next(){
                var resultItem : [String: AnyObject] = [:]
               
                for item in tableObject{
                    resultItem[item.key] = getObjectFromKey(value: rs, type: item.value, key: item.key)
                }
                result.append(resultItem as AnyObject)
            }

        }catch {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        return result
    }


    func getObjectFromKey(value: FMResultSet, type: String, key: String) -> AnyObject{
        
        if value.columnIsNull(key){
            if (type.hasPrefix("TEXT")){
                return "" as AnyObject
            }
            else if(type.hasPrefix("TINYINT")){
                return false as AnyObject
            }
            else if(type.hasPrefix("BIGINT")){
                return 0 as AnyObject
            }
            else if(type.hasPrefix("INT"))
            {
                return 0 as AnyObject
            }
        }
        if (type.hasPrefix("TEXT")){
            return value.string(forColumn: key) as AnyObject
        }
        else if(type.hasPrefix("TINYINT")){
            return value.bool(forColumn: key) as AnyObject
        }
        else if(type.hasPrefix("BIGINT")){
            return value.longLongInt(forColumn: key) as AnyObject
        }
        else if(type.hasPrefix("INT"))
        {
            return Int(value.string(forColumn: key)) as AnyObject
        }
        return "" as AnyObject
    }

    func isDataExists(language: String) -> Bool{
        let query = "SELECT * FROM \(LanguageItemModel.localTableName) where \(Constants.KEY_LANGUAGE_SHORTNAME) = '\(StringUtils.getLanguageShortNameLowerCase(languageName: language))'/* and \(Constants.KEY_LANGUAGEITEM_COMPLEXITY)*/"
        let count = getDataFromFMDB(with: query, tableObject: LanguageItemModel.localTableString).count
        if count == 0
        {
            return false
        }
        else{
            if (language == currentUser.user_languagefrom || language == currentUser.user_languageto){
                return true
            }
            else{
                if GetDataFromFMDBManager.getLanguagePurchased(language: language){
                    return true
                }
                else {
                    return false
                }
            }
            
        }

    }
}


var fmdbManager = FMDBManager()
