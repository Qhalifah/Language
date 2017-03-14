//
//  StartContent1ViewController.swift
//  design
//
//  Created by Big Shark on 01/03/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class StartContent1ViewController: BaseViewController , UITableViewDelegate{

    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var sizeChangableView: UIView!
    @IBOutlet weak var productNameView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDetailView: UIView!
    
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pageControl1: UIPageControl!
    @IBOutlet weak var backColorView: UIView!
    
    @IBOutlet weak var imvInfo: UIImageView!
    //headline items
    
    @IBOutlet weak var individualView: UIView!
    
    @IBOutlet weak var individualButton: UIButton!
    @IBOutlet weak var tagPlus1: UIButton!
    @IBOutlet weak var tagMinus1: UIButton!
    
    @IBOutlet weak var tagCount1: UILabel!
    @IBOutlet weak var tagSymbol1: UILabel!
    
    @IBOutlet weak var massView: UIView!
    
    @IBOutlet weak var massButton: UIButton!
    @IBOutlet weak var tagPlus2: UIButton!
    
    @IBOutlet weak var plusLabel1: UILabel!
    @IBOutlet weak var minusLabel1: UILabel!
    @IBOutlet weak var tagMinus2: UIButton!
    
    @IBOutlet weak var tagCount2: UILabel!
    @IBOutlet weak var tagSymbol2: UILabel!
    @IBOutlet weak var minusLabel2: UILabel!
    @IBOutlet weak var plusLabel2: UILabel!
    
    @IBOutlet weak var bottomImage: UIImageView!
    //select user items
    
    @IBOutlet weak var viewMe: UIView!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var meImage: UIImageView!
    @IBOutlet weak var viewGroup: UIView!
    @IBOutlet weak var buttonMe: UIButton!
    
    
    @IBOutlet weak var optionView1: UIView!
    @IBOutlet weak var optionView2: UIView!
    
    @IBOutlet weak var stageScrollView: UIScrollView!
    
    
    var currentStage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productNameView.isHidden = true
       
        optionButtonTapped(individualButton)
        
        imvInfo.setImageWith(color: UIColor.white)
       
        selectUser(buttonMe)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        setCurStage(false, tag: 301)
        setCurStage(true, tag: 311)
        setCurStage(false, tag: 321)
        currentStage = 301
        
        initView()
        
        stageButtonTapped(self.view.viewWithTag(311) as! UIButton)
        
    }
    
    
    func initView(){
        var scrollView = self.view.viewWithTag(1) as! UIScrollView
        scrollView.contentOffset = CGPoint.zero
        scrollViewDidScroll(scrollView)
         scrollView = self.view.viewWithTag(3) as! UIScrollView
         scrollView.contentOffset = CGPoint.zero
         scrollViewDidScroll(scrollView)
        scrollView = self.view.viewWithTag(2) as! UIScrollView
        scrollView.contentOffset = CGPoint.zero
        scrollViewDidScroll(scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stageButtonTapped(self.view.viewWithTag(311) as! UIButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1
        {
            let slideDistance = scrollView.contentOffset.y
            NSLog("\(slideDistance)")
            
            let limitdistance : CGFloat = 450
            if slideDistance <= limitdistance
            {
                if slideDistance > limitdistance - 64 {
                    
                    //productImageView.isHidden = true
                    if slideDistance > limitdistance - 32{
                        titleTopConstraint.constant = slideDistance - limitdistance
                        titleView.backgroundColor = backColorView.backgroundColor
                    }
                    else{
                        titleView.backgroundColor = UIColor.clear
                        titleTopConstraint.constant = -32
                    }
                    
                    productImageView.alpha = 0
                    productDetailView.alpha = 0
                    
                }
                    
                else if slideDistance > limitdistance - 160
                {
                    productNameView.isHidden = false
                    productDetailView.alpha = 1 - (slideDistance - limitdistance + 160) / 100
                    productImageView.alpha = 1 - (slideDistance - limitdistance + 160) / 100
                
                    
                }
                else{
                    
                    //productDetailView.isHidden = false
                    productNameView.isHidden = true
                    //productImageView.isHidden = false
                    titleView.backgroundColor = UIColor.clear
                    productImageView.alpha = 1
                    productDetailView.alpha = 1
                    
                }
                
                scrollViewTopConstraint.constant = slideDistance
            }
            else{
                //titleTopConstraint.constant = 64
                titleTopConstraint.constant = slideDistance - limitdistance
                titleView.backgroundColor = backColorView.backgroundColor
                productImageView.alpha = 0
                productDetailView.alpha = 0
            }
        }
        else if scrollView.tag == 2{
            NSLog("scroll ===== \(scrollView.contentOffset.x)")
            if scrollView.contentOffset.x > screenSize.width * 0.5{
                pageControl1.currentPage = 1
                
            }
            else{
                pageControl1.currentPage = 0
            }
            
            if scrollView.contentOffset.x < screenSize.width{
                optionView1.frame.origin.x = scrollView.contentOffset.x
                optionView1.alpha = 1 - scrollView.contentOffset.x / screenSize.width
            }
            else{
                
            }
            
        }
        else if scrollView.tag == 3 {
            if scrollView.contentOffset.x == 0{
                setCurStage(false, tag : currentStage)
                setCurStage(true, tag :301)
                currentStage = 301
                
            }
            else if scrollView.contentOffset.x == screenSize.width{
                
                setCurStage(false, tag : currentStage)
                setCurStage(true, tag :311)
                currentStage = 311
                
            }
            else if scrollView.contentOffset.x == screenSize.width * 2{
                
                setCurStage(false, tag : currentStage)
                setCurStage(true, tag :321)
                currentStage = 321
            }
            
        }
        
    }
    
    @IBAction func tagButtonTapped(_ sender: UIButton) {
        if sender.tag == 101 {
            let value = Int(tagCount1.text!)
            tagCount1.text = "\(value! + 1)"
            tagMinus1.isUserInteractionEnabled = true
        }
        else if sender.tag == 102{
            let value = Int(tagCount1.text!)
            if value! <= 1 {
                sender.isUserInteractionEnabled = false
                
            }
            
            
            tagCount1.text = "\(value! - 1)"
        }
        if sender.tag == 111 {
            let value = Int(tagCount2.text!)
            tagCount2.text = "\(value! + 1)"
            tagMinus2.isUserInteractionEnabled = true
        }
        else if sender.tag == 112{
            let value = Int(tagCount2.text!)
            if value! <= 1 {
                sender.isUserInteractionEnabled = false
                
            }
            
            
            tagCount2.text = "\(value! - 1)"
        }
    }
    
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        /**/
        if sender.tag == 105{
            
            individualView.backgroundColor = UIColor.lightGray
            tagPlus1.isHidden = false
            tagMinus1.isHidden = false
            individualButton.backgroundColor = UIColor.white
            individualButton.layer.borderColor = UIColor(colorLiteralRed: 0.4, green: 0.4, blue: 0.4, alpha: 0.4).cgColor
            individualButton.layer.borderWidth = 9
            minusLabel1.isHidden = false
            plusLabel1.isHidden = false
            
            
            massView.backgroundColor = UIColor.darkGray
            
            massButton.layer.borderWidth = 3
            massButton.layer.borderColor = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            massButton.backgroundColor = UIColor.clear
            minusLabel2.isHidden = true
            plusLabel2.isHidden = true
            tagPlus2.isHidden = true
            tagMinus2.isHidden = true
        }
        else if sender.tag == 115 {
            massView.backgroundColor = UIColor.lightGray
            tagPlus2.isHidden = false
            tagMinus2.isHidden = false
            massButton.backgroundColor = UIColor.white
            massButton.layer.borderColor = UIColor(colorLiteralRed: 0.4, green: 0.4, blue: 0.4, alpha: 0.4).cgColor
            massButton.layer.borderWidth = 9
            minusLabel2.isHidden = false
            plusLabel2.isHidden = false
            
            
            individualView.backgroundColor = UIColor.darkGray
            
            individualButton.layer.borderWidth = 3
            individualButton.layer.borderColor = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            individualButton.backgroundColor = UIColor.clear
            minusLabel1.isHidden = true
            plusLabel1.isHidden = true
            tagPlus1.isHidden = true
            tagMinus1.isHidden = true
        }
    }
    
    @IBAction func selectUser(_ sender: UIButton) {
        if sender.tag == 200{
            viewMe.backgroundColor = UIColor.lightGray
            meImage.setImageWith(color: UIColor.white)
            
            viewGroup.backgroundColor = UIColor.darkGray
            groupImage.setImageWith(color: UIColor.lightGray)
        }
        else if sender.tag == 210{
            
            viewMe.backgroundColor = UIColor.darkGray
            meImage.setImageWith(color: UIColor.lightGray)
            
            viewGroup.backgroundColor = UIColor.lightGray
            groupImage.setImageWith(color: UIColor.white)
        }
    }
    
    @IBAction func stageButtonTapped(_ sender: UIButton) {
        if sender.tag == 301 {
            stageScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width:  screenSize.width, height: 400), animated: true)
        }
        else if sender.tag == 311{
            stageScrollView.scrollRectToVisible(CGRect(x: screenSize.width , y: 0, width:  screenSize.width, height: 400), animated: true)
            
        }
        else if sender.tag == 321{
            stageScrollView.scrollRectToVisible(CGRect(x: screenSize.width * 2, y: 0, width:  screenSize.width, height: 400), animated: true)
        }
        setCurStage(false, tag: currentStage)
        setCurStage(true, tag: sender.tag)
        currentStage = sender.tag
    }
    
    func setCurStage(_ status : Bool, tag: Int){
        
        let selectedTintColor = UIColor.white
        let selectedBackgroundColor = UIColor.lightGray
        let unselectedBackgroundColor = UIColor.darkGray
        let unselectedTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.37)
        
        if status {
            for labelTag in tag + 1 ... tag + 3{
                (self.view.viewWithTag(labelTag) as! UILabel).textColor = selectedTintColor
            }
            for imageTag in tag + 4 ... tag + 6{
                guard let imageView = self.view.viewWithTag(imageTag) else {
                    break
                }
                (imageView as! UIImageView).setImageWith(color: selectedTintColor)
                
            }
            self.view.viewWithTag(tag - 1)?.backgroundColor = selectedBackgroundColor
            
        }
        else{
            for labelTag in tag + 1 ... tag + 3{
                (self.view.viewWithTag(labelTag) as! UILabel).textColor = unselectedTintColor
            }
            for imageTag in tag + 4 ... tag + 6{
                guard let imageView = self.view.viewWithTag(imageTag) else {
                    break
                }
                (imageView as! UIImageView).setImageWith(color: unselectedTintColor)
                
            }
            self.view.viewWithTag(tag - 1)?.backgroundColor = unselectedBackgroundColor
        }
        
        bottomImage.setImageWith(color : (self.view.viewWithTag(310)?.backgroundColor)!)
    
    }
    
    


}


