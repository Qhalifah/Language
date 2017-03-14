//
//  PurchaseViewController.swift
//  Langu.ag
//
//  Created by Big Shark on 20/02/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import UIKit

class PurchaseViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate {

    var purchases:[[String: AnyObject]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        purchases = GetDataFromFMDBManager.getPurchases()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        searchVC.controllerType = "Search"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseTableViewCell") as! PurchaseTableViewCell
        let language = purchases[index][Constants.KEY_LANGUAGE_NAME] as! String
        var value = ""
        if "\(language)" == Languages.LANGUAGE_ALL{
            value = "$4.99"
        }
        else{
            value = "$0.99"
        }
        cell.purchaseLabel.text = "\(language) \(value)"
        
        return cell
        
    }
    
    
    //Mark - tableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
