//
//  SelectMyLangViewController.swift
//  Langu.ag
//
//  Created by Huijing on 23/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit

class SelectMyLangViewController: BaseViewController {

    @IBOutlet weak var sliderViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imvKindOfLang: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnStatusImage: UIImageView!
    @IBOutlet weak var lblLanguage: UILabel!

    @IBOutlet weak var tbnBack: UIButton!
    @IBOutlet weak var languageViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var viewLanguageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewLanguageToTitle: UIView!
    @IBOutlet weak var languageToTitleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageFromTitleWidthConstraint: NSLayoutConstraint!

    var allLoaded = 0

    @IBOutlet weak var sliderView: UIView!
    var timer : Timer!

    let STATUS_LANGUAGEFROM = 0
    let STATUS_LANGUAGETO = 1
    var status = 0

    var viewWidth : CGFloat = 0
    var viewHeight : CGFloat = 0
    var user = UserModel()

    let maxInterval = 20

    var langViewFrameOrigin: CGPoint!

    var interval = 0

    var loadingFinished = 0
    let fullLoaded = 3

    override func viewDidLoad() {
        super.viewDidLoad()


        tbnBack.isHidden = true
        // Do any additional setup after loading the view.

        let screenSize: CGRect = UIScreen.main.bounds

        viewWidth = screenSize.width
        viewHeight = screenSize.height
        //viewLanguageToTitle.isHidden = true
        languageFromTitleWidthConstraint.constant = viewWidth - 20
        languageToTitleWidthConstraint.constant = 0

        user.user_languagefrom = "English"


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    override func viewWillAppear(_ animated: Bool) {

    }*/


    override func viewDidAppear(_ animated: Bool) {
        langViewFrameOrigin = viewLanguage.frame.origin
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func selectLanguageButtonTapped(_ sender: UIButton) {
        let selectLanguageVC = storyboard?.instantiateViewController(withIdentifier: "SelectLangaugeViewController") as! SelectLangaugeViewController
        selectLanguageVC.view.frame.size = viewLanguage.frame.size
        viewLanguage.addSubview(selectLanguageVC.view)
        self.addChildViewController(selectLanguageVC)
        self.view.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(showSelectLanguageView), userInfo: nil, repeats: true)

    }

    func showSelectLanguageView(){

        interval += 1
        if(interval >= maxInterval){
            timer.invalidate()
            interval = 0
            self.view.isUserInteractionEnabled = true
        }


        languageViewLeftConstraint.constant -= 2
        languageViewTopConstraint.constant -= langViewFrameOrigin.y / 20
        viewLanguageHeightConstraint.constant += (viewHeight - 50)/20

    }

    func hideSelectLanguageView(){


        interval += 1
        if(interval >= maxInterval){
            timer.invalidate()
            interval = 0
            self.view.isUserInteractionEnabled = true

        }

        languageViewLeftConstraint.constant += 2
        languageViewTopConstraint.constant += langViewFrameOrigin.y / 20
        viewLanguageHeightConstraint.constant -= (viewHeight - 50)/20
    }

    func changeStatus(currentStatus: Int){
        if(currentStatus == STATUS_LANGUAGEFROM){
            tbnBack.isHidden = true
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(changeLanguageTo), userInfo: nil, repeats: true)
            status = STATUS_LANGUAGETO
        }
        else{

            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(changeLanguageFrom), userInfo: nil, repeats: true)
            status = STATUS_LANGUAGEFROM
        }


    }

    func changeLanguageTo(){
        interval += 1
        if(interval < 11)
        {
            imvKindOfLang.alpha -= 1/10
            languageFromTitleWidthConstraint.constant -= (viewWidth - 20)/10
        }
        else{
            imvKindOfLang.alpha += 1/10
            languageToTitleWidthConstraint.constant += (viewWidth - 20)/10
        }


        sliderViewLeadingConstraint.constant += sliderView.frame.size.width/20
        if(imvKindOfLang.alpha <= 0){
            imvKindOfLang.image = UIImage(named: "icon_languageto")
            btnStatusImage.image = UIImage(named: "complete_icon")
            btnStatusImage.setImageWith(color: UIColor.white)

            btnDone.setTitle("Done", for: .normal)
            lblLanguage.text = "Select Language"
        }
        else if(imvKindOfLang.alpha == 1){

            timer.invalidate()
            interval = 0

            tbnBack.isHidden = false
        }


    }

    func changeLanguageFrom(){

        interval += 1
        if(interval < 11)
        {
            imvKindOfLang.alpha -= 1/10
            languageToTitleWidthConstraint.constant -= (viewWidth - 20)/10
        }
        else{
            imvKindOfLang.alpha += 1/10
            languageFromTitleWidthConstraint.constant += (viewWidth - 20)/10
        }


        sliderViewLeadingConstraint.constant -= sliderView.frame.size.width/20
        if(imvKindOfLang.alpha <= 0){
            imvKindOfLang.image = UIImage(named: "icon_mylanguage")
            btnStatusImage.image = UIImage(named: "next_icon")
            btnDone.setTitle("Next", for: .normal)

            lblLanguage.text = user.user_languagefrom
        }
        else if(imvKindOfLang.alpha == 1){

            timer.invalidate()
            interval = 0
            tbnBack.isHidden = true
        }


    }


    @IBAction func btnNextTapped(_ sender: Any) {

        if(interval == 0 && status == STATUS_LANGUAGEFROM){
            changeStatus(currentStatus: status)
        }
        else{
            if(user.user_languageto == "")
            {
                showToastWithDuration(string: "Please select language", duration: 3.0)
            }
            else{
                getDataFromFirebase(user: user)
            }
        }
    }



    @IBAction func backButtonTapped(_ sender: Any) {
        if(interval == 0 ){
            changeStatus(currentStatus: status)
        }
    }

    func getDataFromFirebase(user: UserModel){

        //set current user language properties

        currentUser.user_languagefrom = user.user_languagefrom
        currentUser.user_languageto = user.user_languageto

        userDefault.set(currentUser.user_languagefrom, forKey: Constants.USER_LANGUAGEFROM)
        userDefault.set(currentUser.user_languageto, forKey: Constants.USER_LANGUAGETO)

        let existsMyLanguage = fmdbManager.isDataExists(language: currentUser.user_languagefrom)
        var existsLearningLanguage = fmdbManager.isDataExists(language: currentUser.user_languageto)

       if existsMyLanguage && existsLearningLanguage{
            currentUser.user_loaded = true
            UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                self.gotoMainScene()
            })
        
        }
        else{
            self.allLoaded = 0
            //loading data from server
            showLoadingView()
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
            }


            if currentUser.user_languagefrom == currentUser.user_languageto{
                existsLearningLanguage = true
            }

            if !existsMyLanguage{
                //get language codes
                FirebaseUtils.saveLanguageCodesLocally(language: StringUtils.getLanguageShortNameLowerCase(languageName: user.user_languagefrom), completion: {
                    success in
                    
                    self.allLoaded += 1
                    self.completedDownloading()
                    /*
                    FirebaseUtils.downLoadAudio(language: StringUtils.getTalkNowLanguageName(language: user.user_languagefrom), completion: {
                        success in
                        self.allLoaded += 1
                        self.completedDownloading()
                    })*/

                })
            }
            else {
                self.allLoaded += 1
            }
            if !existsLearningLanguage{

                FirebaseUtils.saveLanguageCodesLocally(language: StringUtils.getLanguageShortNameLowerCase(languageName: user.user_languageto), completion: {
                    success in
                    FirebaseUtils.downLoadAudio(language: StringUtils.getTalkNowLanguageName(language: user.user_languageto), completion: {
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

    override func languageSelected(_ notification: Notification) {
        if(status == STATUS_LANGUAGEFROM){
            user.user_languagefrom = SelectLangaugeViewController.selectedLanaguage
        }
        else if(status == STATUS_LANGUAGETO){
            user.user_languageto = SelectLangaugeViewController.selectedLanaguage
        }
        self.view.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(hideSelectLanguageView), userInfo: nil, repeats: true)
        lblLanguage.text = SelectLangaugeViewController.selectedLanaguage

    }

    func gotoMainScene()
    {
        
        let languageFromModel = UserLanguageModel()
        languageFromModel.language_free = true
        languageFromModel.language_name = currentUser.user_languagefrom
        languageFromModel.language_shortname = StringUtils.getLanguageShortNameLowerCase(languageName: currentUser.user_languagefrom)
        languageFromModel.language_loaded = true
        languageFromModel.language_migratedlanguage = false
        languageFromModel.language_storename = "Apple Store"
        languageFromModel.language_uploaded = false
        languageFromModel.language_valid = false
        languageFromModel.language_purchasetime = getGlobalTime()
        
        FMDBManagerSetData.insertUserLanguage(languageFromModel)
        var languageObject = GetDataFromFMDBManager.getPendingUserLanguageFromLocal(language: languageFromModel.language_name)
        FirebaseUtils.addLanguage(userid: currentUser.user_uid, languageObject: languageObject!, completion: {
            success in
            if success{
                FMDBManagerSetData.setUserLanguageUplaoded(language: languageFromModel.language_name)
            }
        })
        
        let languageToModel = UserLanguageModel()
        languageToModel.language_free = true
        languageToModel.language_name = currentUser.user_languageto
        languageToModel.language_shortname = StringUtils.getLanguageShortNameLowerCase(languageName: currentUser.user_languageto)
        languageToModel.language_loaded = true
        languageToModel.language_migratedlanguage = false
        languageToModel.language_storename = "Apple Store"
        languageToModel.language_uploaded = false
        languageToModel.language_valid = false
        languageToModel.language_purchasetime = getGlobalTime()
        
        FMDBManagerSetData.insertUserLanguage(languageToModel)
        
        languageObject = GetDataFromFMDBManager.getPendingUserLanguageFromLocal(language: languageToModel.language_name)
        FirebaseUtils.addLanguage(userid: currentUser.user_uid, languageObject: languageObject!, completion: {
            success in
            if success{
                FMDBManagerSetData.setUserLanguageUplaoded(language: languageToModel.language_name)
            }
        })
        

        // [2] Create an instance of the storyboard's initial view controller.
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTab")
        // [3] Display the new view controller.
        present(controller!, animated: true, completion: nil)
    }

    func completedDownloading(){
        if allLoaded == 3 {
            self.hideLoadingView()
            currentUser.user_loaded = true
            UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                
                self.gotoMainScene()
            })
        }
    }



}
