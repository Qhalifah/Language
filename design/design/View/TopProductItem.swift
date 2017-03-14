//
//  TopProductItem.swift
//  design
//
//  Created by Big Shark on 28/02/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class TopProductItem: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var productImageView : UIImageView!
    var transparentImageView: UIImageView!
    var bottomView : UIView!
    var subTitleLabel: UILabel!
    var mainTitleLabel: UILabel!
    var topItem : ProductModel!
    
    func setView(_ item: ProductModel){
        
        topItem = item
        //add ProductImageView
        productImageView = UIImageView()
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.image = UIImage(named: topItem.imageString)
        addSubview(productImageView)
        
        var leftContraint = NSLayoutConstraint(item: productImageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let topContraint = NSLayoutConstraint(item: productImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        var rightContraint = NSLayoutConstraint(item: productImageView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        var bottomContraint = NSLayoutConstraint(item: productImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([leftContraint, topContraint,rightContraint, bottomContraint])
        
        
        //add bottom view
        bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomView)
        bottomView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.25)
        
        leftContraint = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        rightContraint = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        bottomContraint = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 0.3, constant: 0)
        
        self.addConstraints([leftContraint, rightContraint, bottomContraint, heightConstraint])
        
        //let heightConstraint = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 60)

        //NSLayoutConstraint.activate([heightConstraint])
        
        //add subtitle label in bottom view
        subTitleLabel = UILabel()               //define instance
        subTitleLabel.text = topItem.subTitle   //define text
        subTitleLabel.textColor = UIColor.white //define 
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        var labelWidth = subTitleLabel.getWidth()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(subTitleLabel)    //add subview to super view
        
        leftContraint = NSLayoutConstraint(item: subTitleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: bottomView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 20)       //define left constraint
        
        var centerConstraintY = NSLayoutConstraint(item: subTitleLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: bottomView, attribute: NSLayoutAttribute.centerY, multiplier: 0.5, constant: 0) //define centerY constraint
        //heightConstraint = NSLayoutConstraint(item: subTitleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: bottomView , attribute: NSLayoutAttribute.height, multiplier: 0.2, constant: 0)
        var widthConstraint = NSLayoutConstraint(item: subTitleLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: bottomView , attribute: NSLayoutAttribute.width, multiplier: labelWidth / UIScreen.main.bounds.size.width, constant: 0)
        
        subTitleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.lineBreakMode = .byClipping
        subTitleLabel.minimumScaleFactor = 0.5
        //subTitleLabel.font
        subTitleLabel.sizeToFit()
        
        bottomView.addConstraints([leftContraint, centerConstraintY, widthConstraint]) //add constraint
        
        
        //add main title label in bottom view
        
        

        mainTitleLabel = UILabel()
        mainTitleLabel.textColor = UIColor.white
        mainTitleLabel.text = topItem.title
        mainTitleLabel.font = UIFont.systemFont(ofSize: 18)
        labelWidth = mainTitleLabel.getWidth()
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(mainTitleLabel)
        
        leftContraint = NSLayoutConstraint(item: mainTitleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: bottomView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 20)
        
        centerConstraintY = NSLayoutConstraint(item: mainTitleLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: bottomView, attribute: NSLayoutAttribute.centerY, multiplier: 1.3, constant: 0)
        
        widthConstraint = NSLayoutConstraint(item: mainTitleLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: bottomView , attribute: NSLayoutAttribute.width, multiplier: labelWidth / UIScreen.main.bounds.size.width, constant: 0)
        //heightConstraint = NSLayoutConstraint(item: mainTitleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: bottomView , attribute: NSLayoutAttribute.height, multiplier: 0.3, constant: 0)
        mainTitleLabel.adjustsFontSizeToFitWidth = true
        mainTitleLabel.lineBreakMode = .byClipping
        mainTitleLabel.minimumScaleFactor = 0.5
        mainTitleLabel.sizeToFit()
        bottomView.addConstraints([leftContraint, centerConstraintY, widthConstraint])
        
        
    }
}

