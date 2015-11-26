//
//  InboxVC.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/14/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit





class InboxVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let utilities = Utilities()
    
    
    
    //populates scroll view: timeSlide
    let durationLimits = ["10m", "15m","20m","25m","30m","35m","40m","45m","50m","55m","1h", "2h","3h","4h","5h","6h","7h","8h", "1d", "2d","3d","4d"]
    
    
    
    
    @IBOutlet var inboxTable: UITableView!
    @IBOutlet weak var navItem_Edit: UIBarButtonItem!
    
    //right bar item: button toggles between generate and pair views at the bottom
    var navItem_Generate: UIBarButtonItem!
    var navItem_Cancel: UIBarButtonItem!
    var baseViewIsPair: Bool = true
    
    
    
    var add: UIBarButtonItem!
    

    @IBOutlet weak var baseView: UIView!
    var baseView_Gen: UIView!
    
    
    //time expiration time limit
    lazy var collectionView: UICollectionView = self.setCollectionView()
    var label_Time: UILabel!

    
    //@IBOutlet weak var button_Go: UIButton!
    
    
    //textField just for appearance at bottom
    //textFieldInput takes text
    @IBOutlet weak var textField: UITextField!
    var kbSize: CGSize = CGSize()
    var kbIsUp: Bool = false

    
    
    var activityWheel = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    
    //time limit for code, in minutes
    var duration: Double = 20.0
    
    

    
    //set layout and frame for collection view
    //used for time slide
    func setCollectionView() -> UICollectionView {
        

        var frame = CGRect(x: 0.0, y: 59.0, width: (self.view.frame.size.width), height: 30)
    
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: -(self.view.frame.width % 75.0), bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 75.0, height: 30)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 0.0
        
        var collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.contentSize = CGSize(width: (self.durationLimits.count * 100), height: 30)
        return collectionView
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        //set values in appDelegate for sizez of 
        //navBar and status bar
        if let navController: UINavigationController = self.navigationController {
            
            self.appDelegate.navBarSize = navController.navigationBar.frame.size
            self.appDelegate.statusBarSize = UIApplication.sharedApplication().statusBarFrame.standardizedRect.size
        }
        
        

    
        
        self.inboxTable.delegate = self
        self.inboxTable.dataSource = self
        
        
        
        
        
        
        
        //collectionView: timeSlide
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.registerClass(TimeSlideCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        self.collectionView.backgroundColor = self.appDelegate.allColorsArray[2]
        self.collectionView.scrollEnabled = true
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "tapScrollView:")
        self.collectionView.addGestureRecognizer(tapGesture)
        
        
        
        
        

        
        //textField for generate/pair doesnt use auto correct
        self.textField.delegate = self
        self.textField.tag = 0
        self.textField.placeholder = "Pair Code"
        self.textField.autocorrectionType = UITextAutocorrectionType.No
  

        

        
      
        
        
        //button: plus system symbol, changes view at bottom
        //when pressed: from pair -> generate
        self.navItem_Generate = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "toggleRightNavItem:")
        
        
        //button: x system symbol, changes view at bottom
        //when pressed: from anything -> pair, resign first responder and return
        self.navItem_Cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "toggleRightNavItem:")
        
        self.navItem_Generate.tag = 0
        self.navItem_Cancel.tag = 1
 
        //nav bar starts as generate tab
        self.navigationItem.rightBarButtonItem = self.navItem_Generate

    
        

        

        //offsets the y Origin of the view so it is underneath nav bar
        var offSetY: CGFloat = (self.appDelegate.navBarSize.height + self.appDelegate.statusBarSize.height) - (180 + self.view.frame.height)
        self.baseView_Gen = UIView(frame: CGRect(x: 0.0, y: offSetY, width: self.view.frame.width, height: 180 + self.view.frame.height))
        self.baseView_Gen.backgroundColor = self.appDelegate.allColorsArray[1]
        
        
        
        
        
        
        //indicates time from scrollView
        var labelFrame = CGRect(x: 0.0, y: 0, width: self.view.frame.width, height: 60)
        self.label_Time = UILabel(frame: labelFrame)

        self.label_Time.text = "set expiration"
        self.label_Time.numberOfLines = 2
        self.label_Time.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.label_Time.textAlignment = NSTextAlignment.Center
        
        self.label_Time.backgroundColor = self.appDelegate.allColorsArray[1]
        
        
        

        
        
        
        //loading wheel
        self.baseView.addSubview(self.activityWheel)
        self.activityWheel.hidden = true
        

        
        //label that indicates time
        self.baseView_Gen.addSubview(self.label_Time)
        
        
        //time slide extension, hides for pair
        self.baseView_Gen.addSubview(self.collectionView)



        
        self.view.addSubview(baseView_Gen)
    }


    
    


    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        //keyboard notifactions
        //keyboard shown
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name: UIKeyboardDidShowNotification, object: nil)
        //keyboard down
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardHide:", name: UIKeyboardDidHideNotification, object: nil)
        

    }
    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "enterConvo" {
            let nextVC = segue.destinationViewController as! DialogueVC
            let sender = sender as! InboxVC
            
            
            var index: Int = 0
            
            var range: Range = 0...self.appDelegate.arrayOfCodeNames.count
            if contains(Array(range), index) {
                nextVC.codeName = self.appDelegate.arrayOfCodeNames[index]
            }
        }
    }
    
    
    
    
    
    

    
    //changes baseView
    //generate and pair views
    func toggleRightNavItem(sender: AnyObject) {
        //tag 0: generate button. plus image, system icon
        //tag 1: cancel button. stop image, sysmtem icon
        
        
        if self.textField.isFirstResponder() {
            self.textField.resignFirstResponder()
        }
        
        
        //tag 1: cancel button. stop image, sysmtem icon
        if sender.tag == 1 {
            self.textField.text = ""
        }
        
        
        
        //their is an inherent difference between these two systems
        //pair with code
        //tag 1: cancel button. stop image, sysmtem icon
        if !self.baseViewIsPair || sender.tag == 1 {
            self.baseViewIsPair = true
            
            self.navigationItem.setRightBarButtonItem(self.navItem_Generate, animated: false)
            
            
            self.textField.placeholder = "Pair Code"
            
            
            
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                //offsets the y Origin of the view so it is underneath nav bar
                let offSetY: CGFloat = (self.appDelegate.navBarSize.height + self.appDelegate.statusBarSize.height) - (180 + self.view.frame.height)
                self.baseView_Gen.frame = CGRect(x: 0.0, y: offSetY, width: self.view.frame.width, height: 180 + self.view.frame.height)
                
                
                let textFieldWidth: CGFloat = (self.view.frame.width - 16.0)
                self.textField.frame = CGRect(x: 8.0, y: 9.0, width: textFieldWidth, height: self.textField.frame.height)
                
                self.baseView_Gen.backgroundColor = self.appDelegate.allColorsArray[1]
                
                self.baseView.backgroundColor = self.appDelegate.allColorsArray[2]
                
                
                
                self.label_Time.hidden = true
                self.collectionView.hidden = true
            })
            
            
        }
            
            
            
            //generate new code
        else {
            self.baseViewIsPair = false
            
            self.navigationItem.setRightBarButtonItem(self.navItem_Cancel, animated: true)
            
            self.textField.placeholder = "Leave blank for random codeName"
            
 

            
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                
                self.baseView.backgroundColor = self.appDelegate.allColorsArray[1]

                
                //90.0: baseView_Gen:: height of this view
                let yOffSet: CGFloat = self.view.frame.size.height - self.baseView.frame.height - 90 - 1
                self.baseView_Gen.frame = CGRect(x: 0.0, y: yOffSet, width: self.view.frame.width, height: 90)
                
                self.baseView_Gen.backgroundColor = self.appDelegate.allColorsArray[1]
                
                
                let textFieldWidth: CGFloat = (self.view.frame.width - 16.0)
                self.textField.frame = CGRect(x: 8.0, y: 9.0, width: textFieldWidth - 48, height: self.textField.frame.height)
                
                self.label_Time.hidden = false
                self.collectionView.hidden = false
            })
            
            
        }
    }
    
    
    
    
    
    
    
    func isValidCode(input: String) -> Bool {
       

        
        //if they have no internet connection
        if !self.appDelegate.networkSignal {
            self.presentViewController(self.alertsByType("network"), animated: true, completion: nil)
            return false
        }
        
            
            
        else if self.textField.hasText() {
            
            //code input must be at least 4
            if count(input) < 4  {
                self.presentViewController(self.alertsByType("short"), animated: true, completion: nil)
                return false
            }
        
                
            //code input cannot be greater than 17
            else if count(input) > 17 {
                self.presentViewController(self.alertsByType("long"), animated: true, completion: nil)
                return false
            }
                
              
            //returns false if invalid punctuation used (also rejects too many spaces)
            else if self.utilities.invalidPunc(input) {
                self.presentViewController(self.alertsByType("punc"), animated: true, completion: nil)
                return false
            }

                
            //valid codes with text in textField will fall to this clause
            else {
                return true
            }
            
        }
           
            
            
  

            

        //pair input cannot be blank
        else if self.baseViewIsPair {
            self.presentViewController(self.alertsByType("enterCodeToPair"), animated: true, completion: nil)
            return false
        }
        
            
        //generated codes without text in textField will be random (ie: purple monkey)
        else {
            return true
        }

    }
    
    
    

    
    
    func pressedGo(sender: AnyObject) {
        
        
        if self.isValidCode(self.textField.text) {
            //self.button_Go.hidden = true
            
            self.activityWheel.startAnimating()
            self.activityWheel.hidden = false
            
/*
            
            if self.button_Go.titleLabel!.text == "Pair" {
                self.pairWithCode(self.textField.text)
            }
            else if self.button_Go.titleLabel!.text == "Generate" {
                self.generateCode(self.textField.text)
            }
            
*/
        }
            
        //clear textField text is not valid codeName
        else {
            self.textField.text = ""
        }

    }
    
    
    func pairWithCode(codeName: String) {
        
        
        self.resetBaseView()
    }
    
    func generateCode(codeName: String) {
        

        
        if codeName.isEmpty {
            UIView.animateWithDuration(1.4, animations: { () -> Void in
                
                //90.0: baseView_Gen:: height of this view
                //1.0: gap between the two
                var yPosition: CGFloat = self.view.frame.size.height - self.baseView.frame.height - 270 - 1
                self.baseView_Gen.frame = CGRect(x: 0.0, y: yPosition, width: self.baseView_Gen.frame.width, height: 270)
                
                }, completion: { (completed) -> Void in
                    if self.textField.isFirstResponder() {
                        self.textField.resignFirstResponder()
                    }
            })
 
        }
        
        else {
            
        }
        
        

        
        
         self.resetBaseView()
    }
    
    
    
    
    
    
    
    
    
    
    func resetBaseView() {
        self.activityWheel.stopAnimating()
        self.activityWheel.hidden = true

    }
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    func keyBoardShow(notification: NSNotification) {
        self.kbIsUp = true
        
        var info: Dictionary = notification.userInfo!
        self.kbSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!


      
        
        if self.kbIsUp {
    
            UIView.animateWithDuration(0.10, animations: { () -> Void in
                
                //90.0: baseView_Gen:: height of this view
                //1.0: gap between the two
                var yPosition: CGFloat =  self.baseView.frame.origin.y - self.kbSize.height
                self.baseView.frame = CGRect(x: 0.0, y: yPosition, width: self.baseView.frame.width, height: self.baseView.frame.height + self.kbSize.height)
                
                if !self.baseViewIsPair {
                    self.baseView_Gen.frame.origin.y =  self.baseView_Gen.frame.origin.y - self.kbSize.height
                    
                }

            })
            

            
        }
        
        
        
        self.navigationItem.setRightBarButtonItem(self.navItem_Cancel, animated: true)
    }
    
    
    
    func keyBoardHide(notification: NSNotification) {
        self.kbIsUp = false
        
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        

        if !self.baseViewIsPair {
            //1.0: gap between the two
            
            UIView.animateWithDuration(0.33, animations: { () -> Void in
                
                
                //90.0: baseView_Gen:: height of this view
                //1.0: gap between the two
                var yPosition: CGFloat =  self.view.frame.height - (self.baseView.frame.height + 90 + 1)
                self.baseView_Gen.frame = CGRect(x: 0.0, y: yPosition, width: self.baseView_Gen.frame.width, height: 90)
                
 
                
            })
            
        }
        else {
            self.textField.placeholder = "Pair Code"
        }




    }
    
    
    
    
    
    //textfield for the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if self.textField.isFirstResponder() {
            self.navigationItem.setRightBarButtonItem(self.navItem_Generate, animated: false)
            
            self.textField.resignFirstResponder()
        }
        
        return true
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if self.baseViewIsPair {
            self.textField.placeholder = "Enter Connection Code"
        }

    
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    //editting functions for tableView(self.inboxView)
    //navigation item: toggles between edit/done
    @IBAction func toggleLeftNavItem(sender: AnyObject) {
        
        if self.navItem_Edit.title == "Edit" {
            self.inboxTable.setEditing(true, animated: true)
            self.navItem_Edit.title = "Done"
        }
            
        else {
            self.inboxTable.setEditing(false, animated: true)
            self.navItem_Edit.title = "Edit"
        }
    }
    
    
    
    

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForInbox") as? UITableViewCell {
            
            cell.textLabel!.text = "codeName"
            cell.detailTextLabel!.text = "4 hours"
            return cell
        }
            
        else {
            return UITableViewCell()
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if !self.textField.isFirstResponder() {
            self.performSegueWithIdentifier("enterConvo", sender: self)
        }

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
        }
            
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    
    
    //actions for tableview cells on swipe
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var clearRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "clear", handler:{ action, indexpath in
            
            self.editing = false
        })
        clearRowAction.backgroundColor = self.appDelegate.allColorsArray[1]
        
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "delete", handler:{ action, indexpath in
            
            self.editing = false
        })
        
        
        var unknownAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "...", handler:{ action, indexpath in
            self.editing = false
        })
        unknownAction.backgroundColor = UIColor.whiteColor()
        
        
        
        
        return [deleteRowAction, clearRowAction]
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //collection view used for time slide
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.durationLimits.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! TimeSlideCollectionViewCell
        
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
            var size = CGSize(width: 75, height: 30)
            return size
            
        }
            
        else if indexPath.row < 17 {
            var size = CGSize(width: 150, height: 30)
            return size
        }
            
        else {
            var size = CGSize(width: 300, height: 30)
            return size
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1
    }
    
    

    
    
    
    

    
    
    //if timeSlide view is pressed on left/right extremes,
    //then, scroll the view to first/last time option
    func tapScrollView(recognizer: UITapGestureRecognizer) {
        
        let viewForGesture = recognizer.view!
        let locationOfTouch = recognizer.locationOfTouch(0, inView: self.collectionView)
        
        
        //scroll to time on far left
        if abs(self.collectionView.contentOffset.x - locationOfTouch.x) <= 20 {
            
            let indexPath = NSIndexPath(forItem: 2, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }
            
            //scroll to time on far right
        else if abs(self.collectionView.contentOffset.x - locationOfTouch.x) - self.view.frame.width >= -20 {
            
            let indexPath = NSIndexPath(forItem: self.durationLimits.count - 1, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }
        
    }
    
    
    //change time label as timeSlide adjusts by time
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        //75.0: width of items in sectionOne
        //10: number of items in sectionOne
        //width * numberOfItems(with width)
        var sectionOne: CGFloat = 75.0 * 10
        var unitOne: CGFloat = scrollView.contentOffset.x / 75.0
        var minutes = Int((5 * unitOne) + 20)
        
        
        //150.0: width of items in sectionTwo
        //7: number of items in sectionTwo
        //-75.0: adjusts for text label which has text in center (half of width[150])
        var sectionTwo: CGFloat = 150.0 * 7
        var unitTwo: CGFloat = (scrollView.contentOffset.x - sectionOne - 75.0) / 150.0
        var hours = Int(round(unitTwo)) + 2
        //minutes divided in units of 12 minutes
        var unit12: CGFloat = (scrollView.contentOffset.x - sectionOne) / (150.0 / 5.0)
        var minutesBy12 = (Int(unit12 + 5) % 5) * 12
        
        
        //300.0: width of items in sectionThree
        //3: number of items in sectionThree
        var sectionThree: CGFloat = 300 * 3
        //-150.0: adjusts for text label which has text in center (half of width[300])
        var unitThree: CGFloat = (scrollView.contentOffset.x - sectionOne - sectionTwo - 150.0) / 300.0
        var days = Int(round(unitThree)) + 1
        //minutes divided in units of 12 minutes
        var unit30: CGFloat = (scrollView.contentOffset.x - sectionOne - sectionTwo ) / (300.0 / 24.0)
        var hoursInDay = Int(unit30 % 24.0)
        
        
        
        if minutes <= 7 {
            self.label_Time.text = "PiGone"
        }
        else if minutes <= 59 {
            //set label
            self.label_Time.text = "\(minutes)\nminutes"
            
            //set value for parse
            self.duration = Double(minutes)
        }
        else if hours <= 8 {
            //set label
            self.label_Time.text = "H: \(hours) M: \(minutesBy12)"
            
            //set value for parse
            self.duration = Double((hours * 60) + (minutesBy12))
        }
        else if hoursInDay < 0 || days <= 0 {
            //set label
            self.label_Time.text = "D: \(0) H: \(14 - abs(hoursInDay))"
            
            //set value for parse
            self.duration = Double((days * 24 * 60) + (hoursInDay * 60))
        }
        else if days <= 5 {
            //set label
            self.label_Time.text = "D: \(days) H: \(hoursInDay)"
            
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func alertsByType(alertType: String) -> UIAlertController {
        
        let dismiss = UIAlertAction(title: "✌️", style: UIAlertActionStyle.Cancel, handler: nil)
        
        
        //code must be at least 4 charas
        if alertType == "short" {
            var alert = UIAlertController(title: "☝️too short", message: "4 character minimum", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            
            //code cannot be longer than 17 charas
        else if alertType == "long" {
            var alert = UIAlertController(title: "☝️too long", message: "17 character maximum", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            //when pairing, textfield must have text
        else if alertType == "enterCodeToPair" {
            var alert = UIAlertController(title: "☝️enter code", message: "codeNames are used to connect users", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            //invalid punctuation used
        else if alertType == "punc" {
            var alert = UIAlertController(title: "☝️invalid punctuation", message: "try emoticons", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            //no internet
        else if alertType == "network" {
            var alert = UIAlertController(title: "☝️weak signal", message: "connect to a stronger network signal", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
            
            
            
            
            
            
            
        else {
            var alert = UIAlertController(title: "PiGone", message: "meet our mascot, PiGone the carrier pigeon", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(dismiss)
            
            return alert
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}