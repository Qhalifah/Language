//
//  UIImageView+Color.swift
//  Langu.ag
//
//  Created by Huijing on 24/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseStorageUI


extension UIImageView{


    func setImageWith(color: UIColor)
    {
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }

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

    }


}


func removeImageCache(forKey: String)
{

    let imageCache = SDImageCache.shared()
    imageCache?.removeImage(forKey: forKey, fromDisk: true)

    let fbCache = FirebaseStorageUI.SDImageCache.shared()
    fbCache?.removeImage(forKey: forKey, fromDisk: true)


}
