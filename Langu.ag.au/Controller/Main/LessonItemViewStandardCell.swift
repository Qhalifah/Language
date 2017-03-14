//
//  LessonItemViewStandardCell.swift
//  Langu.ag
//
//  Created by Huijing on 27/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import MBCircularProgressBar


class LessonItemViewStandardCell: UICollectionViewCell {

    @IBOutlet weak var imvItemImage: UIImageView!
    @IBOutlet weak var imvChecked: UIImageView!
    @IBOutlet weak var imvFavorite: UIImageView!

    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint! //(140 -> 100)
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var imvPlay: UIImageView!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblTransliteration: UILabel!
    @IBOutlet weak var progressView: MBCircularProgressBarView!

    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
}
