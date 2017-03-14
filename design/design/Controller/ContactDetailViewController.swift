//
//  ContactDetailViewController.swift
//  design
//
//  Created by Big Shark on 01/03/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class ContactDetailViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonsTopConstraint: NSLayoutConstraint!
    var cellSize = CGSize(width: 150, height : 198)
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var products : [ProductModel] = TestData.getFutureItems(1)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonsTopConstraint.constant = UIScreen.main.bounds.size.width + 80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initView()
    }
    
    func initView(){
        var scrollView = self.view.viewWithTag(1) as! UIScrollView
        scrollView.contentOffset = CGPoint.zero
        scrollViewDidScroll(scrollView)/*
        scrollView = self.view.viewWithTag(3) as! UIScrollView
        scrollView.contentOffset = CGPoint.zero
        scrollViewDidScroll(scrollView)*/
        scrollView = self.view.viewWithTag(2) as! UIScrollView
        scrollView.contentOffset = CGPoint.zero
        scrollViewDidScroll(scrollView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView.tag == 1
        {
            let slideDistance = scrollView.contentOffset.y
            if slideDistance <= screenSize.width + 120{
                if slideDistance > screenSize.width + 60 {
                    //headerView.alpha = 1 - (slideDistance - (screenSize.width + 80)) / 60
                    backgroundImageView.alpha = 1 - (slideDistance - (screenSize.width + 60)) / 60
                    
                }
                else{
                    headerView.alpha = 1
                    backgroundImageView.alpha = 1
                }
                buttonsTopConstraint.constant = screenSize.width + 60 - slideDistance
            }
            else{
                buttonsTopConstraint.constant = -60
                backgroundImageView.alpha = 0
                //headerView.alpha = 0
            }
        }
    }

}

extension ContactDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource{
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
        /*if cell.tag == selectedCellTag{
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
        }*/
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedCellTag = getTag(indexPath.row)
        collectionView.reloadData()
        
        /*NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProductItemSelected"), object: products[indexPath.row].getProductObject())*/
        
    }
    
    func getTag(_ index: Int) -> Int{
        return index * 10 + 10
    }
}
