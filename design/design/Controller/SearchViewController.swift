//
//  SearchViewController.swift
//  design
//
//  Created by Big Shark on 02/03/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var products : [ProductModel] = TestData.getFutureItems(3)
    var posts = TestData.getRecentPost()
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    var cellSize = CGSize(width: 150, height : 198)
    
    @IBOutlet weak var searchBarLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchMainView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.lightGray
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
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //searchBarTextDidEndEditing(searchBar)
        searchBar.text = ""
        self.view.endEditing(true)
    }
    @IBAction func ScrollViewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension SearchViewController: UISearchBarDelegate{
   // func search
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""
        {
            searchBarLeadingConstraint.constant = 0
            searchMainView.isHidden = false
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarLeadingConstraint.constant = 36
        searchMainView.isHidden = true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""
        {
            searchBarLeadingConstraint.constant = 0
            searchMainView.isHidden = false
        }
        else{
            searchBarLeadingConstraint.constant = 36
            searchMainView.isHidden = true
        }
    }
    
    
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productsCollectionView{
            return products.count
        }
        else
        {
            return posts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemCollectionViewCell", for: indexPath) as! ProductItemCollectionViewCell
            let index = indexPath.row
            let product = products[index]
            cell.priceLabel.text = product.price
            cell.productImageView.image = UIImage(named: product.imageString)
            cell.titleLabel.text = product.title
            cell.tag = getTag(index)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
            let index = indexPath.row
            let post = posts[index]
            cell.postTypeLabel.text = post.post_type
            cell.postTitleLabel.text = post.post_title
            cell.postImageView.image = UIImage(named: post.post_image)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == productsCollectionView{
            return cellSize
        }
        else{
            return CGSize(width: 300, height: 180)
        }
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
