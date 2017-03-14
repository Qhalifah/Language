//
//  LessonItemViewController.swift
//  Langu.ag
//
//  Created by Huijing on 23/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import MBCircularProgressBar



class LessonItemViewController: BaseViewController , AVAudioPlayerDelegate{

    var lessonId = ""
    var lessonOrderInCategory = 0

    var lessonMadeItems: [AnyObject] = []
    var learningLanguageItems : [[String: AnyObject]] = []
    var myLanguageItems:[[String: AnyObject]] = []
    var lessonViewedCount = 0
    var categoryImageName = ""
    var categoryId = ""

    @IBOutlet weak var lblLearningLanguage: UILabel!
    @IBOutlet weak var lblXpPoints: UILabel!

    var updater : CADisplayLink! = nil
    var selectedProgressBar = 0

    var collectionViewCellWidth : CGFloat = 0.0
    var collectionViewCellHeight : CGFloat = 0.0

    var player : AVAudioPlayer?

    @IBOutlet weak var collectionViewLangItems: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblLearningLanguage.text = currentUser.user_languageto
        let screenSize = UIScreen.main.bounds
        collectionViewCellWidth = screenSize.width
        collectionViewCellHeight = screenSize.height - 120

        // Do any additional setup after loading the view.

        player?.delegate = self
        getLanguageItemData(lessonId: lessonId)

        let totallearnt = GetDataFromFMDBManager.getTotalLearnt(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
        lblXpPoints.text = "\(GetDataFromFMDBManager.getPoints(totallearnt))"


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getLanguageItemData(lessonId: String){
        //let lessonCodes = GetDataFromFMDBManager.getCodesFromLesson(lessonId: lessonId)
        lessonMadeItems = []

        //get mylanguage items for lesson id
        let myLangItems = GetDataFromFMDBManager.getLanguageItemFromCodes(language: StringUtils.getLanguageShortNameLowerCase(languageName: currentUser.user_languagefrom), lessonId: lessonId)

        //get learning language items for lesson id
        let learningLangItems = GetDataFromFMDBManager.getLanguageItemFromCodes(language: StringUtils.getLanguageShortNameLowerCase(languageName: currentUser.user_languageto), lessonId: lessonId)

        //get displaying langu items for lesson id
        var itemsForLesson = GetDataFromFMDBManager.getLanguItemsFor(lessonId: lessonId, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)

        if itemsForLesson.count == 0
        {
            for item in myLangItems{
                FMDBManagerSetData.insertLangItems(user: currentUser, itemType: Constants.VALUE_LANGUITEM_STANDARD, itemStatus: Constants.VALUE_LANGUSTATUS_NOTDETECTED, itemViewed: false, lessonCodeId: item[Constants.KEY_LESSON_CODEID] as! String)
                FMDBManagerSetData.insertLangItems(user: currentUser, itemType: Constants.VALUE_LANGUITEM_QUIZ, itemStatus: Constants.VALUE_LANGUSTATUS_NOTDETECTED, itemViewed: false, lessonCodeId: item[Constants.KEY_LESSON_CODEID] as! String)
                FMDBManagerSetData.insertLangItems(user: currentUser, itemType: Constants.VALUE_LANGUITEM_JUMBLE, itemStatus: Constants.VALUE_LANGUSTATUS_NOTDETECTED, itemViewed: false, lessonCodeId: item[Constants.KEY_LESSON_CODEID] as! String)
            }

            itemsForLesson = GetDataFromFMDBManager.getLanguItemsFor(lessonId: lessonId, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
        }

        lessonMadeItems = CommonUtils.getLessonItemsObject(from: itemsForLesson as [AnyObject])

        for item in lessonMadeItems{
            let itemCodeId = item[Constants.KEY_LESSON_CODEID] as! String
            myLanguageItems.append(getItemObjectFrom(codeId: itemCodeId, objectArray: myLangItems as [AnyObject]) as! [String : AnyObject])
            learningLanguageItems.append(getItemObjectFrom(codeId: itemCodeId, objectArray: learningLangItems as [AnyObject]) as! [String : AnyObject])
        }
        
        collectionViewLangItems.reloadData()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let nextIndexPath = NSIndexPath(item: lessonViewedCount  , section: 0) as IndexPath
        collectionViewLangItems.scrollToItem(at: nextIndexPath, at: .left, animated: false)
    }


    @IBAction func backButtonTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }


    //item funcitons
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let index = (sender.tag - 12)/100
        let audioFileUrl = Constants.LOCAL_FILE_ROOT_DIR + (learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_AUDIOF] as! String)
        playAudio(fileUrl: audioFileUrl, senderId: sender.tag - 1)

    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let index = (sender.tag - 13) / 100
        let item = lessonMadeItems[index]
        if (item.value(forKey: Constants.KEY_LANGITEM_STATUS) as! Int) == Constants.VALUE_LANGUSTATUS_FAVORITE {
            guard var itemChangable = lessonMadeItems[index] as? [String: AnyObject] else {
                return
            }
            itemChangable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_NOTDETECTED as AnyObject?
            lessonMadeItems[index] = itemChangable as AnyObject
            self.view.isUserInteractionEnabled = false
            FMDBManagerSetData.updateLangItems(item: lessonMadeItems[index], completion: {
                self.view.isUserInteractionEnabled = true
            })
            let imageView = self.view.viewWithTag(19 + index * 100) as! UIImageView
            imageView.image = UIImage(named: "icon_favorite")
            FMDBManagerSetData.setItemFavorite(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, codeId: itemChangable[Constants.KEY_LESSON_CODEID] as! String, status: false)
        }
        else{
            guard var itemChangable = lessonMadeItems[index] as? [String: AnyObject] else {
                return
            }
            itemChangable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_FAVORITE as AnyObject?
            lessonMadeItems[index] = itemChangable as AnyObject
            self.view.isUserInteractionEnabled = false
            FMDBManagerSetData.updateLangItems(item: lessonMadeItems[index], completion: {
                self.view.isUserInteractionEnabled = true
            })
            let imageView = self.view.viewWithTag(19 + index * 100) as! UIImageView
            imageView.image = UIImage(named: "icon_favoriteChecked")
            FMDBManagerSetData.setItemFavorite(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, codeId: itemChangable[Constants.KEY_LESSON_CODEID] as! String, status: true)
        }
    }

    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        let index = (sender.tag - 15)/100
        let jumbleView = self.view.viewWithTag(20 + index * 100) as! JumblesView
        let answerString = LanguItem.getAnswerArray(stringArray: jumbleView.jumblesArray, jumbleOrigin: jumbleView.jumbleOrigin)
        if (learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as! String) == answerString{
            sender.setTitle("Correct", for: .normal)
            sender.setBackgroundImage(UIImage(named: "icon_correct"), for: .normal)
            guard var itemChangable = lessonMadeItems[index] as? [String: AnyObject] else {
                return
            }
            
            playCorrect()
            
            itemChangable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_CORRECT as AnyObject
            lessonMadeItems[index] = itemChangable as AnyObject
            self.view.isUserInteractionEnabled = false
            FMDBManagerSetData.updateLangItems(item: lessonMadeItems[index], completion: {
                self.view.isUserInteractionEnabled = true
            })
            self.view.viewWithTag(5 + sender.tag)?.isUserInteractionEnabled = false
            sender.isUserInteractionEnabled = false
            let totallearnt = GetDataFromFMDBManager.getTotalLearnt(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
            lblXpPoints.text = "\(GetDataFromFMDBManager.getPoints(totallearnt))"
            let answerCorrectView = AnswerResultView()
            self.view.addSubview(answerCorrectView)
            answerCorrectView.setAnswerView(answerType: Constants.VALUE_LANGUITEM_JUMBLE, answerResult: true)
            
            //if
        }
        else{
            guard var itemChangable = lessonMadeItems[index] as? [String: AnyObject] else {
                return
            }
            
            playUncorrect()
            
            itemChangable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_INCORRECT as AnyObject
            lessonMadeItems[index] = itemChangable as AnyObject
            self.view.isUserInteractionEnabled = false
            FMDBManagerSetData.updateLangItems(item: lessonMadeItems[index], completion: {
                self.view.isUserInteractionEnabled = true
            })
            let answerCorrectView = AnswerResultView()
            self.view.addSubview(answerCorrectView)
            answerCorrectView.setAnswerView(answerType: Constants.VALUE_LANGUITEM_JUMBLE, answerResult: false)
        }

    }
    
    func playCorrect(){
        if GetDataFromFMDBManager.isLessonCompleted(lessonId: lessonId){
            FirebaseUtils.saveUserProgress(userid: currentUser.user_uid, lessonId: lessonId)
        }
        let url = URL(string: Bundle.main.path(forResource: "right", ofType: "mp3")!)
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func playUncorrect(){
        
        let url = URL(string: Bundle.main.path(forResource: "wrong", ofType: "mp3")!)
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @IBAction func quizItemTapped(_ sender: UIButton) {
        let index = Int(sender.tag / 100)
        let answerLabel = self.view.viewWithTag(sender.tag + 40) as! UILabel

        let answerString = learningLanguageItems[index][Constants.KEY_LANGUAGEITEM_TEXT] as! String
        if answerString == answerLabel.text!{
            let answerView = self.view.viewWithTag(sender.tag + 20)
            answerView?.borderColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
            answerView?.borderWidth = 1
            answerView?.backgroundColor = UIColor.init(colorLiteralRed: 3/255, green: 169/255, blue: 244/255, alpha: 1)
            guard var itemChangable = lessonMadeItems[index] as? [String: AnyObject] else {
                return
            }
            playCorrect()
            itemChangable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_CORRECT as AnyObject
            lessonMadeItems[index] = itemChangable as AnyObject
            self.view.isUserInteractionEnabled = false
            FMDBManagerSetData.updateLangItems(item: lessonMadeItems[index], completion:{
                self.view.isUserInteractionEnabled = true
            })
            var view : UIView!
            view = self.view.viewWithTag(41 + index * 100)
            view.isUserInteractionEnabled = false
            view = self.view.viewWithTag(42 + index * 100)
            view.isUserInteractionEnabled = false
            view = self.view.viewWithTag(43 + index * 100)
            view.isUserInteractionEnabled = false
            view = self.view.viewWithTag(44 + index * 100)
            view.isUserInteractionEnabled = false
            let totallearnt = GetDataFromFMDBManager.getTotalLearnt(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
            lblXpPoints.text = "\(GetDataFromFMDBManager.getPoints(totallearnt))"

            let answerCorrectView = AnswerResultView()
            self.view.addSubview(answerCorrectView)
            answerCorrectView.setAnswerView(answerType: Constants.VALUE_LANGUITEM_QUIZ, answerResult: true)
        }
        else{
            guard var itemChangable = lessonMadeItems[index] as? [String: AnyObject] else {
                return
            }
            
            
            playUncorrect()
            itemChangable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_INCORRECT as AnyObject
            lessonMadeItems[index] = itemChangable as AnyObject
            self.view.isUserInteractionEnabled = false
            FMDBManagerSetData.updateLangItems(item: lessonMadeItems[index], completion: {
                self.view.isUserInteractionEnabled = true
            })

            let answerCorrectView = AnswerResultView()
            self.view.addSubview(answerCorrectView)
            answerCorrectView.setAnswerView(answerType: Constants.VALUE_LANGUITEM_QUIZ, answerResult: false)
        }

    }


    func getItemObjectFrom(codeId : String, objectArray: [AnyObject]) -> AnyObject?{
        for object in objectArray{
            if (object[Constants.KEY_LESSON_CODEID] as! String) == codeId{
                return object
            }
        }
        return nil
    }

    func playAudio(fileUrl: String, senderId: Int)
    {
        // set URL of the sound
        let url = URL(string: fileUrl)
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            selectedProgressBar = senderId
            updater = CADisplayLink(target: self, selector: #selector(trackAudio))
            updater.frameInterval = 1
            updater.add(to: .current, forMode: .commonModes)
            player.prepareToPlay()
            player.play()
            setProgressBarWith(tag: senderId, progress: 0)
            collectionViewLangItems.isScrollEnabled = false
        } catch let error {
            print(error.localizedDescription)
        }
        
    }

    func setProgressBarWith(tag: Int, progress: CGFloat){
        let temp = self.view.viewWithTag(tag)
        if(temp != nil){
            let progressView = temp as! MBCircularProgressBarView
            progressView.value = progress
        }
    }

    func trackAudio()
    {
        let normalizedTime = CGFloat((player?.currentTime)! * 100 / (player?.duration)!)
        setProgressBarWith(tag: selectedProgressBar, progress: normalizedTime)
        if(!(player?.isPlaying)!){
            setProgressBarWith(tag: selectedProgressBar, progress: 0)
            updater.invalidate()
            collectionViewLangItems.isScrollEnabled = true
        }
    }
    
    func setCompletionCell(_ completion : Bool, cell: LessonItemCompletedViewCell?) -> LessonItemCompletedViewCell?{
        
        if completion {
            cell?.lblTitle.text = "Success!\nLesson Complete"
            cell?.imvCompletionStar.image = UIImage(named: "icon_lessoncompleted")
            cell?.lblLessonMarks.text = "\(5 * lessonMadeItems.count / 3 + 10 * lessonMadeItems.count * 2 / 3) "
            cell?.btnShare.isHidden = false
            cell?.buttonsView.isHidden = false
       }
        else{
            cell?.lblTitle.text = "Lesson Incompleted"
            cell?.imvCompletionStar.image = UIImage(named: "icon_lessonincompleted")
            cell?.btnShare.isHidden = true
            cell?.buttonsView.isHidden = true
        }
        return cell
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        FMDBManagerSetData.refreshLessonData(lessonId: lessonId, languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
        viewDidLoad()
        collectionViewLangItems.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        gotoNextLesson()
    }
    
    func gotoNextLesson(){
        let category_lesssons = GetDataFromFMDBManager.getLessonsFromCategory(categoryId: categoryId)
        if category_lesssons.count > lessonOrderInCategory {
            let lesson = category_lesssons[lessonOrderInCategory]
            let lessonItemVC = storyboard?.instantiateViewController(withIdentifier: "LessonItemViewController") as! LessonItemViewController
            lessonItemVC.lessonId = lesson.lesson_id
            lessonItemVC.lessonViewedCount = lesson.lesson_viewedphasecount
            if lesson.lesson_completed{
                lessonItemVC.lessonViewedCount = 3 * lesson.lesson_viewedphasecount
            }
            lessonItemVC.categoryId = categoryId
            lessonItemVC.lessonOrderInCategory = lessonOrderInCategory + 1
            lessonItemVC.categoryImageName = self.categoryImageName
            self.navigationController?.pushViewController(lessonItemVC, animated: true)
        }
        else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let text = "langu.ag"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

    
}
