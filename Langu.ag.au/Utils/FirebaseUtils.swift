//
//  FirebaseUtils.swift
//  Langu.ag
//
//  Created by Huijing on 15/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Zip

class FirebaseUtils
{
    static let FIREBASE_CHILD_WELCOME_MASSAGES = "welcome_messages";
    static let FIREBASE_CHILD_USER = "users";
    static let FIREBASE_CHILD_USER_NOTIFICATION_ID = "notificationId";
    static let FIREBASE_CHILD_LOGIN = "login_history";
    static let FIREBASE_CHILD_EUROTALK = "eurotalk";
    static let FIREBASE_CHILD_EUROTALK_CATEGORIES = "categories";
    static let FIREBASE_CHILD_EUROTALK_LANGUAGES = "languages";
    static let FIREBASE_CHILD_EUROTALK_USER_DATA = "user_data";
    static let FIREBASE_CHILD_EUROTALK_USER_LANGUAGES = "user_languages";
    static let FIREBASE_CHILD_EUROTALK_USER_FAVORITES = "favorites";
    static let FIREBASE_CHILD_EUROTALK_USER_ACTIVITY = "userActivity";
    static let FIREBASE_CHILD_EUROTALK_USER_PROGRESS = "userProgress";
    static let FIREBASE_CHILD_EUROTALK_USER_PROGRESS_LESSON_COMPLETED = "completed";

    static let FIREBASE_CHILD_MIGRATED_USERS = "migrated_users";

    static let FIREBASE_CHILD_PURCHASE_LOG = "purchase_log";



    static var FIREBASE_STORAGE_BASE_URL : String!

    static let FIREBASE_STORAGE_AUDIO_URL = FIREBASE_STORAGE_BASE_URL + "/Audio/"
    static let FIREBASE_STORAGE_IMAGE_URL = FIREBASE_STORAGE_BASE_URL + "/Images/Images_400.zip"
    

    static func signIn(email: String, password: String, completion: @escaping(String, Bool) -> ())
    {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {
            (user, error) in
            if error != nil{
                completion("", false)
            }
            else
            {
                UserDefaults.standard.set(email, forKey: Constants.USER_EMAIL)
                UserDefaults.standard.set(password, forKey: Constants.USER_PASSWORD)
                UserDefaults.standard.set((user?.uid)!, forKey: Constants.USER_ID)
                completion((user?.uid)!, true)

            }
        })
    }


    static func signUp(email: String, password: String, completion : @escaping (String, Bool) -> ())
    {

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
            (user, error) in

            if (error == nil){

                let userid = user?.uid
                if userid!.characters.count > 0
                {
                    UserDefaults.standard.set(email, forKey: Constants.USER_EMAIL)
                    UserDefaults.standard.set(password, forKey: Constants.USER_PASSWORD)
                    UserDefaults.standard.set(userid, forKey: Constants.USER_ID)
                    completion(userid!, true)
                }
                else
                {
                    completion(userid!, false)
                }
            }
            else{
                completion("", false)
            }
        })
    }

    static func getDatabase() -> FIRDatabase{
        return FIRDatabase.database()
    }

    static func getWelcomeMessagesRoot() -> FIRDatabaseReference{
        return getDatabase().reference(withPath: FIREBASE_CHILD_WELCOME_MASSAGES)
    }

    static func getMigratedUsersRoot() -> FIRDatabaseReference{
        return getDatabase().reference(withPath: FIREBASE_CHILD_MIGRATED_USERS)
    }

    static func getMigratedLanguagesFromDatabase(userEmail: String) -> FIRDatabaseReference{
        return getMigratedUsersRoot().child(StringUtils.getKeyForFirebase(string: userEmail))
    }


    static func getPurchaseLogRoot() -> FIRDatabaseReference {
        return getDatabase().reference(withPath: FIREBASE_CHILD_PURCHASE_LOG);
    }

    static func getPurchaseLogUserRoot(userId: String) -> FIRDatabaseReference {
        return getPurchaseLogRoot().child(userId);
    }

    static func getUserRoot() -> FIRDatabaseReference{
        return getDatabase().reference(withPath: FIREBASE_CHILD_USER);
    }

    static func getUserRefFromDatabase(userid: String) -> FIRDatabaseReference{
        return getUserRoot().child(userid);
    }

    static func getNotificationIdFromDatabase(userid: String) -> FIRDatabaseReference{
        return getUserRefFromDatabase(userid: userid).child(FIREBASE_CHILD_USER_NOTIFICATION_ID)
    }

    /*static func getUserLogInRoot() -> FIRDatabaseReference{
        return getDatabase().reference(withPath: FIREBASE_CHILD_LOGIN);
    }*/

    static func getUserLogInUser(userid: String) -> FIRDatabaseReference{
        return getDatabase().reference(withPath: FIREBASE_CHILD_LOGIN).child(userid);
    }

    static func getEuroTalkRoot() -> FIRDatabaseReference{
        return getDatabase().reference(withPath: FIREBASE_CHILD_EUROTALK);
    }

    static func getCategoriesFromDatabase() -> FIRDatabaseReference{
    return getEuroTalkRoot().child(FIREBASE_CHILD_EUROTALK_CATEGORIES);
    }

    static func getLanguageCodesFromDatabase(language: String) -> FIRDatabaseReference{
        return getEuroTalkRoot().child(FIREBASE_CHILD_EUROTALK_LANGUAGES).child(language);
    }

    static func getUserLanguagesRoot() -> FIRDatabaseReference {
        return getDatabase().reference(withPath: FIREBASE_CHILD_EUROTALK_USER_LANGUAGES);
    }

    static func getUserLanguages(userid: String) -> FIRDatabaseReference {
        return getUserLanguagesRoot().child(userid)
    }

    static func getEurotalkUserDataRoot(userid: String) -> FIRDatabaseReference {
        return getEuroTalkRoot().child(FIREBASE_CHILD_EUROTALK_USER_DATA).child(userid);
    }

    static func getEurotalkUserDataRoot(userid: String, languageFrom: String) -> FIRDatabaseReference{
        return getEurotalkUserDataRoot(userid: userid).child(languageFrom);
    }

    static func getEurotalkUserDataRoot(userid: String, languageFrom:String, languageTo: String) -> FIRDatabaseReference{
        return getEurotalkUserDataRoot(userid: userid).child(languageFrom).child(languageTo);
    }

    static func getLanguageFavoriteCodesFromDatabase(userid:String, languageFrom: String, languageTo: String) -> FIRDatabaseReference{
        return getEurotalkUserDataRoot(userid:userid, languageFrom: languageFrom,languageTo: languageTo).child(FIREBASE_CHILD_EUROTALK_USER_FAVORITES);
    }

    static func getUserProgressRoot(userid: String, languageFrom: String, languageTo: String) -> FIRDatabaseReference{
        return getEurotalkUserDataRoot(userid: userid, languageFrom: languageFrom, languageTo: languageTo).child(FIREBASE_CHILD_EUROTALK_USER_PROGRESS);
    }

    static func getUserLessonProgress(userid: String, languageFrom: String, languageTo: String, lessonId: String) -> FIRDatabaseReference{
        return getEurotalkUserDataRoot(userid: userid, languageFrom: languageFrom, languageTo: languageTo).child(FIREBASE_CHILD_EUROTALK_USER_PROGRESS).child(lessonId);
    }


    static func getUserActivityFromDatabase(userid: String, languageFrom: String, languageTo: String) -> FIRDatabaseReference{
        return getEurotalkUserDataRoot(userid: userid, languageFrom: languageFrom, languageTo: languageTo).child(FIREBASE_CHILD_EUROTALK_USER_ACTIVITY);
    }

    static func getStorageRootReference() -> FIRStorageReference{
        return FIRStorage.storage().reference()
    }

    static func getStorageReference(url: String) -> FIRStorageReference{
        return FIRStorage.storage().reference(forURL: url)
    }

    static func getImagesStorageRootReference() -> FIRStorageReference{
        return getStorageRootReference().child("Images")
    }

    static func getUserDataStorageRootReference() -> FIRStorageReference{
        return getStorageRootReference().child("User Data")
    }

    static func getUserProfilePicturesStorageRootReference() -> FIRStorageReference{
        return getUserDataStorageRootReference().child("profile_pictures")
    }

    static func getUserProfilePicturesStorageRootReference(userid: String) -> FIRStorageReference{
        return getUserProfilePicturesStorageRootReference().child(userid);
    }

    static func getAudioStorageRootReference() -> FIRStorageReference{
        return getStorageRootReference().child("Audio");
    }

/*
    static func getWelcomeMessage(completion: @escaping (Bool, String) -> ()){
        let ref = FIRDatabase.database().reference(withPath: FIREBASE_CHILD_WELCOME_MASSAGES)
        ref.queryLimited(toLast: 20).observeSingleEvent(of: .value, andPreviousSiblingKeyWith:  {
            snapshot, msg in
            let message = snapshot.children.allObjects
            NSLog("\(snapshot)")
            completion(true,message[0].value);

        }, withCancel: {
            error in
            print(error.localizedDescription)
            
        })
    }*/

//    static func getLanguageData()

    static func getUserFromDatabase(userid: String, completion: @escaping (Bool, UserModel) -> ())
    {
        if(!userid.isEmpty){
            getUserRefFromDatabase(userid: userid).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
                dataSnapshot, message in
                let user = UserModel()
                NSLog("\(dataSnapshot)")
                NSLog("\(message)")
                if(dataSnapshot.exists()){

                    if(dataSnapshot.hasChild("uid")){
                        user.user_uid = (dataSnapshot.childSnapshot(forPath: "uid").value as! String)
                    }
                    else{
                        completion(false, user)
                    }
                    if(dataSnapshot.hasChild("provideId")){
                        user.user_provideid = (dataSnapshot.childSnapshot(forPath: "provideId").value as! String)
                    }

                    if(dataSnapshot.hasChild("email")){
                        user.user_email = (dataSnapshot.childSnapshot(forPath: "email").value as! String)
                    }
                    if(dataSnapshot.hasChild("displayName")){
                        user.user_displayname = (dataSnapshot.childSnapshot(forPath: "displayName").value as! String)
                        UserDefaults.standard.set(user.user_displayname, forKey: Constants.KEY_USER_DISPLAYNAME)
                    }
                    if(dataSnapshot.hasChild("photoUrl")){
                        user.user_photourl = (dataSnapshot.childSnapshot(forPath: "photoUrl").value as! String)
                        UserDefaults.standard.set(user.user_displayname, forKey: Constants.KEY_USER_PHOTOURL)
                    }

                    if(dataSnapshot.hasChild("languageFrom")){
                        user.user_languagefrom = (dataSnapshot.childSnapshot(forPath: "languageFrom").value as! String)

                        UserDefaults.standard.set(user.user_languagefrom, forKey: Constants.KEY_USER_LANGUAGEFROM)
                    }
                    if(dataSnapshot.hasChild("languageTo")){
                        user.user_languageto = (dataSnapshot.childSnapshot(forPath: "languageTo").value as! String)

                        UserDefaults.standard.set(user.user_languageto, forKey: Constants.KEY_USER_LANGUAGETO)
                    }

                    if(dataSnapshot.hasChild("isAdmin")){
                        user.user_admin = (dataSnapshot.childSnapshot(forPath: "isAdmin").value as! Bool)
                    }
                    if(dataSnapshot.hasChild("updateTimeStamp")){
                        user.user_updatetimestamp = (dataSnapshot.childSnapshot(forPath: "updateTimeStamp").value as! Int64);
                    }

                    completion(true, user)
                }
                else{
                    completion(false, user)
                }
            }, withCancel: {
                error in
                print(error.localizedDescription)
            })
        }
    }


    static func insertOrUpdateUser(user: UserModel, checkTimeStamp: Bool){
        if(checkTimeStamp){
            return getUserRefFromDatabase(userid: user.user_uid).setValue(user.getObject())
        }
    }

    static func isUserMigrated(userId: String, userEmail: String, completion: @escaping (Bool) -> ()){
       
        getMigratedUsersRoot().observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, message in
            NSLog("\(message)")
            var isMiraged = false
            let childSnapshots = dataSnapshot.value as! NSDictionary
            for childSnapshot in childSnapshots.allValues{
                if ((childSnapshot as! String) == userEmail)
                {
                    isMiraged = true
                    break
                }
            }
            completion(isMiraged)

        }, withCancel: {
            error in
            print(error.localizedDescription)
        })
    }
  
    static func saveUserPurchasedLanguagesLocally(userId: String, completion: @escaping(Bool) -> ()){
        getUserLanguages(userid: userId).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, error in
            
            if error != nil{
                completion(false)
            }
            else{
                let rawData = dataSnapshot.children.allObjects as? [FIRDataSnapshot]
                for i in 0..<(rawData?.count)!
                {
                    FirebaseDataParse.saveUserLanguagesLocally(rawData: (rawData?[i].value as? NSDictionary)!)
                }
                
                completion(true)
            }
            
        }, withCancel: {
            error in
            print(error.localizedDescription)
            completion(false)
        })
    
    }
    

    ///////////////////////******************** Unemployeed functions******************** /////////////////
    static func saveCategoriesLocally(completion: @escaping (Bool) -> ()) {
        getCategoriesFromDatabase().observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, error in

            if error != nil{
                completion(false)
            }
            else{
                let rawData = dataSnapshot.children.allObjects as? [FIRDataSnapshot]
                for i in 0..<(rawData?.count)!
                {
                    FirebaseDataParse.saveCategoryDataToLocal(rawData: (rawData?[i].value as? NSDictionary)!)
                }

                completion(true)
            }

        }, withCancel: {
            error in
            print(error.localizedDescription)
            completion(false)
        })
    }

    static func saveLanguageCodesLocally(language: String,completion: @escaping (Bool) -> ()){
        getLanguageCodesFromDatabase(language: language).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, error in

            if error != nil{
                completion(false)
            }
            else{
                let rawData = dataSnapshot.value as AnyObject
                for key in rawData.allKeys
                {
                    var languageItemData = rawData[key] as! [String: AnyObject]
                    languageItemData[Constants.KEY_LESSON_CODEID] = key as AnyObject
                    languageItemData[Constants.KEY_LANGUAGE_SHORTNAME] = language as AnyObject?
                    FirebaseDataParse.saveLanugageDataToLocal(rawData: languageItemData, language: language)
                }

                completion(true)
            }
        }, withCancel: {
            error in
            print(error.localizedDescription)
        })
    }

    static func saveFavoritesLocally(userid: String, lanuageFrom: String, languageTo: String, completion: @escaping(Bool) -> ()){
        getLanguageFavoriteCodesFromDatabase(userid: userid, languageFrom: lanuageFrom, languageTo: languageTo).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, message in
            
        }, withCancel: {
            error in
            print(error.localizedDescription)
        })
    }

    static func saveUserProgressLocally(userid: String, languageFrom: String, languageTo: String, completion: (Bool) -> ()){
        getUserProgressRoot(userid: userid, languageFrom: languageFrom, languageTo: languageTo).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, message in

        }, withCancel: {
            error in
            print(error.localizedDescription)
        })

    }

    static func saveUserActivityLocally(userid: String, languageFrom: String, languageTo: String, completion: @escaping (Bool) -> ()){
        getUserActivityFromDatabase(userid: userid, languageFrom: languageFrom, languageTo: languageTo).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, error in
            if error == nil
            {
                let rawData = dataSnapshot.children.allObjects as? [FIRDataSnapshot]
                for i in 0..<(rawData?.count)!
                {
                    FirebaseDataParse.saveUserActivityToLocal(rawData: (rawData?[i].value as? [String: AnyObject])!, languageFrom: languageFrom, languageTo: languageTo)
                }
                
                let objectToPrefix = "language/" + languageTo + "/"
                FirebaseDataParse.setLanguItemsFromUserActivity(objectToPrefix: objectToPrefix)
                completion(true)
            }
            else{
                completion(false)
            }

        }, withCancel: {
            error in
            print(error.localizedDescription)
            completion(false)
        })

    }

    static func isLessonComplete(userid: String, languageFrom: String, languageTo: String, lessonId: String, completion: @escaping(Bool) -> ()){
        getUserLessonProgress(userid: userid, languageFrom: languageFrom, languageTo: languageTo, lessonId: lessonId).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, message in

        }, withCancel: {
            error in
            print(error.localizedDescription)
        })
    }

    static func isLessonComplete(snapshot: FIRDataSnapshot) -> Bool{
        if snapshot.exists(){
            if snapshot.hasChild(FIREBASE_CHILD_EUROTALK_USER_PROGRESS){
                return snapshot.value as! Bool
            }
        }
        return false
    }

    static func setLessonComplete(userid: String, languageFrom: String, languageTo: String, lessonId: String, completed: Bool)
    {
        getUserLessonProgress(userid: userid, languageFrom: languageFrom, languageTo: languageTo, lessonId: lessonId).child(FIREBASE_CHILD_EUROTALK_USER_PROGRESS_LESSON_COMPLETED).setValue(completed)
    }

    static func addFavorite(userid: String, favorite: String, completion: @escaping (Bool) -> ()){
        getLanguageFavoriteCodesFromDatabase(userid: userid, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, error in
            if error == nil
            {
                let rawData = dataSnapshot.children.allObjects as? [FIRDataSnapshot]
                
                for i in 0..<(rawData?.count)!
                {
                    let codeId = rawData?[i].value as! String
                    if codeId == favorite{
                        completion(true)
                        return
                    }
                }
                var keyvalue = "0"
                if (rawData?.count)! > 0
                {
                    keyvalue = "\(Int((rawData?[(rawData?.count)! - 1].key)!)! + 1)"
                }
                
                getLanguageFavoriteCodesFromDatabase(userid: userid, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto).child(keyvalue).setValue(favorite, withCompletionBlock:{error,snapshot in
                    if error != nil{
                        completion(false)
                    }
                    else{
                        completion(true)
                    }
                })
            }
            else{
                let keyvalue = "0"
                getLanguageFavoriteCodesFromDatabase(userid: userid, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto).child(keyvalue).setValue(favorite, withCompletionBlock:{error,snapshot in
                    if error != nil{
                        completion(false)
                    }
                    else{
                        completion(true)
                    }
                })
            }
            
        }, withCancel: {
            error in
            print(error.localizedDescription)
            completion(false)
        })
    }

    static func removeFavorite(userid: String, languageFrom: String, languageTo: String, code: String, completion: @escaping (Bool) -> ()){
        getLanguageFavoriteCodesFromDatabase(userid: userid, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            dataSnapshot, error in
            if error == nil
            {
                let rawData = dataSnapshot.children.allObjects as? [FIRDataSnapshot]
                
                if (rawData?.count)! > 0{
                    for i in 0..<(rawData?.count)!
                    {
                        let codeId = rawData?[i].value as! String
                        let keyvalue = rawData?[i].key
                        if codeId == code{
                            getLanguageFavoriteCodesFromDatabase(userid: userid, languageFrom: languageFrom, languageTo: languageTo).child(keyvalue!).removeValue(completionBlock: {
                                error, dataSnapshot in
                                if error == nil{
                                    completion(true)
                                }
                                else{
                                    completion(false)
                                }
                            })
                        }
                    }
                }
                else{
                    completion(true)
                }
            }
            else{
                completion(false)
            }
            
        }, withCancel: {
            error in
            print(error.localizedDescription)
        })
    }
 

    static func saveUserLogInActivity(userLoginActivity: UserLoginActivityModel, completion: @escaping (Bool) -> ()){
        getUserLogInUser(userid: userLoginActivity.userloginactivity_user.user_uid).child("\(userLoginActivity.userloginactivity_timestamp)").setValue(userLoginActivity.getObject(), withCompletionBlock: {
            error, dataSnapShot in
            if error != nil{
                completion(true)
            }
            else{
                completion(false)
            }
            
        })//.setValue(userLoginActivity.getObject())*/
    }

    static func saveUserActivity(userid: String, languageFrom: String, languageTo: String, userActivity: AnyObject, completion: @escaping (Bool) -> ()){
        
        var uploadObject = userActivity as! [String: AnyObject]
        uploadObject[UserActivityModel.TABLE_KEY_UPLOADED] = true as AnyObject
        getUserActivityFromDatabase(userid: userid, languageFrom: languageFrom, languageTo: languageTo).childByAutoId().setValue(uploadObject, withCompletionBlock: {
            datSnapshot, error in
            completion(true)
        })
    }

    static func saveUserProgress(userid: String, lessonId: String){
        getUserProgressRoot(userid: userid, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto).child(lessonId).child("completed").setValue(true)
    }

    static func downLoadImages( completion: @escaping(Bool) -> ()){

        let filePath = Constants.LOCAL_FILE_IMAGE_DIR + "/Images.zip"

        let fileManager = FileManager.default
        if(fileManager.fileExists(atPath: filePath)){
            do {
                try fileManager.removeItem(atPath: filePath)
            }
            catch{

            }
        }
        let fileURL = URL(string: "\(filePath)" as String)!

        let storageRef = getStorageReference(url: FirebaseUtils.FIREBASE_STORAGE_IMAGE_URL)
        // Create a reference to the file we want to download

        NSLog("Audio storageurl = \(storageRef.fullPath)")

        // Start the download (in this case writing to a file)
        storageRef.write(toFile: fileURL, completion: { (url, error) in
            if let error = error {
                print("Error downloading:\(error)")
                //self.statusTextView.text = "Download Failed"
                completion(false)
            } else if (url?.path) != nil {
                do {
                    let unZipDirectory = try Zip.quickUnzipFile(fileURL)
                    NSLog(unZipDirectory.path)
                }
                catch{
                    
                }
                completion(true)
            }
        })
    }


    static func downLoadAudio(language: String, completion: @escaping (Bool) -> ()){


        let filePath = Constants.LOCAL_FILE_AUDIO_DIR + "/Audio.zip"

        NSLog("Audio file path = \(filePath)")

        let fileManager = FileManager.default
        if(fileManager.fileExists(atPath: filePath)){
            do {
                try fileManager.removeItem(atPath: filePath)
            }
            catch{

            }
        }
        let fileURL = URL(string: "\(filePath)")!

        let storageRef = getStorageReference(url: FirebaseUtils.FIREBASE_STORAGE_AUDIO_URL + language + ".zip")
        // Create a reference to the file we want to download

        // Start the download (in this case writing to a file)
        storageRef.write(toFile: fileURL, completion: { (url, error) in
            if let error = error {
                print("Error downloading:\(error)")
                //self.statusTextView.text = "Download Failed"
                completion(false)
            } else if let _ = url?.path {
                do {
                    let unZipDirectory = try Zip.quickUnzipFile(fileURL)
                    NSLog(unZipDirectory.path)
                }
                catch{

                }
                completion(true)
            }
        })

    }

    static func uploadProfilePictureAndUpdate(userid: String, image: UIImage?, completion: @escaping(Bool) -> ()){
        if image == nil{
            completion(true)
        }
        else{
            let data = UIImageJPEGRepresentation(image!, 0.5)
            _ = getUserProfilePicturesStorageRootReference(userid: userid).child("profile_\(userid).jpg").put(data!, metadata: nil){
                metadata, error in
                if(error != nil)
                {
                    completion(false)
                }
                else{
                    completion(true)
                }
            }
        }
    }

    static func addLanguage(userid: String, languageObject: AnyObject, completion: @escaping (Bool) -> ()){
        getUserLanguages(userid: userid).child(languageObject.value(forKey: Constants.KEY_LANGUAGE_NAME) as! String).setValue(languageObject, withCompletionBlock: {
            error, result in
            if error != nil{
                completion(true)
            }
            else {
                completion(false)
            }
        })
    }



}
