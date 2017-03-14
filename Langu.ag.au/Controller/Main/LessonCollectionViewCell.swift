//
//  LessonCollectionViewCell.swift
//  Langu.ag
//
//  Created by Huijing on 23/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import Material

class LessonCollectionViewCell: CollectionViewCell {
    
    @IBOutlet weak var lessonStageLabel: UILabel!
    @IBOutlet weak var lessonTitleLabel: UILabel!

    @IBOutlet weak var imvProgress1: UIImageView!
    @IBOutlet weak var imvProgress2: UIImageView!
    @IBOutlet weak var imvProgress3: UIImageView!

    @IBOutlet weak var imvProgressCompleted1: UIImageView!
    @IBOutlet weak var imvProgressCompleted2: UIImageView!
    @IBOutlet weak var imvProgressCompleted3: UIImageView!

    @IBOutlet weak var process1CompletedWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var process2CompletedWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var process3CompletedWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var leftLineView: UIView!
    @IBOutlet weak var rightLineView: UIView!

    override func awakeFromNib() {
        imvProgress1.setImageWith(color: UIColor(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1))
        imvProgress2.setImageWith(color: UIColor(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1))
        imvProgress3.setImageWith(color: UIColor(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1))

        imvProgressCompleted1.setImageWith(color: UIColor(colorLiteralRed: 33/255, green: 155/255, blue: 243/255, alpha: 1))
        imvProgressCompleted2.setImageWith(color: UIColor(colorLiteralRed: 33/255, green: 155/255, blue: 243/255, alpha: 1))
        imvProgressCompleted3.setImageWith(color: UIColor(colorLiteralRed: 33/255, green: 155/255, blue: 243/255, alpha: 1))
    }

    func setRating(_ rating: CGFloat){
        if rating == 0
        {
            process1CompletedWidthConstraint.constant = 0
            process2CompletedWidthConstraint.constant = 0
            process3CompletedWidthConstraint.constant = 0
        }
        else if(rating < 33.33)
        {
            process1CompletedWidthConstraint.constant = rating * 0.45
            process2CompletedWidthConstraint.constant = 0
            process3CompletedWidthConstraint.constant = 0

        }
        else if (rating < 66.67)
        {
            process1CompletedWidthConstraint.constant = 15
            process2CompletedWidthConstraint.constant = rating * 0.45 - 15
            process3CompletedWidthConstraint.constant = 0
        }
        else{
            process1CompletedWidthConstraint.constant = 15
            process2CompletedWidthConstraint.constant = 15
            process3CompletedWidthConstraint.constant = rating * 0.45 - 30
        }
    }

}
