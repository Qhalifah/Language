//
//  AlertViewController.swift
//  Langu.ag
//
//  Created by Big Shark on 20/02/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    var fileURL = ""
    @IBOutlet weak var lblMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMessage.text = "Would you like to delete all data for \(CommonUtils.getFilenameFrom(fileURL))?"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender.tag == 1{
            
            let filename = CommonUtils.getFilenameFrom(fileURL)
            let language = StringUtils.getLanguageShortNameFrom(filename)
            FMDBManagerSetData.removeLangaugedata(language)
            _ = CommonUtils.removeFile(fileURL)
            let parentViewController = self.parent
            parentViewController?.viewDidLoad()
            
        }
        else{
            
        }
        removeView()
    }
    
    func removeView()
    {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

}
