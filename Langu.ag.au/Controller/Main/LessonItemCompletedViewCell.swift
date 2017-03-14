//
//  LessonItemCompletedViewCell.swift
//  Langu.ag
//
//  Created by Huijing on 30/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit

class LessonItemCompletedViewCell: UICollectionViewCell {

    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imvCategory: UIImageView!
    @IBOutlet weak var imvCompletionStar: UIImageView!
    @IBOutlet weak var lblLessonMarks: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!//(160-> 120)

    @IBOutlet weak var shareButtonTopConstraint: NSLayoutConstraint! //(35->30)
}
