//
//  MoreViewController.swift
//  Langu.au
//
//  Created by Huijing on 09/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import SDWebImage

class MoreViewController: BaseViewController {

    @IBOutlet weak var tblMoreItems: UITableView!
    @IBOutlet weak var imvProfleImage: UIImageView!
    @IBOutlet weak var txtDisplayName: UITextField!
    @IBOutlet weak var lblLearningLanguage: UILabel!

    var profileImage : UIImage!
    var picker = UIImagePickerController()

    var fromImagePicker = false

    var available = false

    var selectedItem = 0


    var purchaseView: UIView!

    var moreItems = ["Edit Profile", "View Purchases" , "Interface Language: ", "Learning Language: ", "Storage Manager", "Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblLearningLanguage.text = currentUser.user_languageto
        if  (!fromImagePicker){
            moreItems = ["Edit Profile", "View Purchases" , "Interface Language: ", "Learning Language: ", "Storage Manager", "Log Out"]
            tblMoreItems.reloadData()
            txtDisplayName.isEnabled = false
            imvProfleImage.isUserInteractionEnabled = false
            txtDisplayName.text = currentUser.user_displayname
            imvProfleImage.setImageWith(storageRefString: currentUser.user_photourl, placeholderImage: UIImage(named: "icon_profileplaceholder")!)
        }
        else{
            fromImagePicker = false
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getItemString(_ index : Int) -> String{
        var result = moreItems[index]
        if result == "Interface Language: " {
            result = result + currentUser.user_languagefrom
        }
        else if result == "Learning Language: " {
            result = result + currentUser.user_languageto
        }
        return result
    }

    func itemTapped(_ indexText: String){
        switch indexText {
        case "Edit Profile":
            editProfile()
            break
        case "View Purchases":
            gotoViewPurchasesPage()
            break
        case "Interface Language: " + currentUser.user_languagefrom:
            languageItemSelected()
            break
        case "Learning Language: " + currentUser.user_languageto:
            languageItemSelected()
            break
        case "Storage Manager":
            gotoStorageFilesPage()
            break
        case "Log Out":
            UserAuthUtils.removeUserInfo()
            fmdbManager.deleteUserData()
            let startNav = self.storyboard?.instantiateViewController(withIdentifier: "StartNav") as! UINavigationController
            var controllers = startNav.viewControllers
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            controllers = [loginVC]
            startNav.viewControllers = controllers
            self.present(startNav, animated: true, completion: nil)
            break
        case "Save Profile":
            saveProfile()
            break
        default:
            break
        }
    }

    func editProfile(){

        moreItems[0] = "Save Profile"
        imvProfleImage.isUserInteractionEnabled = true
        txtDisplayName.isEnabled = true
        tblMoreItems.reloadData()

    }

    func saveProfile(){
        //self.showLoadingView()
        currentUser.user_displayname = txtDisplayName.text!
        userDefault.set(txtDisplayName.text, forKey: Constants.KEY_USER_DISPLAYNAME)
        showLoadingView()
        FirebaseUtils.uploadProfilePictureAndUpdate(userid: currentUser.user_uid, image: profileImage, completion: {
            success in
            self.hideLoadingView()
            self.moreItems[0] = "Edit Profile"
            self.tblMoreItems.reloadData()

            if self.profileImage == nil{
                UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                    
                })
            }
            else{
                self.profileImage = nil
                currentUser.user_photourl = FirebaseUtils.FIREBASE_STORAGE_BASE_URL + "/" + FirebaseUtils.getUserProfilePicturesStorageRootReference(userid: currentUser.user_uid).child("profile_\(currentUser.user_uid).jpg").fullPath
                UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                    
                })
            }

        })

        imvProfleImage.isUserInteractionEnabled = false
        txtDisplayName.isEnabled = false
    }
    //selectImageSource()

    @IBAction func selectProfileImage(_ sender: Any) {
        selectImageSource()
    }


    func gotoStorageFilesPage()
    {
        let storageVC = storyboard?.instantiateViewController(withIdentifier: "StorageManagerViewController")
        storageVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(storageVC!, animated: true)
    }

    func languageItemSelected(){
        
        available = true

        let selectLangVC = storyboard?.instantiateViewController(withIdentifier: "SelectLangaugeViewController")
        self.view.addSubview((selectLangVC?.view)!)
        self.addChildViewController(selectLangVC!)
    }
    
    func gotoViewPurchasesPage(){
        let purchaseVC = storyboard?.instantiateViewController(withIdentifier: "PurchaseViewController")
        purchaseVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(purchaseVC!, animated: true)
    }


    //Mark - In app purchase


    override func changeLanguage() {

        if available{
            if (available){
                if fmdbManager.isDataExists(language: SelectLangaugeViewController.selectedLanaguage){
                    
                    if selectedItem == 2{
                        currentUser.user_languagefrom = SelectLangaugeViewController.selectedLanaguage
                    }
                    else if selectedItem == 3{
                        currentUser.user_languageto = SelectLangaugeViewController.selectedLanaguage
                    }
                    
                    available = false
                    UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                        self.viewWillAppear(true)
                    })

                }
                else{
                    downLoadLanguage()
                }
                
                
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

        if selectedItem == 2{
            currentUser.user_languagefrom = SelectLangaugeViewController.selectedLanaguage
        }
        else if selectedItem == 3{
            currentUser.user_languageto = SelectLangaugeViewController.selectedLanaguage
        }

        available = false
        showLoadingView()
        UpdateContents.updateFirebaseUser(user: currentUser, completion: {
            
            self.viewWillAppear(true)            
            
            self.view.isUserInteractionEnabled = false
            self.navigationController?.tabBarController?.view.isUserInteractionEnabled = false
            FirebaseUtils.saveLanguageCodesLocally(language: StringUtils.getLanguageShortNameLowerCase(languageName: SelectLangaugeViewController.selectedLanaguage), completion: {
                success in
                if self.selectedItem == 3{
                    FirebaseUtils.downLoadAudio(language: StringUtils.getTalkNowLanguageName(language: SelectLangaugeViewController.selectedLanaguage), completion: {
                        success in
                        
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.tabBarController?.view.isUserInteractionEnabled = true
                        self.hideLoadingView()
                        self.viewWillAppear(true)
                    })
                }
                else{
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.tabBarController?.view.isUserInteractionEnabled = true
                    self.hideLoadingView()
                    self.viewWillAppear(true)
                }
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


extension MoreViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell") as! MoreTableViewCell
        cell.lblItemText.text = getItemString(index)
        return cell

    }


    //Mark - tableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        itemTapped(getItemString(indexPath.row))
    }

}

extension MoreViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {



    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        profileImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imvProfleImage.image = profileImage
        removeImageCache(forKey: currentUser.user_photourl)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelgeate
    // open gallery
    func openGallery() {

        picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        fromImagePicker = true
    }

    // open camera
    func openCamera() {

        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {

            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
            fromImagePicker = true
        }
    }

    func selectImageSource()
    {

        self.view.endEditing(true)

        let alertController = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        let selectGalleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { action in
            self.openGallery()

        })
        let selectCameraAction = UIAlertAction(title: "Camera",				 style: .default, handler: { action in

            self.openCamera()

        })
        let selectCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        })
        alertController.addAction(selectGalleryAction)
        alertController.addAction(selectCameraAction)
        alertController.addAction(selectCancel)
        
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
}

