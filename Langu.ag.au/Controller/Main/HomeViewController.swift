//
//  HomeViewController.swift
//  Langu.au
//
//  Created by Huijing on 09/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var tblTaskList: UITableView!
    @IBOutlet weak var lblLearningLanguage: UILabel!
    var categories : [CategoryModel] = []
    
    var purchaseView: UIView!
    
    var available = false

    static var categoryArray : [CategoryModel] = []
    var collectionViewCellSize : CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        tblTaskList.estimatedRowHeight = 200

        // Do any additional setup after loading the view.
        let screenSize: CGRect = UIScreen.main.bounds
        collectionViewCellSize = CGSize(width: screenSize.width - 48, height: (screenSize.width - 48) / 374 * 159)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    
    }

    func reloadData()
    {
        lblLearningLanguage.text = currentUser.user_languageto
        GetDataFromFMDBManager.getCategoryDataFromLocal()
        categories = shared_categories
        if !fmdbManager.isDataExists(language: currentUser.user_languageto)
        {
            downLoadLanguage()
        }
        tblTaskList.reloadData()
    }
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        searchVC.controllerType = "Search"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func unlockButtonTapped(_ sender: UIButton){
        SelectLangaugeViewController.selectedLanaguage = currentUser.user_languageto
        let notificationCenter = NotificationCenter.default
        available = true
        notificationCenter.post(name: NSNotification.Name(rawValue: "LanguageSelected"), object: nil)
        
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
        UpdateContents.updateFirebaseUser(user: currentUser, completion: {
            SelectLangaugeViewController.selectedLanaguage = currentUser.user_languageto
            self.showLoadingView()
            self.view.isUserInteractionEnabled = false
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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    //Mark - UITableViveDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 0
        if categoryBeginnerCount > 0{
            sectionCount += 1
        }
        if categoryIntermidietCount > 0{
            sectionCount += 1
        }
        if categoryExpertCount > 0{
            sectionCount += 1
        }
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return categoryBeginnerCount
        }
        else if section == 1{
            return categoryIntermidietCount
        }
        else{
            return categoryExpertCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        var index = indexPath.row
        if indexPath.section == 1{
            index += categoryBeginnerCount
            
        }
        else if indexPath.section == 2{
            index += categoryExpertCount + categoryBeginnerCount
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let category = categories[index]
        
        
        
        let lessonVC = storyboard?.instantiateViewController(withIdentifier: "LessonContentViewController") as! LessonContentViewController
        lessonVC.view.frame.size = cell.scrollContentView.frame.size
        lessonVC.collectionViewSize = collectionViewCellSize
        lessonVC.orderValue = indexPath.row
        lessonVC.categoryId = category.category_id
        lessonVC.lessons = category.category_lessons
        
        lessonVC.categoryImageName = "category-words-" + category.category_name.lowercased().replacingOccurrences(of: " & ", with: "-").replacingOccurrences(of: "’", with: "-").replacingOccurrences(of: " ", with: "-")
        //NSLog("\(lessonVC.categoryImageName)")
        cell.scrollContentView.addSubview(lessonVC.view)
        categories[index].category_loaded_on_cell = true
        cell.scrollContentView.addSubview(lessonVC.view)
        lessonVC.lessonsCollectionView.reloadData()
        if indexPath.section > 0{
            if(GetDataFromFMDBManager.getLanguagePurchased(language: currentUser.user_languageto))
            {
                lessonVC.locked = false
                cell.unlockView.isHidden = true
            }
            else{
                lessonVC.locked = true
                cell.unlockView.isHidden = false
            }
            
        }
        else{
            lessonVC.locked = false
            cell.unlockView.isHidden = true
        }
        self.addChildViewController(lessonVC)

        
        cell.lblCategoryName.text = category.category_name
        cell.totalLessonCount.text = "\(category.category_lessons.count)"
        cell.completedLessonCount.text = "\(category.category_completedlessoncount)"

        
        if category.category_lessons.count > 0{
            cell.completionRateView.value = CGFloat(category.category_completedlessoncount) / CGFloat(category.category_lessons.count) * 100
        }
        else{
            cell.completionRateView.value = 0
        }
        //cell.completionRageView.value =
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return collectionViewCellSize.height + 73
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
  
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor(colorLiteralRed: 3.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 20, y: 15, width: 200, height: 20))
        label.textColor = UIColor.white
        if section == 0{
            label.text = "Beginner"
        }
        else if section == 1{
            label.text = "Intermidiate"
        }
        else{
            label.text = "Advanced"
        }
        label.font = UIFont(name: "Comfortaa-Regular", size: 20)
        sectionView.addSubview(label)
        return sectionView
    }
    
    
}
