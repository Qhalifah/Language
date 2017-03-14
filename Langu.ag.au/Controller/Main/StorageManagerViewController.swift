//
//  StorageManagerViewController.swift
//  Langu.ag
//
//  Created by Huijing on 22/01/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import UIKit

class StorageManagerViewController: BaseViewController {

    var directories : [[String: String]] = []
    var currentIndex = 0

    @IBOutlet weak var tblStorageList: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        directories = CommonUtils.getLocalDirectories()
        tblStorageList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func backButtonTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated : true)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        searchVC.controllerType = "Search"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func DeleteButtonTapped(_ sender: UIButton) {
        
        let alertController = storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController//AlertViewController
        currentIndex = (sender.tag - 10) / 10
        let object = directories[currentIndex]
        alertController.fileURL = object[Constants.KEY_DIRECTROY_NAME]!
        
        self.view.addSubview(alertController.view)
        self.addChildViewController(alertController)
    }
}

extension StorageManagerViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorageItemTableViewCell") as! StorageItemTableViewCell

        let object = directories[index]
        cell.lblDirectoryName.text = CommonUtils.getFilenameFrom(object[Constants.KEY_DIRECTROY_NAME]!)
        if cell.lblDirectoryName.text == "Images"{
            cell.btnDelete.isHidden = true
            cell.imvDeleteImage.setImageWith(color: UIColor.lightGray)
        }
        cell.lblDirectorySize.text = object[Constants.KEY_DIRECTORY_SIZE]
        cell.btnDelete.tag = index * 10 + 10
        return cell
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }


}
