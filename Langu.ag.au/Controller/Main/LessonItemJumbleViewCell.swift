//
//  LessonItemPuzzleViewCell.swift
//  Langu.ag
//
//  Created by Huijing on 27/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit

class LessonItemJumbleViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblWords: UILabel!
    @IBOutlet weak var imvItemImage: UIImageView!
    @IBOutlet weak var answerview: JumblesView!
    @IBOutlet weak var jumbleView: JumblesView!
    @IBOutlet weak var btnSubmit: UIButton!

    @IBOutlet weak var wordTopConstraint: NSLayoutConstraint!//(25 -> 20)
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!//(120->80)
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var answerViewHeightContraint: NSLayoutConstraint! //( 90 -> 70)
    @IBOutlet weak var jumbleViewHeightContraint: NSLayoutConstraint! //( 90 -> 70)
}
