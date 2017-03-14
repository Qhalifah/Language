//
//  StorageItemTableViewCell.swift
//  Langu.ag
//
//  Created by Huijing on 22/01/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import UIKit

class StorageItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imvDeleteImage: UIImageView!
    @IBOutlet weak var lblDirectoryName: UILabel!
    @IBOutlet weak var lblDirectorySize: UILabel!
    @IBOutlet weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
