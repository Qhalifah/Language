//
//  ProductsViewController.swift
//  design
//
//  Created by Big Shark on 28/02/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class ProductsViewController: BaseViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var selectedCellTag = 0
    
    var cellSize = CGSize(width: 150, height : 198)
    
    var products : [ProductModel] = []
    
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    var categoryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        ///****** Test data ******///
        
        
        products = TestData.getProducts(1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedCellTag = 0
        productsCollectionView.reloadData()
        productsCollectionView.contentOffset = CGPoint(x: 0, y: 0)
        categoryLabel.text = categoryName
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view.frame.size.width = UIScreen.main.bounds.size.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func longTapped(_ sender: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began{
            let touchPoint =  longPressGestureRecognizer.location(in: self.view)
            let offSet = productsCollectionView.contentOffset.x
        
            let indexPath = productsCollectionView.indexPathForItem(at: CGPoint(x: offSet + touchPoint.x, y: touchPoint.y))
            
            selectedCellTag = getTag((indexPath?.row)!)
            let product = products[(indexPath?.row)!]
            let selectedView = productsCollectionView.cellForItem(at: indexPath!) as! ProductItemCollectionViewCell
            selectedView.contentViewBottomConstraint.constant = 5
            selectedView.contentViewLeftConstraint.constant = 5
            selectedView.contentViewTopConstraint.constant = 5
            selectedView.contentViewRightConstraint.constant = 5
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProductItemSelected"), object: product.getProductObject())
            NSLog("index path ==== \(indexPath?.row)")
        }
        else{
            
        }
        /*let selectedView = sender.view?.superview?.superview  as! ProductItemCollectionViewCell
        selectedCellTag = selectedView.tag
        let product = products[(selectedCellTag - 10) / 10]
        selectedView.contentViewBottomConstraint.constant = 5
        selectedView.contentViewLeftConstraint.constant = 5
        selectedView.contentViewTopConstraint.constant = 5
        selectedView.contentViewRightConstraint.constant = 5*/
        
        //productsCollectionView.reloadData()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProductItemSelected"), object: product.getProductObject())
    }
    
    @IBAction func productCellTapped(_ sender: UITapGestureRecognizer) {
        //(self.parent?.parent?.parent?.parent as! HomeSlideMenuViewController).carbonTabSwipeNavigation.setCurrentTabIndex(1, withAnimation: true)
    }
    
    
}

extension ProductsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemCollectionViewCell", for: indexPath) as! ProductItemCollectionViewCell
        let index = indexPath.row
        let product = products[index]
        cell.priceLabel.text = product.price
        cell.productImageView.image = UIImage(named: product.imageString)
        cell.titleLabel.text = product.title
        cell.tag = getTag(index)
        if cell.tag == selectedCellTag{
            cell.contentViewRightConstraint.constant = 8
            cell.contentViewLeftConstraint.constant = 8
            cell.contentViewTopConstraint.constant = 8
            cell.contentViewBottomConstraint.constant = 8
        }
        else{
            cell.contentViewRightConstraint.constant = 0
            cell.contentViewLeftConstraint.constant = 0
            cell.contentViewTopConstraint.constant = 0
            cell.contentViewBottomConstraint.constant = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (self.parent?.parent?.parent?.parent as! HomeSlideMenuViewController).carbonTabSwipeNavigation.setCurrentTabIndex(1, withAnimation: true)
        
    }
    
    func getTag(_ index: Int) -> Int{
        return index * 10 + 10
    }
}
