//
//  TopItemTableViewCell.swift
//  design
//
//  Created by Big Shark on 28/02/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

class TopItemTableViewCell: UITableViewCell {

    @IBOutlet weak var productsView: StartHeaderAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
