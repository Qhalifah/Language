//
//  SelectLangaugeViewController.swift
//  Langu.ag
//
//  Created by Huijing on 23/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit

class SelectLangaugeViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var tblLanguageList: UITableView!
    @IBOutlet weak var txtSearchText: UITextField!
    @IBOutlet weak var imvSearch: UIImageView!

    var languages : [String] = []
    var isDrawnArray : [Bool] = []

    static var selectedLanaguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblLanguageList.separatorColor = .clear
        languages = Languages().language_names
        tblLanguageList.reloadData()



    }

    override func viewWillAppear(_ animated: Bool) {
        //imvSearch.image = imvSearch.image?.withRenderingMode(.alwaysTemplate)
        imvSearch.setImageWith(color: UIColor(colorLiteralRed: 230/255, green: 74/255, blue: 25/255, alpha: 1))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(f/Users/huijing/My Projects/Langu-ios/Langu.ag.au/Controller/Mainor segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //Mark table view Data source



    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageItemCell") as! LanguageItemCell

        let language = languages[index]
        cell.lblLanguName.text = language
        let image = UIImage(named: StringUtils.getLanguageImageName(languageName: language))

       
        if(image != nil)
        {
            cell.imvLanguImage.image = image
        }

        else{
            cell.imvLanguImage.image = UIImage(named: "language_placeholder")
        }

        cell.cellColorImageView.image = UIImage(named: "language_back_\(index % 6 + 1)")
        return cell

    }

    //Mark - tableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        SelectLangaugeViewController.selectedLanaguage = languages[indexPath.row]

        self.view.removeFromSuperview()

        self.removeFromParentViewController()
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue: "LanguageSelected"), object: nil)

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }



    @IBAction func backButtonTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func searchTextChanged(_ sender: UITextField) {
        languages = getStringArrayMatches(with: sender.text!, stringArray: Languages().language_names)
        tblLanguageList.reloadData()
    }


    func getStringArrayMatches(with: String, stringArray: [String]) -> [String]{

        if(with.characters.count == 0)
        {
            return stringArray
        }

        var result: [String] = []
        for string in stringArray{
            if(string.lowercased().contains(with.lowercased())){
                result.append(string)
            }
        }
        return result
    }


}
