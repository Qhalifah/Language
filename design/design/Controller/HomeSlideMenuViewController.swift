//
//  HomeSlideMenuViewController.swift
//  Design
//
//  Created by Huijing on 03/02/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import UIKit
import CarbonKit

class HomeSlideMenuViewController: UIViewController, CarbonTabSwipeNavigationDelegate, UIScrollViewDelegate{


    var items : Array<String> = []
    
    var curVC = 0

    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    var contentVCs : [UIViewController] = []

    //@IBOutlet weak var slideItemViewLeadingConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        screenSize = self.view.frame.size
        if contentVCs.count == 0{
            initView()
        }
    }



    func initView(){

        //Hide NavigationView
        self.navigationController?.isNavigationBarHidden = true

        //set bottom tab bar items
        UITabBar.appearance().backgroundColor = UIColor.white

        //set main image color

        //set header Array
        items.append("StartViewController")
        items.append("StartContent1ViewController")
        contentVCs.append((self.storyboard?.instantiateViewController(withIdentifier: "StartViewController"))!)
        contentVCs.append((self.storyboard?.instantiateViewController(withIdentifier: "StartContent1ViewController"))!)

        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items:items, delegate : self)
        carbonTabSwipeNavigation.pagesScrollView?.delegate = self
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        style()

    }

    func style(){

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        //navigationController?.navigationBar.barTintColor = MAIN_COLOR
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent

        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setTabBarHeight(0)

    }




    //Mark: - CarbonTabSwipeNavigation Delegate
    // required

    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController{
        
        switch index {
        case 0:
            
            return contentVCs[0]
        default:
            return contentVCs[1]
        /*default:
            return contentVCs[0]*/
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        curVC = Int(index)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        let ratio = contentOffset.x / screenSize.width
        NSLog("ratio ==== \(ratio)")
        if ratio > 1 && ratio <= 2{
            
            if curVC == 0{
                //set view controller offset of x axis
                (contentVCs[0] as! StartViewController).view.frame.origin.x = contentOffset.x - screenSize.width
                //
                (contentVCs[0] as! StartViewController).mainContentView.alpha = 2 - ratio
                
                (contentVCs[0] as! StartViewController).contentViewLeftConstraint.constant = screenSize.height * 0.15 * (ratio - 1)
                (contentVCs[0] as! StartViewController).contentViewTopConstraint.constant = screenSize.width * 0.15 * (ratio - 1)
                (contentVCs[0] as! StartViewController).contentViewRightConstraint.constant = screenSize.height * 0.15 * (ratio - 1)
                (contentVCs[0] as! StartViewController).contentViewBottomConstraint.constant = screenSize.width * 0.15 * (ratio - 1)
                (contentVCs[0] as! StartViewController).mainContentView.alpha = (2 - ratio)            
                (contentVCs[1] as! StartContent1ViewController).view.alpha = (ratio - 1) * 0.7 + 0.3
            }
        }
        else if (ratio >= 0 && ratio < 1)
        {
            if curVC == 1{
                (contentVCs[1] as! StartContent1ViewController).view.alpha = ratio * 0.7 + 0.3
                (contentVCs[0] as! StartViewController).mainContentView.alpha = (1 - ratio)
                
                (contentVCs[0] as! StartViewController).view.frame.origin.x = contentOffset.x
                //
                
                (contentVCs[0] as! StartViewController).contentViewLeftConstraint.constant = screenSize.height * 0.15 * ratio
                (contentVCs[0] as! StartViewController).contentViewTopConstraint.constant = screenSize.width * 0.15 * ratio
                (contentVCs[0] as! StartViewController).contentViewRightConstraint.constant = screenSize.height * 0.15 * ratio
                (contentVCs[0] as! StartViewController).contentViewBottomConstraint.constant = screenSize.width * 0.15 * ratio
            }
        }
        
    }
    
}
