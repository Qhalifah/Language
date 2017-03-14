//
//  StartHeaderAnimationView.swift
//  design
//
//  Created by Big Shark on 25/02/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import Foundation
import UIKit

class StartHeaderAnimationView: UIView {
    
    var contentView : UIView!
    
    var origin : CGPoint!
    
    var screenSize = CGSize()
    
    var ratioWithWD : CGFloat = 2/3
    
    var timer : Timer!
    var topItems : [ProductModel] = []          //This is an array of product models
    var currentItem: Int = 0                    //This is a current Item index
    //var currentItems: [UIView] = []             //This is a current adapted views
    
    let prevAdapterCount : Int = 2              //adapter count for prev views
    let nextAdapterCount : Int = 2              //adapter count for next views
    
    static var currentShowingItem = 0
    
    //rule for indexing ---- tag = index * 10 + 10
    
    //Acceleration setting variables
    var threshold:CGFloat = 0.0
    var currentDirection : Bool!
    
    let accelerationValue: CGFloat = 3
    
    func initWithItems(_ topItems: [ProductModel])
    {
        frame.size = self.screenSize
        initView()
        //self.backgroundColor = UIColor.white
        //if contentView == nil
            contentView = UIView()
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.backgroundColor = UIColor.black
            addSubview(contentView)
        //}
        
        let leftContraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let topContraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightContraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomContraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.addConstraints([leftContraint, topContraint,rightContraint, bottomContraint])
        self.topItems = topItems
        //currentItem = StartHeaderAnimationView.currentShowingItem
        let productView = TopProductItem()
        productView.setView(topItems[currentItem])
        productView.frame = frame
        contentView.addSubview(productView)
        
        productView.tag = getTag(currentItem)
        for item in 0 ..< topItems.count{
            addItem(item)
        }
        setupGustures()
    }
    
    func initView(){
        let subViews = subviews
        
        if subviews.count > 0
        {
            for subView in subViews{
                subView.removeFromSuperview()
            }
            //NSLog("count = \(subViews.count)")
        }
    }
    
    //Mark setup gestures
    
    //Mark - Add Pan Gesture Recognizer
    
    func setupGustures(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(StartHeaderAnimationView.pan(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1

        self.addGestureRecognizer(pan)
    }
    
    func pan(_ rec: UIPanGestureRecognizer){
        let p:CGPoint = rec.location(in: self)
        //let changedValue: CGPoint = rec.translation(in: contentView)

        switch rec.state {
        case .began:
            print("began")
            
        case .changed:
            
            if threshold == 0
            {
                threshold = p.x
            }
            
            //NSLog("\(threshold) == \(p.x)")
            if (p.x < threshold){
                if currentDirection == nil{
                    currentDirection = true
                }
                else{
                    if currentDirection! {
                        let nextItem = currentItem + 1
                        if nextItem < topItems.count{
                            let ratio = (threshold - p.x) / frame.size.width
                            appearsWithRatio(ratio, index: nextItem, direction: currentDirection)
                            disAppearWithRatio(ratio, index: currentItem, direction: currentDirection)
                            //NSLog("current item ==== \(currentItem)")
                        }
                        else{
                            currentDirection = nil
                        }
                    }
                }
                
            }
            else if (p.x > threshold){
                if currentDirection == nil{
                    currentDirection = false
                }
                else{
                    if !currentDirection!{
                        let prevItem = currentItem - 1
                        if prevItem >= 0{
                            let ratio = (p.x - threshold) / frame.size.width
                            appearsWithRatio(ratio, index: prevItem, direction: currentDirection)
                            disAppearWithRatio(ratio, index: currentItem, direction: currentDirection)
                        }
                        else{
                            currentDirection = nil
                        }
                    }
                }
                
            }
            
        case .ended:
            print("ended")
            
            let ratio = fabs(p.x - threshold) / frame.size.width
            NSLog("ratio === \(ratio)")
            if ratio < 0.15{
                gotoOriginalPosition()
            }
            else if ratio * accelerationValue >= 1{
                if p.x < threshold{
                    let nextItem = currentItem + 1
                    if nextItem < topItems.count{
                        currentItem = nextItem
                    }
                }
                else{
                    let prevItem = currentItem - 1
                    if prevItem >= 0{
                        currentItem = prevItem
                    }
                }
                currentDirection = nil
            }
            else{
                gotoTargetPosition()
            }
            threshold = 0
        //self.isUserInteractionEnabled = true
        case .possible:
            print("possible")
        case .cancelled:
            print("cancelled")
            let ratio = fabs(p.x - threshold) / frame.size.width
            if ratio < 0.1{
                gotoOriginalPosition()
            }
            else if ratio * accelerationValue >= 1{
                if p.x < threshold{
                    let nextItem = currentItem + 1
                    if nextItem < topItems.count{
                        currentItem = nextItem
                    }
                }
                else{
                    let prevItem = currentItem - 1
                    if prevItem >= 0{
                        currentItem = prevItem
                    }
                }
                currentDirection = nil
            }
            else{
                gotoTargetPosition()
            }
            threshold = 0
            //self.isUserInteractionEnabled = true
            rec.isEnabled = true
        case .failed:
            print("failed")
        }
    }
    
    //appears with swipe
    func appearsWithRatio(_ ratioValue: CGFloat, index: Int, direction: Bool)
    {
        if direction{
            let xValue = frame.size.width - ratioValue * accelerationValue * frame.size.width
            let movingView = contentView.viewWithTag(getTag(index))
            if xValue <= 0{
                movingView?.frame.origin.x = 0
                //self.isUserInteractionEnabled = false
            }
            else{
                movingView?.frame.origin.x = xValue
            }
        }
        else{
            let movingView = contentView.viewWithTag(getTag(index))
            let multiplier : CGFloat = 1.2
            if ratioValue * accelerationValue < 1{
                movingView?.frame.size.width = frame.size.width * (0.6 + ratioValue * multiplier)
                movingView?.frame.size.height = frame.size.width * (0.6 + ratioValue * multiplier) * ratioWithWD
                movingView?.frame.origin.x = (frame.size.width - (movingView?.frame.size.width)!) / 2
                movingView?.frame.origin.y = (frame.size.width * ratioWithWD - (movingView?.frame.size.height)!) / 2
                movingView?.alpha = ratioValue * accelerationValue
                contentView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: Float(ratioValue * accelerationValue))
            }
            else{
                movingView?.frame.size.width = frame.size.width
                movingView?.frame.size.height = frame.size.width * ratioWithWD
                movingView?.frame.origin.x = 0
                movingView?.frame.origin.y = 0
                movingView?.alpha = 1
            }
        }
    }
    
    
    func disAppearWithRatio(_ ratioValue: CGFloat, index: Int, direction: Bool){
        if direction{
            let movingView = contentView.viewWithTag(getTag(index))
            let multiplier : CGFloat = 1.2
            movingView?.frame.size.width = frame.size.width * (1 - ratioValue * multiplier)
            movingView?.frame.size.height = frame.size.width * (1 - ratioValue * multiplier) * ratioWithWD
            movingView?.frame.origin.x = (frame.size.width - (movingView?.frame.size.width)!) / 2
            movingView?.frame.origin.y = (frame.size.width * ratioWithWD - (movingView?.frame.size.height)!) / 2
            movingView?.alpha = 1 - ratioValue * accelerationValue
            contentView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: Float(1 - ratioValue * 2))
        }
        else{
            let xValue = frame.size.width - (1 - ratioValue * accelerationValue) * frame.size.width
            let movingView = contentView.viewWithTag(getTag(index))
            if xValue >= frame.size.width{
                movingView?.frame.origin.x = frame.size.width
                //self.isUserInteractionEnabled = false
            }
            else{
                movingView?.frame.origin.x = xValue
            }
        }
    }
    
    
    //timer 
    
    func gotoOriginalPosition(){
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(gotoOriginalPositionWithTimer), userInfo: nil, repeats: true)
    }
    
    func gotoOriginalPositionWithTimer()
    {
        if currentDirection == nil{
            timer.invalidate()
        }
        else if (currentDirection!){
            if currentItem + 1 < topItems.count{
                let movingView = contentView.viewWithTag(getTag(currentItem + 1))
                var ratio = (self.screenSize.width - (movingView?.frame.origin.x)!) / self.screenSize.width / accelerationValue
                if ratio <= 0{
                    timer.invalidate()
                    currentDirection = nil
                }
                else{
                    ratio -= 0.005
                    appearsWithRatio(ratio, index: currentItem + 1, direction: true)
                    disAppearWithRatio(ratio, index: currentItem, direction: true)
                }
            }
            else{
                timer.invalidate()
                currentDirection = nil
            }
        }
        else{
            if currentItem - 1 >= 0{
                let movingView = contentView.viewWithTag(getTag(currentItem))
                var ratio = (movingView?.frame.origin.x)! / self.screenSize.width / accelerationValue
                if ratio <= 0{
                    timer.invalidate()
                    currentDirection = nil
                    //NSLog("current item finished====\(currentItem)")
                    
                }
                else{
                    ratio -= 0.005
                    appearsWithRatio(ratio, index: currentItem - 1, direction: false)
                    disAppearWithRatio(ratio, index: currentItem, direction: false)
                    //NSLog("current item ====\(currentItem)")
                    //NSLog("current RAtio ==== \(ratio)")
                }
            }
            else{
                timer.invalidate()
                currentDirection = nil
            }
        }
        
    }
    
    func gotoTargetPosition(){
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(gotoTargetPositionWithTimer), userInfo: nil, repeats: true)
    }
    
    func gotoTargetPositionWithTimer(){
        if currentDirection == nil{
            timer.invalidate()
            
        }
        else if (currentDirection!){
            if currentItem + 1 < topItems.count{
                let movingView = contentView.viewWithTag(getTag(currentItem + 1))
                var ratio = (self.screenSize.width - (movingView?.frame.origin.x)!) / self.screenSize.width / accelerationValue
                if ratio * accelerationValue >= 1{
                    timer.invalidate()
                    currentDirection = nil
                    //NSLog("current item finished====\(currentItem)")
                    currentItem += 1
                    
                }
                else{
                    ratio += 0.005
                    appearsWithRatio(ratio, index: currentItem + 1, direction: true)
                    disAppearWithRatio(ratio, index: currentItem, direction: true)
                    //NSLog("current item ====\(currentItem)")
                    //NSLog("current RAtio ==== \(ratio)")
                }
            }
            else{
                timer.invalidate()
                currentDirection = nil
            }
        }
        else{
            if currentItem - 1 >= 0{
                let movingView = contentView.viewWithTag(getTag(currentItem))
                var ratio = (movingView?.frame.origin.x)! / self.screenSize.width / accelerationValue
                if ratio * accelerationValue >= 1{
                    timer.invalidate()
                    currentDirection = nil
                    //NSLog("current item finished====\(currentItem)")
                    currentItem -= 1
                    
                }
                else{
                    ratio += 0.005
                    appearsWithRatio(ratio, index: currentItem - 1, direction: false)
                    disAppearWithRatio(ratio, index: currentItem, direction: false)
                    //NSLog("current item ====\(currentItem)")
                    //NSLog("current RAtio ==== \(ratio)")
                }
            }
            else{
                timer.invalidate()
                currentDirection = nil
            }
        }
    }
    
    func cellForItemAt(_ index: Int){
        
    }
    
    func addItem(_ index: Int)
    {
        let productView = TopProductItem()
        productView.setView(topItems[index])
        productView.frame = getFrame(index)
        productView.tag = getTag(index)
        contentView.addSubview(productView)
    }
    
    func getFrame(_ index: Int) -> CGRect{
        if index > currentItem{
            return getNextItemFrame()
        }
        else{
            return getPrevItemFrame()
        }
    }
    
    func getNextItemFrame() -> CGRect{
        return CGRect(x: frame.size.width, y: 0 , width : frame.size.width, height: frame.size.height)
    }
    
    func getPrevItemFrame() -> CGRect{
        return CGRect(x: frame.size.width, y: 0 , width : frame.size.width, height: frame.size.height)
    }
    

    
    func getTag(_ index: Int) -> Int
    {
        return index * 10 + 10
    }

    
}

