//
//  GenView.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/27/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts
import CoreData


class GenView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let utilities = Utilities()
    var inboxVc = InboxVC()
    
    //populates scroll view: timeSlide
    let durationLimits = ["10m", "15m","20m","25m","30m","35m","40m","45m","50m","55m","1h", "2h","3h","4h","5h","6h","7h","8h", "1d", "2d","3d","4d"]
    
    
    
    var genView: UIView!
    

    var label_Time: UILabel!
    //time expiration time limit
    lazy var collectionView: UICollectionView = self.lazySetCollectionView()

    
    
    var button_Gen: UIView = UIButton(type: UIButtonType.ContactAdd) as UIView
    
    
    
    //pickerview with 3 componenets (hour, day, min)
    var pickerView: UIPickerView!
    //triggers pickerview to replace collectionView and cover textField
    var button_OtherTimes: UIButton!
    
    
    //3 labels inside (hour, day, min)
    var labelView_PickerTime: UIView!
    var labelDays: UILabel!
    var labelHours: UILabel!
    var labelMins: UILabel!
    
    
    
    
    var codeName: String = "PiGone"
    //time limit for code, in minutes
    var duration: Double = 20.0
    
    
    
    
    
    
    
    
    func setPickerViewContent() {
        

        
        let pickerFrame = CGRect(x: -25.0, y: 30.0, width: frame.width, height: 162.0)
        self.pickerView = UIPickerView(frame: pickerFrame)
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
        self.pickerView.selectRow(4, inComponent: 1, animated: false)
        self.pickerView.selectRow(40, inComponent: 2, animated: false)
        
        
        
        //30: width of self.button_OtherTimes
        let pickerLabelHeight: CGFloat = ((self.pickerView.frame.height / 2.0) - (self.pickerView.rowSizeForComponent(0).height / 2.0))
        
        
        let rectDays = CGRect(x: -5.0, y: 0.0, width: frame.width / 3.0, height: pickerLabelHeight)
        let rectHours = CGRect(x: frame.width / 3.0, y: 0.0, width: frame.width / 3.0, height: pickerLabelHeight)
        let rectMins = CGRect(x: 2 * (frame.width / 3.0), y: 0.0, width: frame.width / 3.0, height: pickerLabelHeight)
        
        self.labelDays = UILabel(frame: rectDays)
        self.labelHours = UILabel(frame: rectHours)
        self.labelMins = UILabel(frame: rectMins)
        
        self.labelDays.text = "Days"
        self.labelDays.textAlignment = NSTextAlignment.Center
        
        self.labelHours.text = "Hours"
        self.labelHours.textAlignment = NSTextAlignment.Center
        
        self.labelMins.text = "Mins"
        self.labelMins.textAlignment = NSTextAlignment.Center
        
        
        
        self.labelView_PickerTime = UIView(frame: CGRect(x: 20.0, y: 77.0, width: frame.width, height: pickerLabelHeight))
        self.labelView_PickerTime.backgroundColor = self.appDelegate.allColorsArray[0]
        
        self.labelView_PickerTime.addSubview(self.labelDays)
        self.labelView_PickerTime.addSubview(self.labelHours)
        self.labelView_PickerTime.addSubview(self.labelMins)
    }
    
    
    
    
    func setBaseViewContent() {
        
        
        
        //plus button at the baseview for generate
        self.button_Gen.frame.origin.x = frame.width - 32
        //self.button_Gen.center.y = self.textField.center.y
        self.button_Gen.tintColor = UIColor.whiteColor()
        
              
        
        
        //scrolls to extremes on left/right
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapScrollView:")
        self.collectionView.addGestureRecognizer(tapGesture)
        
        
        
        
        //offsets the y Origin of the view so it is underneath nav bar
        let offSetY: CGFloat = (self.appDelegate.navBarSize.height + self.appDelegate.statusBarSize.height) - (180 + frame.height)
        self.genView = UIView(frame: CGRect(x: 0.0, y: offSetY, width: frame.width, height: 180 + frame.height))
        self.backgroundColor = self.appDelegate.allColorsArray[1]
        
        
        
        
        
        
        
        //indicates time from scrollView
        let labelFrame = CGRect(x: 0.0, y: 0, width: frame.width, height: 60)
        self.label_Time = UILabel(frame: labelFrame)
        
        self.label_Time.text = "set expiration"
        self.label_Time.numberOfLines = 2
        self.label_Time.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.label_Time.textAlignment = NSTextAlignment.Center
        
        self.label_Time.backgroundColor = self.appDelegate.allColorsArray[1]
        
        
        
        
        
        
        
        //button for more time options
        self.button_OtherTimes = UIButton(frame: CGRect(x: frame.width - 30, y: 0.0, width: 30, height: self.label_Time.frame.height / 2))
        

        
        
        //highlighted
        let highlightedAttributedTitle = NSAttributedString(string: "...",
            attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        self.button_OtherTimes.setAttributedTitle(highlightedAttributedTitle, forState: UIControlState.Highlighted)
        
        
        //selected
        let selectedAttributedTitle = NSAttributedString(string: "...",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.button_OtherTimes.setAttributedTitle(selectedAttributedTitle, forState: UIControlState.Selected)
        
        
        //normal
        let normalAttributedTitle = NSAttributedString(string: ":::",
            attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.button_OtherTimes.setAttributedTitle(normalAttributedTitle, forState: UIControlState.Normal)
        
        
        
        

        
        

    }

    
    
    
    //set layout and frame for collection view
    //used for time slide
    func lazySetCollectionView() -> UICollectionView {
        
        
        let collectionFrame = CGRect(x: 0.0, y: 59.0, width: (frame.size.width), height: 30)
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: -(frame.width % 75.0), bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 75.0, height: 30)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 0.0
        
        let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.contentSize = CGSize(width: (self.durationLimits.count * 100), height: 30)
        
        
        //collectionView: timeSlide
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerClass(TimeSlideCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.backgroundColor = self.appDelegate.allColorsArray[2]
        collectionView.scrollEnabled = true
        collectionView.indicatorStyle = UIScrollViewIndicatorStyle.White
        
        
        return collectionView
    }
    
    
    
    
    
    
    
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 31//Days
        }
        else if component == 1 {
            return 24//Hours
        }
        else {
            return 60//Minutes
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(row)"
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let days: Int = pickerView.selectedRowInComponent(0)
        let hours: Int = pickerView.selectedRowInComponent(1)
        let minutes: Int = pickerView.selectedRowInComponent(2)
        
        //minimum is 5 minutes
        if days == 0
            && hours == 0
            && minutes < 5 {
            self.pickerView.selectRow(5, inComponent: 2, animated: true)
        }
        
        if component == 0 {

            if row == 1 {
                self.labelDays.text = "Day"
            }
            else {
                self.labelDays.text = "Days"
            }
        }
            
        else if component == 1 {
            
            if row == 1 {
                self.labelHours.text = "Hour"
            }
            else {
                self.labelHours.text = "Hours"
            }
        }
            
        else {
      
            if row == 1 {
                self.labelMins.text = "Min"
            }
            else {
                self.labelMins.text = "Mins"
            }
        }
        

        self.duration = Double((days * 24 * 60) + (hours * 60) + (minutes))
        print(self.duration)
        
        
    }
    
    
    
    
    
    

    
    
    
    
    
    

    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    //collection view used for time slide
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.durationLimits.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! TimeSlideCollectionViewCell
        
        collectionCell.frame.origin.y = 0
        
        collectionCell.backgroundColor = UIColor.clearColor()
        //tag: used to indicate what row is visibile for changing header
        collectionCell.tag = indexPath.row
        collectionCell.textLabel.text = self.durationLimits[indexPath.row]
        
        
        collectionCell.backgroundColor = UIColor.whiteColor()
        
        
        return collectionCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        
        if indexPath.row < 10 {
            let size = CGSize(width: 75, height: 30)
            return size
            
        }
            
        else if indexPath.row < 17 {
            let size = CGSize(width: 150, height: 30)
            return size
        }
            
        else {
            let size = CGSize(width: 300, height: 30)
            return size
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //change time label as timeSlide adjusts by time
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        //75.0: width of items in sectionOne
        //10: number of items in sectionOne
        //width * numberOfItems(with width)
        let sectionOne: CGFloat = 75.0 * 10
        let unitOne: CGFloat = scrollView.contentOffset.x / 75.0
        let minutes = Int((5 * unitOne) + 20)
        
        
        //150.0: width of items in sectionTwo
        //7: number of items in sectionTwo
        //-75.0: adjusts for text label which has text in center (half of width[150])
        let sectionTwo: CGFloat = 150.0 * 7
        let unitTwo: CGFloat = (scrollView.contentOffset.x - sectionOne - 75.0) / 150.0
        let hours = Int(round(unitTwo)) + 2
        //minutes divided in units of 12 minutes
        let unit12: CGFloat = (scrollView.contentOffset.x - sectionOne) / (150.0 / 5.0)
        let minutesBy12 = (Int(unit12 + 5) % 5) * 12
        
        
        //300.0: width of items in sectionThree
        //3: number of items in sectionThree
        //var sectionThree: CGFloat = 300 * 3
        //-150.0: adjusts for text label which has text in center (half of width[300])
        let unitThree: CGFloat = (scrollView.contentOffset.x - sectionOne - sectionTwo - 150.0) / 300.0
        let days = Int(round(unitThree)) + 1
        //minutes divided in units of 12 minutes
        let unit30: CGFloat = (scrollView.contentOffset.x - sectionOne - sectionTwo ) / (300.0 / 24.0)
        let hoursInDay = Int(unit30 % 24.0)
        
        
        
        if minutes <= 7 {
            self.label_Time.text = "PiGone"
        }
        else if minutes <= 59 {
            //set label
            self.label_Time.text = "\(minutes)\nMinutes"
            
            //set value for parse
            self.duration = Double(minutes)
        }
        else if hours <= 8 {
            //set label
            self.label_Time.text = "\(hours) Hours\n\(minutesBy12) Minutes"
            
            //set value for parse
            self.duration = Double((hours * 60) + (minutesBy12))
        }
        else if hoursInDay < 0 || days <= 0 {
            //set label
            self.label_Time.text = "\(0) Days\n\(14 - abs(hoursInDay)) Hours"
            
            //set value for parse
            self.duration = Double((days * 24 * 60) + (hoursInDay * 60))
        }
        else if days <= 5 {
            //set label
            self.label_Time.text = "\(days) Days\n\(hoursInDay) Hours"
            
            //set value for parse
            self.duration = Double((days * 24 * 60) + (hoursInDay * 60))
        }
        else {
            self.label_Time.text = "PiGone"
        }
        
        
        //checkHere
        //possible addition:
        //move label time origin.x according to how far time has been scrolled
        
    }
    

    
    
    
    

    
    //if timeSlide view is pressed on left/right extremes,
    //then, scroll the view to first/last time option
    func tapScrollView(recognizer: UITapGestureRecognizer) {
        
        //let viewForGesture = recognizer.view!
        let locationOfTouch = recognizer.locationOfTouch(0, inView: self.collectionView)
        
        
        //scroll to time on far left
        if abs(self.collectionView.contentOffset.x - locationOfTouch.x) <= 20 {
            
            let indexPath = NSIndexPath(forItem: 2, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }
            
            //scroll to time on far right
        else if abs(self.collectionView.contentOffset.x - locationOfTouch.x) - frame.width >= -20 {
            
            let indexPath = NSIndexPath(forItem: self.durationLimits.count - 1, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }
        
    }
}