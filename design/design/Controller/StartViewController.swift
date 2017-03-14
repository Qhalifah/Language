//
//  StartViewController.swift
//  design
//
//  Created by Big Shark on 25/02/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit
import CarbonKit

class StartViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainContentView: UIView!
    
    var topProductItems : [ProductModel] = []
    var categoryCount = 0
    
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    
    var actionViewController :  ProductActionViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(productItemSelected(_:)), name: NSNotification.Name(rawValue: "ProductItemSelected"), object: nil)
        getTopViewItems()
        categoryCount = 6
        tableView.reloadData()
        (self.parent?.parent as! CarbonTabSwipeNavigation).pagesScrollView?.isScrollEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    func getTopViewItems(){
        topProductItems = TestData.getTopItems()
    }
    
    func productItemSelected(_ notification: Notification){

        self.mainContentView.alpha = 0.5
        let object = notification.object
        if object != nil
        {
            let product = ProductModel.parseProduct(object as AnyObject)
            if actionViewController == nil
            {
                let productActionVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductActionViewController") as!ProductActionViewController
                self.view.addSubview(productActionVC.view)
                self.addChildViewController(productActionVC)
                actionViewController = productActionVC
            }
            actionViewController.product = product
            actionViewController.viewDidLoad()
            actionViewController.view.isHidden = false
            (self.parent?.parent as! CarbonTabSwipeNavigation).pagesScrollView?.isScrollEnabled = false
        }
        
    }

    @IBAction func longTapped(_ sender: Any) {
        
    }
}

extension StartViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        var cell = UITableViewCell()
        
        if index == 0 && topProductItems.count > 0{
            let topCell = tableView.dequeueReusableCell(withIdentifier: "TopItemTableViewCell") as! TopItemTableViewCell
            let productsView = topCell.productsView
            productsView?.screenSize = CGSize(width : screenSize.width, height : screenSize.width * 2 / 3)
            //if productsView?.subviews.count == 0{
                productsView?.initWithItems(topProductItems)
            //}
            cell = topCell
        }
        else{
            let productCell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
            let subviews = productCell.contentView.subviews
            if subviews.count == 0{
                let productsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
                //productsVC.cellSize = CGSize(width : screenSize.width, height: 200)
                //productsVC.view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 270)
                productsVC.categoryName = "Test Category - \(index)"
                productsVC.products = TestData.getProducts(index)
                
                productCell.contentView.addSubview(productsVC.view)
                //productsVC.view.frame.size.width = UIScreen.main.bounds.size.width
                self.addChildViewController(productsVC)
                
                let leftContraint = NSLayoutConstraint(item: productsVC.view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: productCell.contentView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
                let topContraint = NSLayoutConstraint(item: productsVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: productCell.contentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
                let rightContraint = NSLayoutConstraint(item: productsVC.view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: productCell.contentView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
                let bottomContraint = NSLayoutConstraint(item: productsVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: productCell.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
                
                productCell.contentView.addConstraints([leftContraint, topContraint,rightContraint, bottomContraint])
                productsVC.viewWillAppear(false)
            }
            else{
                let productView = subviews[0]
                let productsVC = productView.parentViewController as! ProductsViewController
                productsVC.categoryName = "Test Category - \(index)"
                productsVC.products = TestData.getProducts(index)
                
                /*let leftContraint = NSLayoutConstraint(item: productsVC.view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: productCell.contentView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
                let topContraint = NSLayoutConstraint(item: productsVC.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: productCell.contentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
                let rightContraint = NSLayoutConstraint(item: productsVC.view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: productCell.contentView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
                let bottomContraint = NSLayoutConstraint(item: productsVC.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: productCell.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)*/
                
                //productCell.contentView.addConstraints([leftContraint, topContraint,rightContraint, bottomContraint])
                productsVC.viewWillAppear(false)

            }
            
            
            cell = productCell
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return screenSize.width * 2 / 3
        }
        else{
            return 240
        }
    }
}
