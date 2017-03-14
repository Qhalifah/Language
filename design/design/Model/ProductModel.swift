//
//  TopItemModel.swift
//  design
//
//  Created by Big Shark on 25/02/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProductModel{
    
    var imageString = ""
    var title = "HEADLINE"
    var subTitle = "SUBTITLE"
    var price = ""
    var completed = 0
    
    static let PRODUCT_IMAGE = "pro_image"
    static let PRODUCT_TITLE = "pro_title"
    static let PRODUCT_SUBTITLE = "pro_subtitle"
    static let PRODUCT_PRICE = "pro_price"
    
    
    static func parseProduct(_ rawValue: AnyObject) -> ProductModel{
        let product = ProductModel()
        let jsonValue = JSON(rawValue)
        product.imageString = jsonValue[PRODUCT_IMAGE].stringValue
        product.title = jsonValue[PRODUCT_TITLE].stringValue
        product.subTitle = jsonValue[PRODUCT_SUBTITLE].stringValue
        product.price = jsonValue[PRODUCT_PRICE].stringValue
        
        return product
    }
    
    
    func getProductObject() -> AnyObject{
        var object : [String: AnyObject] = [:]
        object[ProductModel.PRODUCT_TITLE] = title as AnyObject
        object[ProductModel.PRODUCT_IMAGE] = imageString as AnyObject
        object[ProductModel.PRODUCT_SUBTITLE] = subTitle as AnyObject
        object[ProductModel.PRODUCT_PRICE] = price as AnyObject
        return object as AnyObject
    }
}

