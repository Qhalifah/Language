//
//  DashboardViewController.swift
//  Langu.au
//
//  Created by Huijing on 09/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class DashboardViewController: BaseViewController {

    @IBOutlet weak var monProgView: UIView!
    @IBOutlet weak var tueProgView: UIView!
    @IBOutlet weak var wedProgView: UIView!
    @IBOutlet weak var thuProgView: UIView!
    @IBOutlet weak var friProgView: UIView!
    @IBOutlet weak var satProgView: UIView!
    @IBOutlet weak var sunProgView: UIView!


    var purchaseView: UIView!

    var available = false

    @IBOutlet weak var lblCategoryCompleted: UILabel!
    @IBOutlet weak var lblCategroyCount: UILabel!

    @IBOutlet weak var lblLessonCompleted: UILabel!
    @IBOutlet weak var lblLessonCount: UILabel!

    @IBOutlet weak var lessonProgressView: KDCircularProgress!
    @IBOutlet weak var categoryProgressView: KDCircularProgress!

    @IBOutlet weak var lblXpPoints: UILabel!

    @IBOutlet weak var lblLearntCount: UILabel!
    @IBOutlet weak var lblFavoriteCount: UILabel!

    @IBOutlet weak var lblLearningLanguage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        let screenSize = UIScreen.main.bounds.size
        let weekdayCornerRadius = (screenSize.width - (8 * 6) - 70) / 14
        monProgView.layer.cornerRadius = weekdayCornerRadius
        tueProgView.layer.cornerRadius = weekdayCornerRadius
        wedProgView.layer.cornerRadius = weekdayCornerRadius
        thuProgView.layer.cornerRadius = weekdayCornerRadius
        friProgView.layer.cornerRadius = weekdayCornerRadius
        satProgView.layer.cornerRadius = weekdayCornerRadius
        sunProgView.layer.cornerRadius = weekdayCornerRadius
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated : Bool){
        //lessonProgressView.
        super.viewWillAppear(animated)
        setUI()

    }
    
    func setUI(){
        
        lblLearningLanguage.text = currentUser.user_languageto
        GetDataFromFMDBManager.getCategoryDataFromLocal()
        let favoriteCount = GetDataFromFMDBManager.getFavoriteItems(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto).count
        var categoryCompletedCount = 0
        var lessonCompletedCount = 0
        var totalLessonCount = 0
        
        
        //set progressView
        for category in shared_categories{
            if category.category_lessons.count == category.category_completedlessoncount {
                categoryCompletedCount += 1
            }
            lessonCompletedCount += category.category_completedlessoncount
            totalLessonCount += category.category_lessons.count
        }
        categoryProgressView.angle = 360 * Double(categoryCompletedCount) / Double(shared_categories.count)
        lessonProgressView.angle = 360 * Double(lessonCompletedCount) / Double(totalLessonCount)
        lblCategroyCount.text = "\(shared_categories.count)"
        lblCategoryCompleted.text = "\(categoryCompletedCount)"
        
        lblLessonCount.text = "\(totalLessonCount)"
        lblLessonCompleted.text = "\(lessonCompletedCount)"
        
        let totallearnt = GetDataFromFMDBManager.getTotalLearnt(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
        lblXpPoints.text = "\(GetDataFromFMDBManager.getPoints(totallearnt))"
        
        lblLearntCount.text = "\(totallearnt.0)"
        lblFavoriteCount.text = "\(favoriteCount)"
        setAchievedDays()
    }
    
    func setAchievedDays(){
        let activateDays = GetDataFromFMDBManager.getDaysOfActivity()
        for activateDay in activateDays{
            self.view.viewWithTag(activateDay * 10)?.backgroundColor = UIColor(colorLiteralRed: 3.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        }
        
    }

    @IBAction func learnNewLanguageButtonTapped(_ sender: Any) {

        let selectLangVC = storyboard?.instantiateViewController(withIdentifier: "SelectLangaugeViewController")
        self.view.addSubview((selectLangVC?.view)!)
        self.addChildViewController(selectLangVC!)
        available = true
    }

    //Mark change language

    override func changeLanguage() {

        if (available){
            if fmdbManager.isDataExists(language: SelectLangaugeViewController.selectedLanaguage){
                
                currentUser.user_languageto = SelectLangaugeViewController.selectedLanaguage                
                UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                    self.viewWillAppear(true)
                })
            }
            else{
                downLoadLanguage()
            }
            
            
        }

    }



    override func addInAppPurchaseView() {
        
     
        if available{
            available = false

            let language = SelectLangaugeViewController.selectedLanaguage
            
            if GetDataFromFMDBManager.getLanguagePurchased(language: language){
                downLoadLanguage()
                return
            }
            purchaseView = UIView()
            purchaseView.frame = self.view.frame
            purchaseView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.4)


            let subView = UIView()

            subView.frame = CGRect(x: 20, y: self.view.frame.size.height / 2 - 125,  width: self.view.frame.size.width - 40, height: 250)
            subView.backgroundColor = UIColor.white


            var label = UILabel()
            label.frame = CGRect(x: 20, y: 20,  width: subView.frame.size.width - 40, height: 50)
            label.text = "Unlock \(language) Language"
            label.numberOfLines = 0
            subView.addSubview(label)


            label = UILabel()
            label.numberOfLines = 0
            label.frame = CGRect(x: 20, y: 70,  width: subView.frame.size.width - 40, height: 50)
            label.text = "Please see below options to unlock more languages"
            subView.addSubview(label)

            var button = UIButton()
            button.titleLabel?.numberOfLines = 0
            button.backgroundColor = .red
            button.frame = CGRect(x: 20, y: 130,  width: subView.frame.size.width - 40, height: 50)
            button.setTitle("Unlock All Languages: $4.99", for: .normal)
            button.titleLabel?.textAlignment = .left
            button.titleLabel?.textColor = UIColor.init(red: 79.0 / 255.0, green: 195.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)

            button.addTarget(self, action: #selector(unlockAll), for: .touchUpInside)
            subView.addSubview(button)

            button = UIButton()
            button.titleLabel?.numberOfLines = 0
            button.backgroundColor = .red
            button.frame = CGRect(x: 20, y: 190,  width: subView.frame.size.width - 40, height: 50)
            button.setTitle("Unlock \(language): $0.99", for: .normal)
            button.titleLabel?.textAlignment = .left
            button.titleLabel?.textColor = UIColor.init(red: 79.0 / 255.0, green: 195.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
            button.addTarget(self, action: #selector(unlockLanguage), for: .touchUpInside)
            subView.addSubview(button)

            button = UIButton()
            button.setImage(UIImage(named: "icon_close"), for: .normal)
            button.backgroundColor = .lightGray
            button.frame = CGRect(x: subView.frame.size.width - 30, y: 0,  width: 30, height: 30)
            subView.addSubview(button)
            button.addTarget(self, action: #selector(removePurchaseView), for: .touchUpInside)
            purchaseView.addSubview(subView)
            self.view.addSubview(purchaseView)
        }
    }

    func removePurchaseView(){
        self.view.isUserInteractionEnabled = true
        self.navigationController?.tabBarController?.view.isUserInteractionEnabled = true
        purchaseView.removeFromSuperview()
    }


    func downLoadLanguage() {

        currentUser.user_languageto = SelectLangaugeViewController.selectedLanaguage

        UpdateContents.updateFirebaseUser(user: currentUser, completion: {
            
            self.viewWillAppear(true)
            
            self.showLoadingView()
            self.view.isUserInteractionEnabled = false
            self.available = false
            self.navigationController?.tabBarController?.view.isUserInteractionEnabled = false
            FirebaseUtils.saveLanguageCodesLocally(language: StringUtils.getLanguageShortNameLowerCase(languageName: SelectLangaugeViewController.selectedLanaguage), completion: {
                success in
                FirebaseUtils.downLoadAudio(language: StringUtils.getTalkNowLanguageName(language: SelectLangaugeViewController.selectedLanaguage), completion: {
                    success in
                    
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.tabBarController?.view.isUserInteractionEnabled = true
                    self.hideLoadingView()
                    self.viewWillAppear(true)
                })
            })
        })
        
    }
    
   


    func unlockAll(){

        purchaseView.removeFromSuperview()

        self.view.isUserInteractionEnabled = false
        self.navigationController?.tabBarController?.view.isUserInteractionEnabled = false
        self.showLoadingView()
        SwiftyStoreKit.purchaseProduct("xyz.learningonline.languag.all_languages", completion: { result in
            NSLog("\(result)")

            self.view.isUserInteractionEnabled = true
            self.navigationController?.tabBarController?.view.isUserInteractionEnabled = true

            self.hideLoadingView()
            switch result {
            case .success(_):
                let languageModel = UserLanguageModel()
                languageModel.language_free = false
                languageModel.language_name = Languages.LANGUAGE_ALL
                //currentUser.user_languageto
                languageModel.language_shortname = StringUtils.getLanguageShortNameLowerCase(languageName: Languages.LANGUAGE_ALL)
                languageModel.language_loaded = true
                languageModel.language_migratedlanguage = false
                languageModel.language_storename = "Apple Store"
                languageModel.language_uploaded = false
                languageModel.language_valid = false
                languageModel.language_purchasetime = getGlobalTime()
                FMDBManagerSetData.insertUserLanguage(languageModel)
                let userPurchase = UserPurchase()
                userPurchase.purchase_amount = "$4.99"
                userPurchase.purchase_time = languageModel.language_purchasetime
                userPurchase.purchase_valid = false
                FMDBManagerSetData.insertUserPurchase(userPurchase)
                FirebaseUtils.addLanguage(userid: currentUser.user_uid, languageObject: GetDataFromFMDBManager.getPendingUserLanguageFromLocal(language: Languages.LANGUAGE_ALL)!, completion: {
                    success in
                    if success{
                        FMDBManagerSetData.setUserLanguageUplaoded(language: Languages.LANGUAGE_ALL)
                    }
                    
                })
                return self.downLoadLanguage()
            case .error(_):
                return self.showToastWithDuration(string: "Invalid request", duration: 3.0)
            }

        })
    }

    func unlockLanguage(){
        
        purchaseView.removeFromSuperview()
        self.view.isUserInteractionEnabled = false
        self.navigationController?.tabBarController?.view.isUserInteractionEnabled = false

        showLoadingView()
        SwiftyStoreKit.purchaseProduct("xyz.learningonline.languag.abbruzzese", completion: { result in

            NSLog("\(result)")

            self.view.isUserInteractionEnabled = true
            self.navigationController?.tabBarController?.view.isUserInteractionEnabled = true


            self.hideLoadingView()
            switch result {
            case .success(_):
                let languageModel = UserLanguageModel()
                languageModel.language_free = false
                languageModel.language_name = SelectLangaugeViewController.selectedLanaguage
                //currentUser.user_languageto
                languageModel.language_shortname = StringUtils.getLanguageShortNameLowerCase(languageName: SelectLangaugeViewController.selectedLanaguage)
                languageModel.language_loaded = true
                languageModel.language_migratedlanguage = false
                languageModel.language_storename = "Apple Store"
                languageModel.language_uploaded = false
                languageModel.language_valid = false
                languageModel.language_purchasetime = getGlobalTime()
                FMDBManagerSetData.insertUserLanguage(languageModel)
                
                let userPurchase = UserPurchase()
                userPurchase.purchase_amount = "$0.99"
                userPurchase.purchase_time = languageModel.language_purchasetime
                userPurchase.purchase_valid = false
                
                FMDBManagerSetData.insertUserPurchase(userPurchase)
                FirebaseUtils.addLanguage(userid: currentUser.user_uid, languageObject: GetDataFromFMDBManager.getPendingUserLanguageFromLocal(language: SelectLangaugeViewController.selectedLanaguage)!, completion: {
                    success in
                    if success{
                        FMDBManagerSetData.setUserLanguageUplaoded(language: SelectLangaugeViewController.selectedLanaguage)
                    }
                    
                })
                return self.downLoadLanguage()
            case .error(_):
                return self.showToastWithDuration(string: "Invalid request", duration: 3.0)
            }
            
        })
        
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        searchVC.controllerType = "Search"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

    
}
