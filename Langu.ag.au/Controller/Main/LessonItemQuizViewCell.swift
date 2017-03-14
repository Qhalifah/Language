//
//  LessonItemGuessViewCell.swift
//  Langu.ag
//
//  Created by Huijing on 27/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class LessonItemQuizViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imvPlay: UIImageView!
    @IBOutlet weak var progressView: MBCircularProgressBarView!

    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var answerView1: UIView!
    @IBOutlet weak var answerView2: UIView!
    @IBOutlet weak var answerView3: UIView!
    @IBOutlet weak var answerView4: UIView!

    @IBOutlet weak var answerLabel1: UILabel!
    @IBOutlet weak var answerLabel2: UILabel!
    @IBOutlet weak var answerLabel3: UILabel!
    @IBOutlet weak var answerLabel4: UILabel!

    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var btnAnswer3: UIButton!
    @IBOutlet weak var btnAnswer4: UIButton!
    @IBOutlet weak var playButtonBottomConstraint: NSLayoutConstraint! //(25 -> 20 )

    @IBOutlet weak var phaseLabelTopConstraint: NSLayoutConstraint!//(25 -> 20 )

    @IBOutlet weak var playButtonTopConstraint: NSLayoutConstraint!//(30 -> 20 )

}
