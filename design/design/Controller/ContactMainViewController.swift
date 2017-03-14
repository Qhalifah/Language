//
//  ContactMainViewController.swift
//  design
//
//  Created by Big Shark on 01/03/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class ContactMainViewController: BaseViewController {

    var statusArray = ["AKTUAELL","ZUKÜNFTIG","ABGELAUFEN"]
    
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var contactTableView: UITableView!
    
    var currentItemsArray : [ProductModel] = []
    var futureItemsArray : [ProductModel] = []
    var expiredItemsArray : [ProductModel] = []
    
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var moreItemsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentItemsArray = TestData.getCurrentItems(1)
        futureItemsArray = TestData.getFutureItems(2)
        expiredItemsArray = TestData.getExpiredItems(3)
        contactTableView.delegate = self
        contactTableView.dataSource = self
        menuBackgroundView.isHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contactTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        menuBackgroundView.isHidden = true
        self.mainContentView.isUserInteractionEnabled = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let buttonCenter = sender.convert(sender.frame.origin, to: self.view)
        moreItemsView.frame.origin.x = sender.frame.origin.x - 140
        moreItemsView.frame.origin.y = buttonCenter.y - 140
        self.mainContentView.isUserInteractionEnabled = false
        
        menuBackgroundView.isHidden = false
    }
    
    @IBAction func menuItemTapped(_ sender: UIButton) {
        menuBackgroundView.isHidden = true
        self.mainContentView.isUserInteractionEnabled = true
    }

}


extension ContactMainViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return statusArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentItemsArray.count
        case 1:
            return futureItemsArray.count
        default:
            return expiredItemsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactMainTableViewCell") as! ContactMainTableViewCell
        switch indexPath.section {
        case 0:
            cell.product = currentItemsArray[indexPath.row]
            break
        case 1:
            cell.product = futureItemsArray[indexPath.row]
            break
        default:
            cell.product = expiredItemsArray[indexPath.row]
            break
        }
        cell.setCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        menuBackgroundView.isHidden = true
        self.mainContentView.isUserInteractionEnabled = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statusArray[section]
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor.black
        let label = UILabel(frame: CGRect(x: 20, y: 17, width: 200, height: 20))
        label.textColor = UIColor.white
        label.text = statusArray[section]
        sectionView.addSubview(label)
        return sectionView
    }
    

}
