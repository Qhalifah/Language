
//
//  TestData.swift
//  design
//
//  Created by Big Shark on 26/02/2017.
//  Copyright © 2017 shark. All rights reserved.
//

import Foundation
import UIKit

class TestData{
    
    static func getTopItems() -> [ProductModel]{
        
        var products : [ProductModel] = []
        
        for index in 0...5{
            let product = ProductModel()
            product.title = "Test headline \(index)"
            product.imageString = "image\(index + 3)"
            products.append(product)
        }
        return products
    }
    
    static func getProducts(_ categoryId: Int) -> [ProductModel]{
        var products : [ProductModel] = []
        for index in 0...10{
            let product = ProductModel()
            product.title = "Test Title \(categoryId) - \(index)"
            product.imageString =  "image\(index)"
            product.price = "ab \(index) €"
            product.completed = 30
            products.append(product)
        }
        return products
    }
    static func getCurrentItems(_ categoryId: Int) -> [ProductModel]{
        var products : [ProductModel] = []
        for index in 0...2{
            let product = ProductModel()
            product.title = "Test Title \(categoryId) - \(index)"
            product.imageString =  "image\(index)"
            product.price = "ab \(index) €"
            product.completed = 72 + index
            products.append(product)
        }
        return products
    }
    static func getExpiredItems(_ categoryId: Int) -> [ProductModel]{
        var products : [ProductModel] = []
        for index in 0...2{
            let product = ProductModel()
            product.title = "Test Title \(categoryId) - \(index)"
            product.imageString =  "image\(index)"
            product.price = "ab \(index) €"
            product.completed = 100
            products.append(product)
        }
        return products
    }
    static func getFutureItems(_ categoryId: Int) -> [ProductModel]{
        var products : [ProductModel] = []
        for index in 0...10{
            let product = ProductModel()
            product.title = "Test Title \(categoryId) - \(index)"
            product.imageString =  "image\(index)"
            product.price = "ab \(index) €"
            product.completed = 0
            products.append(product)
        }
        return products
    }
    
    static func getRecentPost() -> [PostModel]{
        var posts : [PostModel] = []
        var post = PostModel()
        post.post_type = "Events"
        post.post_title = "SNOW STORM ON BERLIN , BREAKING NEWS"
        post.post_image = "img_fragement_ex_1_1"
        posts.append(post)
        
        post = PostModel()
        post.post_type = "Building"
        post.post_title = "NEW WAY TO BUILD HIGH BUILDINGS"
        post.post_image = "img_fragement_ex_1_3"
        posts.append(post)
        return posts
    }
}


