//
//  LessonContentViewController.swift
//  Langu.ag
//
//  Created by Huijing on 23/12/2016.
//  Copyright © 2016 Huijing. All rights reserved.
//

import UIKit

class LessonContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var lessonsCollectionView: UICollectionView!
    var collectionViewSize: CGSize!

    var lessons: [LessonModel] = []
    var categoryImageName = ""
    var orderValue = 0
    
    var locked = true

    var categoryId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        //lessonsCollectionView.scrollview
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        lessonsCollectionView.reloadData()
    }

    //Mark - UICollectionView Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if locked{
            return 1
        }
        return lessons.count + 1
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()
        let index = indexPath.row
        if(index == 0)
        {
            let cell0 = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            cell0.imvCategory.image = UIImage(named: categoryImageName)
            if locked{
                cell0.btnShowLesson.isHidden = true
                cell0.imvBackground.isHidden = true
                cell0.imvShowLessons.isHidden = true
            }
            else{
                cell0.btnShowLesson.isHidden = false
                cell0.imvBackground.isHidden = false
                cell0.imvShowLessons.isHidden = false
            }
            cell = cell0
        }
        else{
            
           
            let cell0 = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonCollectionViewCell", for: indexPath) as! LessonCollectionViewCell
            
            cell0.lessonStageLabel.text = "\(index)"
            cell0.lessonTitleLabel.text = "Lesson\(index)"
            if index == 1{
                cell0.leftLineView.isHidden = true
                cell0.rightLineView.isHidden = false
            }
            else if index == lessons.count
            {
                cell0.rightLineView.isHidden = true
                cell0.leftLineView.isHidden = false
            }
            else{
                cell0.leftLineView.isHidden = false
                cell0.rightLineView.isHidden = false
            }
            let lesson = lessons[index - 1]
            if (lesson.lesson_completed)
            {
                cell0.lessonStageLabel.backgroundColor = UIColor(colorLiteralRed: 33/255, green: 155/255, blue: 243/255, alpha: 1)
            }
            else
            {
                cell0.lessonStageLabel.backgroundColor = UIColor.white
            }
            if lesson.lesson_viewedphasecount > 0{
                cell0.setRating(CGFloat(lesson.lesson_correctphasecount) / CGFloat(lesson.lesson_viewedphasecount) * 50)
            }
            else {
                cell0.setRating(0)
            }


            NSLog("\(lessons[index - 1].lesson_ratings)")
            cell = cell0
        }
        cell.tag = 100 * orderValue + 15
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if (index > 0){
            let lesson = lessons[index - 1]
            
            gotoLessonItemViewController(lesson: lesson, index: index)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        
        if(indexPath.row == 0){
            return collectionViewSize
        }

        if (indexPath.row == lessons.count){
            NSLog("\(CGSize(width: collectionViewSize.width/3, height: self.view.height))")
        }

        return CGSize(width: collectionViewSize.width/3, height: self.view.height)

    }

    func gotoLessonItemViewController(lesson: LessonModel, index: Int){
        let lessonItemVC = storyboard?.instantiateViewController(withIdentifier: "LessonItemViewController") as! LessonItemViewController
        lessonItemVC.lessonId = lesson.lesson_id
        lessonItemVC.lessonViewedCount = lesson.lesson_viewedphasecount
        if lesson.lesson_completed{
            lessonItemVC.lessonViewedCount = 3 * lesson.lesson_viewedphasecount
        }
        lessonItemVC.categoryId = categoryId
        lessonItemVC.lessonOrderInCategory = index
        lessonItemVC.categoryImageName = self.categoryImageName
        lessonItemVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(lessonItemVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         //collectionItemMoves(toLeft: scrollView.contentOffset.x > 0)
    }

    @IBAction func showLessonsButtonTapped(_ sender: Any) {
        collectionItemMoves(toLeft: lessonsCollectionView.contentOffset.x > 0)
    }

    func collectionItemMoves(toLeft: Bool)
    {
        if toLeft{
            lessonsCollectionView.contentOffset = CGPoint(x: 0, y: 0)
        }
        else{
            lessonsCollectionView.contentOffset = CGPoint(x: collectionViewSize.width - 30, y: 0)
        }
    }

}
