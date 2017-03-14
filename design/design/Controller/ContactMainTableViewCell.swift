//
//  ContactMainTableViewCell.swift
//  design
//
//  Created by Big Shark on 01/03/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class ContactMainTableViewCell: UITableViewCell {
    
    var product : ProductModel!
    @IBOutlet weak var completionRate: KDCircularProgress!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(){
        completionRate.angle = 360 * Double(product.completed) / 100
        
    }
}
