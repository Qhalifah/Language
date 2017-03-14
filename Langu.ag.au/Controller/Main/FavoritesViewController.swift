//
//  FavoritesViewController.swift
//  Langu.au
//
//  Created by Huijing on 09/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit
import AVFoundation

class FavoritesViewController: BaseViewController, AVAudioPlayerDelegate, UITextFieldDelegate {

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var cellSize : CGSize!

    @IBOutlet weak var lblLearningLanguage: UILabel!

    @IBOutlet weak var imvSearch: UIImageView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    var favorite_items : [[String: AnyObject]] = []
    var player : AVAudioPlayer?
    var updater: CADisplayLink?

    var playingItem = 0
    
    var controllerType = "Favorite"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true

        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width
        cellSize = CGSize(width: (width - 55)/2, height: 230)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoriteItems()
    }

    func getFavoriteItems(){
        if controllerType == "Favorite"{
            lblLearningLanguage.text = currentUser.user_languageto
            favorite_items = GetDataFromFMDBManager.getFavoriteItems(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto)
            btnBack.isHidden = true
            
            txtSearch.isHidden = true
        }
        else if controllerType == "Search"{
            lblLearningLanguage.isHidden = true
            imvSearch.isHidden = true
            btnSearch.isHidden = true
            txtSearch.isHidden = false
            favorite_items = GetDataFromFMDBManager.getMatchedItems(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, match: txtSearch.text!)
            btnBack.isHidden = false
        }
        
        itemsCollectionView.reloadData()

    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let index = (sender.tag - 10) / 10
        playingItem = sender.tag + 2
        let audioFileUrl = Constants.LOCAL_FILE_ROOT_DIR + (favorite_items[index]["favorite_audiourl"] as! String)
        playAudio(fileUrl: audioFileUrl, senderId: sender.tag - 1)
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if controllerType == "Favorite"{
        let index = (sender.tag - 11) / 10
        var itemChangeable : [String: AnyObject] = [:]
        itemChangeable[Constants.KEY_USER_LANGUAGEFROM] = currentUser.user_languagefrom as AnyObject
        itemChangeable[Constants.KEY_USER_LANGUAGETO] = currentUser.user_languageto as AnyObject
        itemChangeable[Constants.KEY_LANGITEM_TYPE] = Constants.VALUE_LANGUITEM_STANDARD as AnyObject
        itemChangeable[Constants.KEY_LESSON_CODEID] = favorite_items[index]["favorite_lessoncodeid"]
        if itemChangeable[Constants.KEY_LESSON_CODEID] as! String != ""{
            if (favorite_items[index][Constants.KEY_LANGITEM_STATUS] as? Int)! != Constants.VALUE_LANGUSTATUS_FAVORITE{
                itemChangeable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_FAVORITE as AnyObject
                FMDBManagerSetData.setItemFavorite(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, codeId: itemChangeable[Constants.KEY_LESSON_CODEID] as! String, status: true)
                }
                else{
                    itemChangeable[Constants.KEY_LANGITEM_STATUS] = Constants.VALUE_LANGUSTATUS_NOTDETECTED as AnyObject
                    FMDBManagerSetData.setItemFavorite(languageFrom: currentUser.user_languagefrom, languageTo: currentUser.user_languageto, codeId: itemChangeable[Constants.KEY_LESSON_CODEID] as! String, status: false)
                }
                itemChangeable[Constants.KEY_LANGUAGEITEM_VIEWED] = true as AnyObject
                
                self.view.isUserInteractionEnabled = false
                FMDBManagerSetData.updateLangItems(item: itemChangeable as AnyObject, completion: {
                    self.view.isUserInteractionEnabled = true
                })
                
                getFavoriteItems()
            }
        }

    }

    func playAudio(fileUrl: String, senderId: Int)
    {
        let imvPlay = self.view.viewWithTag(playingItem) as! UIImageView
        imvPlay.image = UIImage(named: "icon_pause")
        play(urlString: fileUrl)


    }

    func play(urlString: String){
        // set URL of the sound
        let url = URL(string: urlString)
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            updater = CADisplayLink(target: self, selector: #selector(trackAudio))
            updater?.frameInterval = 1
            updater?.add(to: .current, forMode: .commonModes)
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func trackAudio()
    {
        if(!(player?.isPlaying)!){

            updater?.invalidate()
            guard let imvPlay = self.view.viewWithTag(playingItem) as? UIImageView else {
                return
            }
            imvPlay.image = UIImage(named: "icon_play")
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated : true)
    }
   
    @IBAction func changedSearchCharacters(_ sender: Any) {
        getFavoriteItems()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        searchVC.controllerType = "Search"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}

extension FavoritesViewController: UICollectionViewDelegate,UICollectionViewDataSource
{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorite_items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.imvItemImage.sd_setImage(with: URL(string:Constants.LOCAL_FILE_ROOT_DIR + (favorite_items[index]["favorite_image"] as! String)))
        cell.lblItemText.text = favorite_items[index]["favorite_myword"] as? String
        cell.lblItemTextTo.text = favorite_items[index]["favorite_learntword"] as? String
        cell.lblItemTextTranslation.text = favorite_items[index]["favorite_transliteration"] as? String

        cell.borderView.layer.borderWidth = 1
        cell.borderView.layer.borderColor = UIColor.darkGray.cgColor

        cell.imvPlay.image = UIImage(named: "icon_play")
        if (favorite_items[index][Constants.KEY_LANGITEM_STATUS] as? Int)! == Constants.VALUE_LANGUSTATUS_FAVORITE{
            cell.imvFavorite.image = UIImage(named: "icon_favoriteChecked")
        }
        else{
            cell.imvFavorite.image = UIImage(named: "icon_favorite")
        }
        
        cell.btnPlay.tag = index * 10 + 10
        cell.btnFavorite.tag = index * 10 + 11
        cell.imvPlay.tag = index * 10 + 12
        cell.imvFavorite.tag = index * 10 + 13

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let index = indexPath.row
        var resultSize = CGSize()
        if index % 2 == 0 && favorite_items.count > index + 2
        {
            let size1 = getCellSize(index)
            let size2 = getCellSize(index + 1)
            if size1.height > size2.height{
                resultSize = size1
            }
            else {
                resultSize = size2
            }
        }
        else if (index % 2 == 1) {
            
            let size1 = getCellSize(index)
            let size2 = getCellSize(index - 1)
            if size1.height > size2.height{
                resultSize = size1
            }
            else {
                resultSize = size2
            }
        }
        else {
            resultSize = getCellSize(index)
        }
        return resultSize
    }
    
    func getCellSize(_ index: Int) -> CGSize{
        let string = favorite_items[index]["favorite_myword"] as! String
        NSLog("\(heightOfLabel(text: string, width: cellSize.width - 36))")
        return CGSize(width: cellSize.width, height : 190 + heightOfLabel(text: string, width: cellSize.width - 36) + heightOfLabel(text: favorite_items[index]["favorite_learntword"] as! String, width: cellSize.width - 36) + heightOfLabel(text: favorite_items[index]["favorite_transliteration"] as! String, width: cellSize.width - 36))
    }

    func heightOfLabel(text:String, width: CGFloat) -> CGFloat{
        let label = UILabel(frame: CGRect(x: 0, y:0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont(name: "Comfortaa-Light", size: 15)
        label.sizeToFit()
        return label.frame.height
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    
}
