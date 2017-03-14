//
//  HomeTableViewCell.swift
//  Langu.ag
//
//  Created by Huijing on 16/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import Material
import MBCircularProgressBar



class HomeTableViewCell: TableViewCell{

    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var completedLessonCount: UILabel!
    @IBOutlet weak var totalLessonCount: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var imvList: UIImageView!
    @IBOutlet weak var completionRateView: MBCircularProgressBarView!
    @IBOutlet weak var unlockView: UIView!

    var movableView1: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
        imvList.setImageWith(color: UIColor(colorLiteralRed: 1, green: 87/255, blue: 34/255, alpha: 1))
    }

}
