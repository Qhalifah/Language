//
//  UIView+ViewController.swift
//  design
//
//  Created by Big Shark on 01/03/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}



extension UIImageView{
    
    
    func setImageWith(color: UIColor)
    {
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
    
    /*
    
    func setImageWith(storageRefString: String, placeholderImage: UIImage)
    {
        if storageRefString == ""
        {
            image = placeholderImage
        }
        else if storageRefString.hasPrefix("https://fb")
        {
            self.sd_setImage(with: URL(string: storageRefString), placeholderImage: placeholderImage)
        }
        else{
            let reference : FIRStorageReference = FIRStorage.storage().reference(forURL: storageRefString)
            self.sd_setImage(with: reference, placeholderImage: placeholderImage)
        }
        
    }*/
    
    
}
