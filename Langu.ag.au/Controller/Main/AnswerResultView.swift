//
//  AnswerResultView.swift
//  Langu.ag
//
//  Created by Huijing on 13/01/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import UIKit

class AnswerResultView: UIView {

    var screenSize = CGSize()
    var riseTimer = Timer()
    var showTimer = Timer()

    var growingStatus = true

    var threshold : CGFloat = 0
    var shouldDragX = true
    var currentMinX : CGFloat = 1

    func setAnswerView(answerType: Int, answerResult: Bool)
    {

        setupPanGustures()


        screenSize = UIScreen.main.bounds.size

        frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)

        let label = UILabel()
        let image = UIImageView()
        let button = UIButton()

        label.frame = CGRect(x:0 , y:10, width: screenSize.width, height: 20)
        label.textAlignment = .center
        label.textColor = .white

        image.frame = CGRect(x: screenSize.width / 2 - 90, y: 35, width: 180, height: 180)
        image.contentMode = .scaleAspectFit

        button.frame = CGRect(x: screenSize.width - 55 , y: 5, width: 40, height: 40)
        button.setImage(UIImage(named: "icon_close"), for: .normal)


        addSubview(label)
        addSubview(image)
        addSubview(button)
        button.addTarget(self, action: #selector(hideView), for: .touchUpInside)


        if answerResult {
            label.text = "Correct Answer!"
            
            self.backgroundColor = UIColor(colorLiteralRed: 140.0 / 255.0, green: 208.0 / 255.0, blue: 53.0 / 255.0, alpha: 1)
            if answerType == Constants.VALUE_LANGUITEM_JUMBLE
            {
                image.image = UIImage(named: "happy_1")
            }
            else{
                image.image = UIImage(named: "happy_2")
            }
        }
        else
        {
            label.text = "Wrong Answer!"
            self.backgroundColor = UIColor(colorLiteralRed: 243.0 / 255.0, green: 92.0 / 255.0, blue: 72.0 / 255.0, alpha: 1)
            if answerType == Constants.VALUE_LANGUITEM_JUMBLE
            {
                image.image = UIImage(named: "sad_1")
            }
            else{
                image.image = UIImage(named: "sad_2")
            }
        }


        for childview in (superview?.subviews)!{
            if childview.isKind(of: UICollectionView.self){
                childview.isUserInteractionEnabled = false
            }
        }
        isUserInteractionEnabled = false
        riseTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(growAnswerView), userInfo: nil, repeats: true)

        showTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hideView), userInfo: nil, repeats: false)

    }


    func setupPanGustures(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
    }


    func growAnswerView()
    {
        if (growingStatus)
        {
            if self.frame.minY > screenSize.height - 250 {
                self.frame.origin.y -= 2
                self.layoutIfNeeded()
            }
            else{
                riseTimer.invalidate()
                growingStatus = false
                isUserInteractionEnabled = true

            }
        }
        else{
            if self.frame.minX < screenSize.width{
                self.frame.origin.x += 2
            }
            else{
                hideView()
                riseTimer.invalidate()

            }
        }
    }

    func hideView()
    {
        if showTimer.isValid{
            showTimer.invalidate()
        }
        for childview in (superview?.subviews)!{
            if childview.isKind(of: UICollectionView.self){
                childview.isUserInteractionEnabled = true
            }
        }
        self.removeFromSuperview()
    }


    func pan(_ rec: UIPanGestureRecognizer){

        let p:CGPoint = rec.location(in: self)

        switch rec.state {
        case .began:
            print("began")
            showTimer.invalidate()
            currentMinX = frame.minX
            threshold = p.x
        case .changed:
            NSLog("\(threshold) == \(p.x)")
            let delta = threshold - p.x
            frame.origin.x = currentMinX - delta

            if frame.origin.x < 0{
                frame.origin.x = 0
            }
            alpha = (screenSize.width - frame.origin.x) / screenSize.width
        case .ended:
            print("ended")
            threshold = 0
            if (screenSize.width - frame.origin.x) / screenSize.width < 0.7{
                hideView()
            }
            else {
                frame.origin.x = 0
                alpha = 1
                showTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hideView), userInfo: nil, repeats: false)
            }

        case .possible:
            print("possible")
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        }
    }
    

}
