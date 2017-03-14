//
//  ViewController.swift
//  Langu.au
//
//  Created by Huijing on 09/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {


    var userDefault = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(languageSelected(_:)), name: NSNotification.Name(rawValue: "LanguageSelected"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func showToastWithDuration(string: String!, duration: Double) {
        self.view.makeToast(string, duration: duration, position: .bottom)
    }

    func showLoadingView()
    {
        self.view.makeToastActivity(.center)
        self.view.isUserInteractionEnabled = false
    }

    func hideLoadingView()
    {
        self.view.hideToastActivity()
        self.view.isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func languageSelected(_ notification: Notification){

        if GetDataFromFMDBManager.getLanguagePurchased(language: SelectLangaugeViewController.selectedLanaguage){
            changeLanguage()
        }
        else
        {
            addInAppPurchaseView()
        }

    }



    func addInAppPurchaseView(){
        
    }

    func changeLanguage(){

    }
    


}

