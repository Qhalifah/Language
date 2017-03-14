//
//  UILabel+Font.swift
//  design
//
//  Created by Big Shark on 28/02/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

extension UILabel {
    func getWidth() -> CGFloat{        
        numberOfLines = 1
        sizeToFit()
        return frame.width
    }
}

