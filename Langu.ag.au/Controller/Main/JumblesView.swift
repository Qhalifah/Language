//
//  JumblesView.swift
//  Langu.ag
//
//  Created by Huijing on 11/01/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import UIKit

public protocol JumbleItemDelegate {
    func jumbleItemTapped(jumbleView: JumblesView, itemType: Bool, jumble : String)
}

public class JumblesView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    static let JUMBLE_ITEM_ANSWER = true
    static let JUMBLE_ITME_JUMBLE = false
    static let JUMBLE_ORIGIN_WORD = true
    static let JUMBLE_ORIGIN_SENTENCE = false

    var jumblesArray:[String] = []
    var jumbleType = false
    var jumbleOrigin = false
    var firstBlankIndexFromStart = 0

    var leftMargin : CGFloat = 0
    var bottomMargin: CGFloat = 15
    var marginForEachItems : CGFloat = 8

    var itemLeftMargin: CGFloat = 10
    var itemBottomMargin: CGFloat = 6
    var viewWidth : CGFloat = 0

    var labelSize : CGSize!
    var contentViewSize : CGSize!

    var delegate: JumbleItemDelegate!

    func initWith(items: [String]){
        jumblesArray = items

        //reset label size

        for subView in subviews
        {
            subView.removeFromSuperview()
        }

        contentViewSize = CGSize(width: labelSize.width + itemLeftMargin * 2, height: labelSize.height + itemBottomMargin * 2)

        var index = 0
        for item in items{
            let itemView = UIView.init(frame: getFrameFromIndex(index: index, size: contentViewSize))
            addSubview(itemView)
            makeViewFrom(to: itemView, itemString: item, index: index)
            index += 1
        }

    }


    func getItemPath(index: Int) -> [Int]
    {
        var result: [Int] = []
        result.append(Int((index) / getItemsInARow()))
        result.append((index) % getItemsInARow())
        return result

    }

    func getItemsInARow() -> Int{
        return Int((viewWidth - 2 * leftMargin + marginForEachItems) / (contentViewSize.width + marginForEachItems))
    }

    func getFrameFromIndex(index: Int, size: CGSize) -> CGRect{


        let path = getItemPath(index: index)
        let rect = CGRect(x: getMarginForLeft(index) + CGFloat(path[1]) * (contentViewSize.width + marginForEachItems), y: CGFloat(path[0]) * (contentViewSize.height + bottomMargin), width: contentViewSize.width, height: contentViewSize.height)
        return rect
    }

    func getMarginForLeft(_ index: Int) -> CGFloat{
        let path = getItemPath(index: index)
        var marginForLeft : CGFloat = 0
        let itemCountInRow = jumblesArray.count - (path[0] + 1) * getItemsInARow() + getItemsInARow()
        if itemCountInRow >= getItemsInARow(){
            marginForLeft = (viewWidth - ((contentViewSize.width + marginForEachItems) * CGFloat(getItemsInARow()) + marginForEachItems))/2
        }
        else{
            marginForLeft = (viewWidth - ((contentViewSize.width + marginForEachItems) * CGFloat(itemCountInRow) + marginForEachItems))/2
        }

        return marginForLeft

    }

    func addItem(itemString: String){
        setItem(index: firstBlankIndexFromStart, itemText: itemString)
        var index = firstBlankIndexFromStart + 1
        while index < jumblesArray.count {
            if jumblesArray[index] == ""
            {
                break;
            }
            index += 1
        }
        firstBlankIndexFromStart = index
    }

    func removeItem(index: Int) -> String{
        if(jumblesArray[index].characters.count == 0)
        {
            return ""
        }
        else{
            let result = jumblesArray[index]
            if index < firstBlankIndexFromStart{
                firstBlankIndexFromStart = index
            }
            setItem(index: index, itemText: "")
            return result
        }
    }

    func setItem(index: Int, itemText: String){
        let label = viewWithTag(tag + index + 1) as! UILabel
        label.text = itemText
        jumblesArray[index] = itemText
    }

    func makeViewFrom(to parentView: UIView, itemString: String, index: Int){
        let imageView = UIImageView()
        imageView.frame.size = contentViewSize
        imageView.image = UIImage(named: "icon_langitembackground")
        parentView.addSubview(imageView)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.tag = tag + index + 1
        label.frame = CGRect(x: itemLeftMargin, y: itemBottomMargin, width: labelSize.width, height: labelSize.height)
        label.text = itemString
        label.textAlignment = .center
        parentView.addSubview(label)
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: contentViewSize.width, height: contentViewSize.height)
        button.tag = tag + index + 21
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        parentView.addSubview(button)
    }

    func buttonTapped(sender: UIButton){
        let index = sender.tag - 21 - tag
        let jumble = removeItem(index: index)
        if(jumble != ""){
            delegate.jumbleItemTapped(jumbleView: self, itemType: jumbleType, jumble: jumble)
        }
    }


}
