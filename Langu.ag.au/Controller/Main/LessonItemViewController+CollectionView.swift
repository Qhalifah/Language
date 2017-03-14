
//
//  LessonItemViewController+CollectionView.swift
//  Langu.ag
//
//  Created by Huijing on 11/01/2017.
//  Copyright © 2017 Huijing. All rights reserved.
//

import UIKit


extension LessonItemViewController: UICollectionViewDelegate, UICollectionViewDataSource,JumbleItemDelegate /*, UIScrollViewDelegate*/{

    //Mark - UICollectionViewDelegate

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessonMadeItems.count + 1
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var resultCell = UICollectionViewCell()
        let index = indexPath.row
        let screenHeight = UIScreen.main.bounds.size.height
        if index < lessonMadeItems.count
        {
            let item = lessonMadeItems[index]
            
            let kindOfCell = item.value(forKey: Constants.KEY_LANGITEM_TYPE) as! Int
            if(kindOfCell == Constants.VALUE_LANGUITEM_STANDARD){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonItemViewStandardCell", for: indexPath) as! LessonItemViewStandardCell

                cell.imvChecked.setImageWith(color: UIColor.lightGray)
                cell.imvFavorite.setImageWith(color: UIColor.lightGray)
                cell.imvItemImage.sd_setImage(with: URL(string:Constants.LOCAL_FILE_ROOT_DIR + (myLanguageItems[index][Constants.KEY_LANGUAGEITEM_IMAGE] as! String)))
                cell.lblWord.text = myLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as? String
                cell.lblAnswer.text = learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as? String
                cell.lblTransliteration.text = learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_TRANSLITERATION] as? String
                cell.imvPlay.image = UIImage(named: "icon_play")

                cell.tag = 10 + index * 100
                cell.progressView.tag = 11 + index * 100
                cell.progressView.value = 0
                cell.btnPlay.tag = 12 + index * 100
                cell.btnFavorite.tag = 13 + index * 100
                cell.imvFavorite.tag = 19 + index * 100
                if(item[Constants.KEY_LANGUAGEITEM_VIEWED] as! Bool){
                    cell.imvChecked.setImageWith(color: UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1))
                }
                else{
                    cell.imvChecked.setImageWith(color: UIColor.lightGray)
                }

                if (item[Constants.KEY_LANGITEM_STATUS] as! Int) == Constants.VALUE_LANGUSTATUS_FAVORITE{
                    cell.imvFavorite.image = UIImage(named: "icon_favoriteChecked")
                }
                else{
                    cell.imvFavorite.image = UIImage(named: "icon_favorite")
                }
                
                if screenHeight < 600{
                    cell.imageHeightConstraint.constant = 100
                    cell.imvItemImage.layer.cornerRadius = 50
                    
                }

                //if(learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_])
                resultCell = cell

            }
            else if(kindOfCell == Constants.VALUE_LANGUITEM_QUIZ)
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonItemQuizViewCell", for: indexPath) as! LessonItemQuizViewCell
                cell.lblWord.text = myLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as? String
                cell.tag = 10 + index * 100
                cell.progressView.tag = 11 + index * 100
                cell.btnPlay.tag = 12 + index * 100
                cell.progressView.value = 0
                cell.btnAnswer1.tag = 21 + index * 100
                cell.btnAnswer2.tag = 22 + index * 100
                cell.btnAnswer3.tag = 23 + index * 100
                cell.btnAnswer4.tag = 24 + index * 100

                cell.answerView1.tag = 41 + index * 100
                cell.answerView2.tag = 42 + index * 100
                cell.answerView3.tag = 43 + index * 100
                cell.answerView4.tag = 44 + index * 100

                cell.answerLabel1.tag  = 61 + index * 100
                cell.answerLabel2.tag  = 62 + index * 100
                cell.answerLabel3.tag  = 63 + index * 100
                cell.answerLabel4.tag  = 64 + index * 100
                let answerString = learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as! String
                let quizItems = LanguItem.getQuizArray(from: learningLanguageItems as [AnyObject] , correctAnswer: answerString)
                cell.answerLabel1.text = quizItems[0]
                cell.answerLabel2.text = quizItems[1]
                cell.answerLabel3.text = quizItems[2]
                cell.answerLabel4.text = quizItems[3]


                cell.answerView1.borderColor = UIColor.lightGray
                cell.answerView1.borderWidth = 1
                cell.answerView1.backgroundColor = UIColor.white
                cell.answerView2.borderColor = UIColor.lightGray
                cell.answerView2.borderWidth = 1
                cell.answerView2.backgroundColor = UIColor.white
                cell.answerView3.borderColor = UIColor.lightGray
                cell.answerView3.borderWidth = 1
                cell.answerView3.backgroundColor = UIColor.white
                cell.answerView4.borderColor = UIColor.lightGray
                cell.answerView4.borderWidth = 1
                cell.answerView4.backgroundColor = UIColor.white
                if (item[Constants.KEY_LANGITEM_STATUS] as! Int) == Constants.VALUE_LANGUSTATUS_CORRECT {
                    if (quizItems[0] == answerString){
                        cell.answerView1.borderColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
                        cell.answerView1.borderWidth = 1
                        cell.answerView1.backgroundColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
                        cell.answerView1.isUserInteractionEnabled = false
                        cell.answerView2.isUserInteractionEnabled = false
                        cell.answerView3.isUserInteractionEnabled = false
                        cell.answerView4.isUserInteractionEnabled = false
                    }
                    else if (quizItems[1] == answerString){
                        cell.answerView2.borderColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
                        cell.answerView2.borderWidth = 1
                        cell.answerView2.backgroundColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
                        cell.answerView1.isUserInteractionEnabled = false
                        cell.answerView2.isUserInteractionEnabled = false
                        cell.answerView3.isUserInteractionEnabled = false
                        cell.answerView4.isUserInteractionEnabled = false
                    }
                    else if (quizItems[2] == answerString){
                        cell.answerView3.borderColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
                        cell.answerView3.borderWidth = 1
                        cell.answerView3.backgroundColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
                        cell.answerView1.isUserInteractionEnabled = false
                        cell.answerView2.isUserInteractionEnabled = false
                        cell.answerView3.isUserInteractionEnabled = false
                        cell.answerView4.isUserInteractionEnabled = false
                    }
                    else if (quizItems[3] == answerString){
                        cell.answerView4.borderColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
                        cell.answerView4.borderWidth = 1
                        cell.answerView4.backgroundColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
                        cell.answerView1.isUserInteractionEnabled = false
                        cell.answerView2.isUserInteractionEnabled = false
                        cell.answerView3.isUserInteractionEnabled = false
                        cell.answerView4.isUserInteractionEnabled = false
                    }
                }
                else{

                    cell.answerView1.isUserInteractionEnabled = true
                    cell.answerView2.isUserInteractionEnabled = true
                    cell.answerView3.isUserInteractionEnabled = true
                    cell.answerView4.isUserInteractionEnabled = true
                }

                if screenHeight < 600{
                    cell.playButtonBottomConstraint.constant = 20
                    cell.phaseLabelTopConstraint.constant = 20
                    cell.playButtonTopConstraint.constant = 20
                }
                resultCell = cell
            }
            else if(kindOfCell == Constants.VALUE_LANGUITEM_JUMBLE){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonItemJumbleViewCell", for: indexPath) as! LessonItemJumbleViewCell

                //set standard cell properties
                cell.lblWords.text = myLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as? String
                cell.imvItemImage.sd_setImage(with: URL(string:Constants.LOCAL_FILE_ROOT_DIR + (myLanguageItems[index][Constants.KEY_LANGUAGEITEM_IMAGE] as! String)))
                let jumbledItem = LanguItem.getJumbleArray(text: (learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as? String)!)
                let jumbledArray = jumbledItem.0
                var labelSize = CGSize(width: 0, height: 0)
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 17)
                for jumble in jumbledArray{
                    label.text = jumble
                    let size = label.intrinsicContentSize
                    if size.width > labelSize.width{
                        labelSize = size
                    }
                }

                cell.jumbleView.jumbleType = jumbledItem.1
                cell.answerview.labelSize = labelSize
                cell.jumbleView.labelSize = labelSize

                cell.jumbleView.jumbleType = JumblesView.JUMBLE_ITME_JUMBLE
                cell.answerview.jumbleType = JumblesView.JUMBLE_ITEM_ANSWER

                cell.answerview.viewWidth = collectionViewCellWidth - 60
                cell.jumbleView.viewWidth = collectionViewCellWidth - 60

                cell.tag = 10 + index * 100
                cell.answerview.tag = 20 + index * 100
                cell.jumbleView.tag = 60 + index * 100
                cell.btnSubmit.tag = 15 + index * 100
                let itemStatus = lessonMadeItems[index][Constants.KEY_LANGITEM_STATUS] as! Int
                if(itemStatus == Constants.VALUE_LANGUSTATUS_CORRECT)
                {
                    cell.answerview.firstBlankIndexFromStart = jumbledArray.count - 1
                    let correctJumbleArray = LanguItem.getCorrectJumbleArray(text: (learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as? String)!)
                    cell.answerview.initWith(items: correctJumbleArray.0)
                    cell.jumbleView.isHidden = true
                    cell.btnSubmit.setBackgroundImage(UIImage(named: "icon_correct"), for: .normal)
                    cell.btnSubmit.setTitle("Correct", for: .normal)
                    cell.answerview.isUserInteractionEnabled = false
                    cell.btnSubmit.isUserInteractionEnabled = false


                }
                else{
                    cell.answerview.firstBlankIndexFromStart = 0
                    cell.jumbleView.firstBlankIndexFromStart = jumbledArray.count - 1
                    cell.jumbleView.initWith(items: jumbledArray)
                    cell.answerview.initWith(items: [String](repeating: "", count: jumbledArray.count))
                    cell.btnSubmit.setBackgroundImage(UIImage(named: "icon_submit"), for: .normal)
                    cell.btnSubmit.setTitle("Submit", for: .normal)
                    cell.jumbleView.isHidden = false

                    cell.answerview.jumbleOrigin = jumbledItem.1

                    cell.answerview.isUserInteractionEnabled = true

                    cell.btnSubmit.isUserInteractionEnabled = true

                }
                cell.jumbleView.delegate = self
                cell.answerview.delegate = self
                
                if screenHeight < 600{
                    cell.wordTopConstraint.constant = 20
                    cell.imageHeightConstraint.constant = 80
                    cell.imvItemImage.layer.cornerRadius = 40
                    cell.imageTopConstraint.constant = 20
                    cell.answerViewHeightContraint.constant = 70
                    cell.jumbleViewHeightContraint.constant = 70
                }
                resultCell = cell
            }
        }
        else{
            let cell = collectionViewLangItems.dequeueReusableCell(withReuseIdentifier: "LessonItemCompletedViewCell", for: indexPath) as! LessonItemCompletedViewCell
            let completionValue = GetDataFromFMDBManager.getPharseCompletedCount(lessonId: lessonId, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
            
            if screenHeight < 600{
                cell.imageWidthConstraint.constant = 100
                cell.imvCategory.layer.cornerRadius = 50
                cell.shareButtonTopConstraint.constant = 20
            }
            if completionValue.0 > 0{
                if  completionValue.1 == completionValue.0 * 2{
                    resultCell = setCompletionCell(true, cell: cell)!
                }
                else{
                    resultCell = setCompletionCell(false, cell: cell)!
                }
            }
            else {
                resultCell = cell
            }
            
            
           
        }

        return resultCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSize(  width: collectionViewCellWidth, height: collectionViewCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        /*if indexPath.row == myLanguageItems.count{
            let completeCell = cell as! LessonItemCompletedViewCell
            //GetDataFromFMDBManager.

        }*/
        let index = indexPath.row
        if (index < lessonMadeItems.count)
        {
            let item = lessonMadeItems[index]
            let kindOfCell = item.value(forKey: Constants.KEY_LANGITEM_TYPE) as! Int
            if kindOfCell == Constants.VALUE_LANGUITEM_STANDARD {
                if !(item.value(forKey: Constants.KEY_LANGUAGEITEM_VIEWED ) as! Bool) {
                    guard var itemChangable = lessonMadeItems[index] as? [String: AnyObject] else {
                        return
                    }
                    itemChangable[Constants.KEY_LANGUAGEITEM_VIEWED] = true as AnyObject?
                    itemChangable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_CORRECT as AnyObject?
                    lessonMadeItems[index] = itemChangable as AnyObject
                    self.view.isUserInteractionEnabled = false
                    FMDBManagerSetData.updateLangItems(item: lessonMadeItems[index], completion: {
                        self.view.isUserInteractionEnabled = true
                    })
                }
            }
        }
        
        

    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if (index < lessonMadeItems.count)
        {
            let item = lessonMadeItems[index]
            let kindOfCell = item.value(forKey: Constants.KEY_LANGITEM_TYPE) as! Int
            if kindOfCell == Constants.VALUE_LANGUITEM_STANDARD {
                if !(item.value(forKey: Constants.KEY_LANGUAGEITEM_VIEWED ) as! Bool) {
                    guard var itemChangable = lessonMadeItems[index] as? [String: AnyObject] else {
                        return
                    }
                    itemChangable[Constants.KEY_LANGUAGEITEM_VIEWED] = true as AnyObject?
                    itemChangable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_CORRECT as AnyObject?
                    let standardCell = cell as! LessonItemViewStandardCell
                    standardCell.imvChecked.setImageWith(color: UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1))
                }
            }

            
        }
        
        
        let totallearnt = GetDataFromFMDBManager.getTotalLearnt(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
        lblXpPoints.text = "\(GetDataFromFMDBManager.getPoints(totallearnt))"
        
        if index == lessonMadeItems.count - 1{
            let completionValue = GetDataFromFMDBManager.getPharseCompletedCount(lessonId: lessonId, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
            guard let resultCell = collectionViewLangItems.cellForItem(at: IndexPath(item: indexPath.row + 1, section: 0)) else{
                return
            }
            let cell = resultCell as! LessonItemCompletedViewCell
            if completionValue.0 > 0{
                if  completionValue.1 == completionValue.0 * 2{
                    _ = setCompletionCell(true, cell: cell)
                }
                else{
                    _ = setCompletionCell(false, cell:cell)
                }
            }
        }

        
    }


    /****************** Jumble Cell item function ****************/
    func jumbleItemTapped(jumbleView: JumblesView, itemType: Bool, jumble: String) {
        let tag = jumbleView.tag
        if(itemType == JumblesView.JUMBLE_ITEM_ANSWER){
            let jumblesView = self.view.viewWithTag(tag + 40) as! JumblesView
            jumblesView.addItem(itemString: jumble)
            jumblesView.isHidden = false
        }
        else{
            let jumblesView = self.view.viewWithTag(tag - 40) as! JumblesView
            jumblesView.addItem(itemString: jumble)
            if (jumblesView.firstBlankIndexFromStart == jumbleView.jumblesArray.count){
                jumbleView.isHidden = true
            }
        }
    }


    
    
}


