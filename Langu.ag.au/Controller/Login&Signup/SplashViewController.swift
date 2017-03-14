//
//  SplashViewController.swift
//  Langu.au
//
//  Created by Huijing on 09/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {


    var timer : Timer!

    var allLoaded = 0

    @IBOutlet weak var titleImageConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(_ animated: Bool) {
        
        if UserAuthUtils.setDataFromUserDefault(){
            
            if currentUser.user_languagefrom.characters.count > 0{
                
                let existsMyLanguage = fmdbManager.isDataExists(language: currentUser.user_languagefrom)
                var existsLearningLanguage = fmdbManager.isDataExists(language: currentUser.user_languageto)
                
                
                if existsMyLanguage && existsLearningLanguage{
                    currentUser.user_loaded = true
                    let loginActivity = UserLoginActivityModel()
                    loginActivity.userloginactivity_loaded = true
                    loginActivity.userloginactivity_user = currentUser
                    loginActivity.userloginactivity_timestamp = getGlobalTime()
                    FMDBManagerSetData.saveUserLoginActivity(loginActivity: loginActivity)
                    let activities = GetDataFromFMDBManager.getUnloadedLoginActivity()
                    for activity in activities{
                        activity.userloginactivity_uploaded = true
                        FirebaseUtils.saveUserLogInActivity(userLoginActivity: activity, completion: {
                            success in
                            if success{
                                FMDBManagerSetData.setActivitieUploaded(activity.userloginactivity_timestamp)
                            }
                        })
                        
                    }
                    //}
                    gotoMainScene()
                    
                }
                else{
                    self.allLoaded = 0
                    //loading data from server
                    if (!existsMyLanguage && !existsLearningLanguage){
                        fmdbManager.emptyTables()
                        fmdbManager.createTables()
                        
                        FirebaseUtils.saveCategoriesLocally(completion: {
                            success in
                            if success{
                            }
                            
                        })
                        FirebaseUtils.downLoadImages(completion: {
                            success in
                            self.allLoaded += 1
                            self.completedDownloading()
                        })
                        
                    }
                    else{
                        self.allLoaded += 1
                        self.completedDownloading()
                    }
                    
                    
                    if currentUser.user_languagefrom == currentUser.user_languageto{
                        existsLearningLanguage = true
                    }
                    
                    if !existsMyLanguage{
                        
                        //get language codes
                        FirebaseUtils.saveLanguageCodesLocally(language: StringUtils.getLanguageShortNameLowerCase(languageName: currentUser.user_languagefrom), completion: {
                            success in
                            
                            self.allLoaded += 1
                            self.completedDownloading()
                        })
                    }
                    else {
                        self.allLoaded += 1
                    }
                    if !existsLearningLanguage{
                        
                        FirebaseUtils.saveLanguageCodesLocally(language: StringUtils.getLanguageShortNameLowerCase(languageName: currentUser.user_languageto), completion: {
                            success in
                            FirebaseUtils.downLoadAudio(language: StringUtils.getTalkNowLanguageName(language: currentUser.user_languageto), completion: {
                                success in
                                self.allLoaded += 1
                                self.completedDownloading()
                            })
                            
                        })
                    }
                    else{
                        self.allLoaded += 1
                    }
                    
                }
                
                
            }
            else{
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectMyLangViewController")
                // [3] Display the new view controller.
                self.navigationController?.pushViewController(controller!, animated: true)
            }
            
        }
        else{
            gotoLogin()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(showCustomLoadingView), userInfo: nil, repeats: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func showCustomLoadingView()
    {
        if(titleImageConstraint.constant >= 0.2)
        {
            titleImageConstraint.constant -= 0.2
        }
        else
        {
            titleImageConstraint.constant = 0
            timer.invalidate()

        }
    }

    func gotoLogin(){
        if timer != nil{
            if timer.isValid{
                timer.invalidate()
            }
        }
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }

    func gotoSelectLanguage(){
        let selectLangVC = storyboard?.instantiateViewController(withIdentifier: "SelectMyLangViewController")
        self.navigationController?.pushViewController(selectLangVC!, animated: true)
    }


    func completedDownloading(){
        if allLoaded == 3 {
            currentUser.user_loaded = true
            UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                
                self.gotoMainScene()
            })
        }
    }


    func gotoMainScene()
    {
        if timer != nil{
            if timer.isValid{
                timer.invalidate()
            }
        }
        // [2] Create an instance of the storyboard's initial view controller.
        FMDBManagerSetData.uploadUserActivities(completion: {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTab")
            // [3] Display the new view controller.
            self.present(controller!, animated: true, completion: nil)
        })
        
    }

/*
    func showWelcomeMessage(){
        FirebaseUtils.getWelcomeMessage(completion: {
            success, message in
            if success{
                self.showToastWithDuration(string: "Succeed in access", duration: 3.0)
            }
        
        })
    }

*/
}
