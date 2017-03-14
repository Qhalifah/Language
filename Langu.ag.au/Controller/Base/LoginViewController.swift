//
//  LoginViewController.swift
//  Langu.au
//
//  Created by Huijing on 09/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var buttonsViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var confirmPasswordViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var confirmPasswordViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnStatus: UIButton!

    var status = true

    static let STATUS_LOGIN = true
    static let STATUS_SIGNUP = false

    var allLoaded = 0



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.navigationController?.isNavigationBarHidden = true
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func initView()
    {
        //set text field place hoder color and text
        txtEmail.attributedPlaceholder = NSAttributedString(string:"Email",                                                               attributes:[NSForegroundColorAttributeName: UIColor.white])
        txtEmail.tintColor = UIColor.white.withAlphaComponent(0.8)
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password",                                                               attributes:[NSForegroundColorAttributeName: UIColor.white])
        txtPassword.tintColor = UIColor.white.withAlphaComponent(0.8)
        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password",                                                               attributes:[NSForegroundColorAttributeName: UIColor.white])
        txtConfirmPassword.tintColor = UIColor.white.withAlphaComponent(0.8)

        //setButttonStatus(status)



    }

    func setButttonStatus(_ currentStatus: Bool)
    {
        if(!currentStatus){

            UIView.animate(withDuration: 0.2, animations: {
                self.confirmPasswordView.frame.origin.y += 15
                self.confirmPasswordView.frame.size.height += 45
                self.buttonsView.frame.origin.y += 10

                self.btnLogin.frame.origin.y += 60

            }, completion: {

                success in


                self.confirmPasswordViewHeightConstraint.constant = 45
                self.confirmPasswordViewTopConstraint.constant = 15

                self.buttonsViewTopConstraint.constant = 35

                self.btnLogin.setTitle("Sign Up", for: .normal)
                let mySelectedAttributedTitle = NSAttributedString(string: "Have an account? ",
                                                                   attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18.0), NSForegroundColorAttributeName: UIColor.white])
                let mySelectedAttributedTitle1 = NSAttributedString(string: "Login",
                                                                    attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName: UIColor.white])

                let buttonAttribuitedText = NSMutableAttributedString()
                buttonAttribuitedText.append(mySelectedAttributedTitle)
                buttonAttribuitedText.append(mySelectedAttributedTitle1)
                
                self.btnStatus.setAttributedTitle(buttonAttribuitedText, for: .normal)
                
                
            })

        }
        else
        {
            UIView.animate(withDuration: 0.2, animations: {
                self.confirmPasswordView.frame.origin.y -= 15
                self.confirmPasswordView.frame.size.height -= 45

                self.buttonsView.frame.origin.y -= 10
                self.btnLogin.frame.origin.y -= 60


            }, completion: {

                success in

                self.buttonsViewTopConstraint.constant = 35
                self.confirmPasswordViewHeightConstraint.constant = 0
                self.confirmPasswordViewTopConstraint.constant = 0

                self.btnLogin.setTitle("Login", for: .normal)
                let mySelectedAttributedTitle = NSAttributedString(string: "Don't have an account? ",
                                                                   attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18.0), NSForegroundColorAttributeName: UIColor.white])
                let mySelectedAttributedTitle1 = NSAttributedString(string: "Sign Up",
                                                                    attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName: UIColor.white])

                let buttonAttribuitedText = NSMutableAttributedString()
                buttonAttribuitedText.append(mySelectedAttributedTitle)
                buttonAttribuitedText.append(mySelectedAttributedTitle1)
                
                
                self.btnStatus.setAttributedTitle(buttonAttribuitedText, for: .normal)
                
            })
        }
    }


    func changeLoginStatus(){
        status = !status
        setButttonStatus(status)
    }

    @IBAction func changeStatusTapped(_ sender : UIButton){

        changeLoginStatus()
        
    }

    @IBAction func loginButtonTapped(_ sender : UIButton){

        //if()

        if(status == LoginViewController.STATUS_SIGNUP){

            showLoadingView()
            doSignUp()
        }
        else{
            doSignIn()
        }
    }

    func gotoSelectLanguagePage(){


        let selectLanguageVC = storyboard?.instantiateViewController(withIdentifier: "SelectMyLangViewController") as! SelectMyLangViewController

        self.navigationController?.pushViewController(selectLanguageVC, animated: true)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtConfirmPassword && status == LoginViewController.STATUS_SIGNUP){
            doSignUp()
        }
        if(textField == txtPassword && status == LoginViewController.STATUS_LOGIN){
            doSignIn()
        }
        return true
    }

    func doSignIn()
    {
        self.view.endEditing(true)
        showLoadingView()
        FirebaseUtils.signIn(email: txtEmail.text!, password: txtPassword.text!, completion: {uid,success in
            if (success){
                currentUser.user_uid = uid
                currentUser.user_email = self.txtEmail.text!
                currentUser.user_password = self.txtPassword.text!
                FirebaseUtils.saveUserPurchasedLanguagesLocally(userId: uid, completion: {
                    succcess in
                    if success {
                        
                    }
                })
                FirebaseUtils.getUserFromDatabase(userid: uid, completion: {
                    success, user in

                    if success{
                        
                        currentUser = user
                        if currentUser.user_languagefrom.characters.count > 0{

                            self.userDefault.set(currentUser.user_languagefrom, forKey: Constants.USER_LANGUAGEFROM)
                            self.userDefault.set(currentUser.user_languageto, forKey: Constants.USER_LANGUAGETO)
                            
                            let existsMyLanguage = fmdbManager.isDataExists(language: currentUser.user_languagefrom)
                            var existsLearningLanguage = fmdbManager.isDataExists(language: currentUser.user_languageto)

                            if existsMyLanguage && existsLearningLanguage{
                                currentUser.user_loaded = true
                                UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                                    
                                    self.hideLoadingView()
                                    self.gotoMainScene()
                                })

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
                            self.gotoSelectLanguagePage()
                        }
                        
                    }
                    else{
                        self.hideLoadingView()
                    }
                })
            }
            else{

                self.hideLoadingView()
            }
        })
    }

    func doSignUp(){
        self.view.endEditing(true)
        showLoadingView()
        FirebaseUtils.signUp(email: txtEmail.text!, password: txtPassword.text!, completion: {uid, success in
            self.hideLoadingView()
            if(success){
                currentUser.user_uid = uid
                currentUser.user_email = self.txtEmail.text!
                currentUser.user_password = self.txtPassword.text!
                UpdateContents.updateFirebaseUser(user: currentUser, completion: {
                    self.gotoSelectLanguagePage()
                })
                
            }
        })
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


    func gotoMainScene()
    {
        FMDBManagerSetData.uploadUserActivities(completion: {
            // [2] Create an instance of the storyboard's initial view controller.
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTab")
            // [3] Display the new view controller.
            self.present(controller!, animated: true, completion: nil)
        })
        
    }

    @IBAction func viewDidTapped(_ sender: Any) {
        self.view.endEditing(true)
    }

}






















