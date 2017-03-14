//
//  ProductActionViewController.swift
//  design
//
//  Created by Big Shark on 01/03/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class ProductActionViewController: UIViewController {

    var product = ProductModel()
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productImageView.image = UIImage(named : product.imageString)
        productNameLabel.text = product.title
        priceLabel.text = product.price
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
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        self.view.isHidden = true
        parentViewRefresh()
    }

    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        self.view.isHidden = true
        parentViewRefresh()
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        self.view.isHidden = true
        parentViewRefresh()
    }
    
    @IBAction func productDetailButtonTapped(_ sender: UIButton){
        self.view.isHidden = true
        (self.parent?.parent?.parent?.parent as! HomeSlideMenuViewController).carbonTabSwipeNavigation.setCurrentTabIndex(1, withAnimation: true)
        parentViewRefresh()
        
    }
    
    func parentViewRefresh(){
        (self.parent as! StartViewController).mainContentView.alpha = 1
        self.parent?.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.isHidden = true
        parentViewRefresh()
    }
    
    
}
