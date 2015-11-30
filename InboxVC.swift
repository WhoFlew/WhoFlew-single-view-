//
//  InboxVC.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/14/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit
import Foundation
import CoreData

import Parse
import Bolts




class InboxVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let utilities = Utilities()
    var alerts = Alerts()
    
    var generate = GenerateCode()
    
    var genView: GenView!
    
    
    //populates scroll view: timeSlide
    let durationLimits = ["10m", "15m","20m","25m","30m","35m","40m","45m","50m","55m","1h", "2h","3h","4h","5h","6h","7h","8h", "1d", "2d","3d","4d"]
    
    
    
    
    @IBOutlet var inboxTable: UITableView!
    @IBOutlet weak var navItem_Edit: UIBarButtonItem!
    
    //right bar item: button toggles between generate and pair views at the bottom
    var navItem_Generate: UIBarButtonItem!
    var navItem_Cancel: UIBarButtonItem!
    var baseViewIsPair: Bool = true
    



    @IBOutlet weak var baseView: UIView!
    var baseView_Gen: UIView!
    

    

    var tableView: UITableView!
    
    

    
    
    var activityWheel = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    //overlay for when user clears conversation
    var clearedSuccessLabel = UILabel()
    

    
    
    //textField just for appearance at bottom
    //textFieldInput takes text
    @IBOutlet weak var textField: UITextField!
    var kbSize: CGSize = CGSize()
    var kbIsUp: Bool = false
    var shouldAdjustFirstResponder: Bool = true
    
    
    
    
    
    
    
    
    var codeName: String = "PiGone"
    

    var newCodeOptions = ["codeName","options","here"]
    var newCodeSelectedOrCancled: Bool = false

    
    
    //query Connection class to pair with specfic code
    var queryConnection = PFQuery(className: "Connection")
    
    //query Connection class to find all live codes, generate new code
    var queryAllCodes = PFQuery(className: "Connection")
    
    //checks all codes by id
    var queryCheck = PFQuery(className: "Connection")
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //read and save settings: pairAttempts
        self.appDelegate.readSettings()
        
        
        //get user info form data
        self.appDelegate.fetchFromCoreData()
        
        
        
        
        self.inboxTable.delegate = self
        self.inboxTable.dataSource = self
        self.inboxTable.tag = 0
        
        self.textField.delegate = self
        self.textField.autocorrectionType = UITextAutocorrectionType.No

        
        //set values in appDelegate for sizez of
        //navBar and status bar
        if let navController: UINavigationController = self.navigationController {
            
            self.appDelegate.navBarSize = navController.navigationBar.frame.size
            self.appDelegate.statusBarSize = UIApplication.sharedApplication().statusBarFrame.standardized.size
        }
        
        

        
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

        
        
        
        //tableFrame = pickerFrame (except for y value)
        let tableFrame = CGRect(x: 0.0, y: self.view.frame.height, width: UIScreen.mainScreen().bounds.width, height: (44.0 * 3))
        
        //new codes in tableView
        self.tableView = UITableView(frame: tableFrame)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tag = 1

        
        self.tableView.backgroundColor = self.appDelegate.allColorsArray[1]

        
        
        
        
        self.genView = GenView(frame: UIScreen.mainScreen().bounds)

        
        
        //self.textField, self.button_Gen, self.collectionView, self.genView.label_Time, self.baseView_Gen, self.genView.button_OtherTimes
        self.genView.setBaseViewContent()
        //self.button_Gen: right corner, triggers self.tapForRandom
        //self.textField: in self.baseView
        //self.baseView_Gen: time duration extention
        //self.collectionView: slider view for duration
        
        
        
        //sets up:
        //self.genView.pickerView, self.genView.labelView_PickerTime
        self.genView.setPickerViewContent()
        //genView.pickerView: 3 componenents
        //labelView: 3 labels (days, hours, time)
        //placed above genView.pickerView, aligned with respective component
        
        
        
        
        self.genView.addSubviesToBase()
        
        
        
        self.baseView_Gen = self.genView.baseViewGen

        


        //plus button next to textField
        self.genView.button_Gen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapForRandom:"))

        
        
        //shows genView.pickerView with three time componenents
        self.genView.button_OtherTimes.addTarget(self, action: "showTimePicker", forControlEvents: UIControlEvents.TouchDown)
        
        
        self.genView.button_Shuffle.addTarget(self, action: "generateCode", forControlEvents: UIControlEvents.TouchDown)
        
        
        
        
        //loading wheel
        self.activityWheel.center.x = self.view.center.x
        self.activityWheel.center.y = self.textField.center.y
        
        self.baseView.addSubview(self.activityWheel)
        self.activityWheel.hidden = true

        
        
        //plus button on baseview, random code only
        self.genView.button_Gen.center.y = self.textField.center.y
        self.baseView.addSubview(self.genView.button_Gen)
        




        self.view.addSubview(self.baseView_Gen)
        self.view.addSubview(self.tableView)
        
        
        
        
        self.genView.pickerView.hidden = true
        self.genView.labelView_PickerTime.hidden = true
        self.genView.button_Shuffle.hidden = true
        
        self.tableView.hidden = true
    }


    
    


    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        //keyboard notifactions
        //keyboard shown
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name: UIKeyboardDidShowNotification, object: nil)
        //keyboard down
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        
        
        if self.appDelegate.codesDeleted.count >= 1 {
            let alertController = self.alerts.theseCodesPartedWays(self.appDelegate.codesDeleted)
            
            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                self.appDelegate.codesDeleted.removeAll(keepCapacity: false)
            })
        }
        
        

        

        if self.appDelegate.codeIds.count > 0 {

            self.queryCheck.whereKey("objectId", containedIn: self.appDelegate.codeIds)
        
            self.queryCheck.findObjectsInBackgroundWithBlock { (aliveCodes, errorPoint) -> Void in
                if let error = errorPoint {
                    
                    if error.code == 100 {
                        self.appDelegate.networkSignal = false
                    }
                    else {
                        self.appDelegate.networkSignal = true
                    }
                }
                
                else if let aliveCodes = aliveCodes {
                    self.appDelegate.networkSignal = true
                    
                    if aliveCodes.count != self.appDelegate.codeIds.count {
                        
                        var aliveCodesId = [(String)]()
                        for code in aliveCodes {
                            aliveCodesId.append(code.valueForKey("objectId") as! String)
                        }
                        
                        let set = Set(self.appDelegate.codeIds)
                        let deadIds = set.subtract(aliveCodesId)
                        self.appDelegate.shouldDeleteThese = Array(deadIds)
                    
                        self.appDelegate.fetchFromCoreData()
                        self.inboxTable.reloadData()
                        
                        
                        if self.appDelegate.codesDeleted.count >= 1 {
                            let alertController = self.alerts.theseCodesPartedWays(self.appDelegate.codesDeleted)
                            
                            self.presentViewController(alertController, animated: true, completion: { () -> Void in
                                self.appDelegate.codesDeleted.removeAll(keepCapacity: false)
                            })
                        }
                        
                        
                    }
                }

            }
        }
        
        
        
        

        
        
        
        
        self.inboxTable.reloadData()
    }
    
    
    
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "enterConvo" {
            let nextVC = segue.destinationViewController as! DialogueVC

            
        
            let indexPath = self.inboxTable.indexPathForSelectedRow!
            let range: Range = 0...self.appDelegate.userCodes.count
            if Array(range).contains(indexPath.row) {
                nextVC.codeName = self.appDelegate.userCodes[indexPath.row].valueForKey("codeName") as! String
                nextVC.codeId = self.appDelegate.userCodes[indexPath.row].valueForKey("codeId") as! String
                
                self.inboxTable.deselectRowAtIndexPath(indexPath, animated: false)
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
            
            self.newCodeSelectedOrCancled = true
            
            self.queryConnection.cancel()
            self.queryAllCodes.cancel()
        }
        
        
        
        //their is an inherent difference between these two systems
        //pair with code
        //tag 1: cancel button. stop image, sysmtem icon
        if !self.baseViewIsPair || sender.tag == 1 {
            self.resetViewsTo("PairView", duration: 1.0)
        }
            
            
        //inbox limit
        else if self.appDelegate.userCodes.count >= 10 {
            self.presentViewController(self.alerts.alertsByType("inboxLimit"), animated: true, completion: nil)
        }
            
        
        //generate new code
        else {
            self.resetViewsTo("GenerateBase", duration: 0.67)
            self.resetViewsTo("TimeExtension", duration: 0.67)
        }
    }
    
    
    

 
    
    
    
    

    
    
    
    func tapForRandom(recognizer: UITapGestureRecognizer) {
        
        if !self.baseViewIsPair &&
            !self.textField.hasText() &&
                !self.textField.isFirstResponder() {
                    
                    self.newCodeOptions = ["","...loading...",""]
                    self.tableView.reloadData()
                    
                    
                    self.shouldAdjustFirstResponder = false
                    self.resetViewsTo("NewCode", duration: 1.2)
                

        }
        
        
        
    }
    
    
    
    

    
    func pairWithCode(codeName: String) {
        
        self.appDelegate.datesOfPairAttempts.append(NSDate())
        self.appDelegate.saveSettings()
        
        
        self.activityWheel.startAnimating()
        self.activityWheel.hidden = false
        
        
        self.textField.hidden = true
        self.genView.button_Gen.hidden = true
        
        
        self.shouldAdjustFirstResponder = true
        if self.textField.isFirstResponder() {
            self.textField.resignFirstResponder()
        }
        
        


        self.queryConnection.whereKey("code", equalTo: codeName)
        self.queryConnection.whereKey("locked", equalTo: false)
        self.queryConnection.whereKey("createdAt", lessThan: NSDate().dateByAddingTimeInterval(self.utilities.fourDaysInSeconds))
        self.queryConnection.whereKey("endAt", greaterThan: NSDate())
        
        var errorPoint: NSError?
        var codeObject: [AnyObject]?
        do {
            codeObject = try self.queryConnection.findObjects()
        } catch let error as NSError {
            errorPoint = error
            codeObject = nil
        }
        if let error = errorPoint {
            
            //error.code 100 means no internet
            if error.code == 100 {
                self.appDelegate.networkSignal = false
            }
            //object could not be found
            //else if error.code == 101 {}
            
            else {
                self.appDelegate.networkSignal = true
            }
            
        }
        else if let code = codeObject {
            
            if code.count == 1 {
                let pairCode = code.first as! PFObject
                
                //get the information for that code: date, objectId, users paired
                let codeId = (pairCode.objectId as String?)!
                
                
                let size: Int = pairCode.valueForKey("size") as! Int
                let endAt: NSDate = pairCode.valueForKey("endAt") as! NSDate
                var pairs: [(String)] = pairCode.valueForKey("pairs") as! [(String)]
                
                
                
                if size > pairs.count {
                    
                    let pairsBeforeAppend = pairs
                    //add this user to pairs, set value as new object
                    pairs.append(self.appDelegate.userName)
                    pairCode.setValue(pairs, forKey: "pairs")
                    
                    if pairs.count == size {
                        pairCode.setValue(true, forKey: "locked")
                    }
                    
                    
                    pairCode.saveInBackgroundWithBlock({ (success, error: NSError?) -> Void in
                        
                        if let error = error {
                            if error.code == 100 {
                                self.appDelegate.networkSignal = false
                            }
                            else {
                                self.appDelegate.networkSignal = true
                            }
                        }
                        //saved to parse
                        else if success {
                            self.appDelegate.networkSignal = true
                            
                            
                            //save details to core data
                            let context: NSManagedObjectContext = self.appDelegate.managedObjectContext!
                            let newConnection = NSEntityDescription.insertNewObjectForEntityForName("Connections", inManagedObjectContext: context) 
                            
                            newConnection.setValue(codeName, forKey: "codeName")
                            newConnection.setValue(codeId, forKey: "codeId")
                            newConnection.setValue(endAt, forKey: "endAt")
                            newConnection.setValue(pairs.count, forKey: "userOrder")
                            
                            newConnection.setValue(false, forKey: "shouldDelete")
                            newConnection.setValue(NSDate(), forKey: "lastRead")
                            
                            var errorPoint: NSError?
                            do {
                                try context.save()
                            } catch let error as NSError {
                                errorPoint = error
                            } catch {
                                fatalError()
                            }
                            if let error = errorPoint {
                                if error.code == 100 {
                                    //no internet
                                }
                            }
                            else {
                                //present pair alert
                                self.presentViewController(self.alerts.alertsByType("pairSucess"), animated: true, completion: { () -> Void in
                                    
                                    self.resetViewsTo("PairView", duration: 1.0)
                                    self.appDelegate.fetchFromCoreData()
                                    self.inboxTable.reloadData()
                                })
                                
                                
                                //send push that says a new user joined
                                let uQuery: PFQuery = PFUser.query()!
                                uQuery.whereKey("username", containedIn: pairsBeforeAppend)
                                
                                let pushQuery: PFQuery = PFUser.query()!
                                pushQuery.whereKey("user", matchesQuery: uQuery)
                                
                                let push: PFPush = PFPush()
                                push.setQuery(pushQuery)
                                
                                push.setMessage("A new user has paired to codeName: \(self.codeName)")
                                
                                push.sendPushInBackgroundWithBlock({ (sucess, errorPush: NSError?) -> Void in
                                    
                                    if let error = errorPush {
                                        
                                        if error.code == 100 {
                                            //internet signal lost
                                        }
                                    }
                                    else if sucess {
                                    }
                                    
                                })
                                
                            }
                            
                        }
                    })

                }
            }
                
                

        }
        else {
        }
        

       
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func generateCode() {
        self.newCodeSelectedOrCancled = true
        
        
        let codeName: String = self.textField.text!
        self.textField.text = ""
    
        
        var allCodeNames = [(String)]()

        self.queryAllCodes.whereKey("locked", equalTo: false)
        self.queryAllCodes.whereKey("createdAt", lessThan: NSDate().dateByAddingTimeInterval(self.utilities.fourDaysInSeconds))
        self.queryAllCodes.whereKey("endAt", greaterThan: NSDate().dateByAddingTimeInterval(5.0 * 60))
        
        self.queryAllCodes.limit = 1000
        self.queryAllCodes.selectKeys(["codeName"])
        
        var errorPoint: NSError?
        var allCodes: [AnyObject]?
        do {
            allCodes = try queryAllCodes.findObjects()
        } catch let error as NSError {
            errorPoint = error
        }
        if let error = errorPoint {
            
            //network off line
            if error.code == 100 {
                self.appDelegate.networkSignal = false
                
                self.genView.label_Time.text = "error"
                self.newCodeOptions = ["⚠️","check network signal","🙈"]
                self.tableView.reloadData()
            
            } else {
                self.appDelegate.networkSignal = true
            }
            
        }

        else if let allCodes = allCodes {
            self.appDelegate.networkSignal = true
            
            for code in allCodes {
                if let codeName = code.valueForKey("codeName") as? String {
                    allCodeNames.append(codeName)
                }
            }
            self.generate.allCodes = allCodeNames

            if codeName.isEmpty {
                
                self.newCodeOptions = self.generate.generateCodeName()
                self.tableView.reloadData()
                self.tableView.allowsSelection = true
           
            } else {
                self.newCodeOptions = self.generate.createCode(codeName, infiniteConnection: false)
                self.tableView.reloadData()
                self.tableView.allowsSelection = true
            }
            
            
            
            self.utilities.delay(18.0, closure: { () -> () in
                
                if !self.newCodeSelectedOrCancled {
                    self.resetViewsTo("PairView", duration: 1.2)
                }
                
                
            })
            
        }
        
        
        
        


        
        

        


   
    }
    
    
    
    
    func saveNewCode(codeName: String) {
        
        
        let codeTable = PFObject(className: "Connection")
        
        codeTable.setValue(codeName, forKey: "code")
        codeTable.setValue(NSDate().dateByAddingTimeInterval(self.genView.duration * 60.0), forKey: "endAt")
        codeTable.setValue([self.appDelegate.userName], forKey: "pairs")
        codeTable.setValue(2, forKey: "size")
        codeTable.setValue(false, forKey: "locked")
        
        
        //codeTable.setValue(codeName, forKey: "code")
        //codeTable.setValue(codeName, forKey: "code")
        //codeTable.setValue(codeName, forKey: "code")
        
        
        //codeTable["dialogue"] = [""]
        //codeTable["order"] = [0]
        //codeTable["deleteInterval"] = self.intervalDelete
        
        

        codeTable.saveInBackgroundWithBlock({ (success, errorPoint) -> Void in
            
            if let error = errorPoint {
                if error.code == 100 {
                    self.appDelegate.networkSignal = false
                }
                else {
                    self.appDelegate.networkSignal = true
                }
            }
                
            else if success {
                self.appDelegate.networkSignal = true
                
                let context: NSManagedObjectContext = self.appDelegate.managedObjectContext!
                let newConnection = NSEntityDescription.insertNewObjectForEntityForName("Connections", inManagedObjectContext: context) 
                
                newConnection.setValue(codeName, forKey: "codeName")
                newConnection.setValue(codeTable.objectId, forKey: "codeId")
                newConnection.setValue(NSDate().dateByAddingTimeInterval(self.genView.duration * 60.0), forKey: "endAt")
                newConnection.setValue(1, forKey: "userOrder")
                
                newConnection.setValue(false, forKey: "shouldDelete")
                newConnection.setValue(NSDate(), forKey: "lastRead")
                
                var errorPoint: NSError?
                do {
                    try context.save()
                } catch let error as NSError {
                    errorPoint = error
                } catch {
                    fatalError()
                }
                if let error = errorPoint {
                    if error.code == 100 {
                        
                    }
                }
                else {
                    self.appDelegate.fetchFromCoreData()
                    self.inboxTable.reloadData()
                    
                    self.resetViewsTo("PairView", duration: 1.2)
                    
                    
                    //determines which cell is the new code
                    //acts as a highlight that fades to white
                    var index: Int = 0
                    for code in self.appDelegate.userCodes {
                        let codeName = code.valueForKey("codeName") as! String
                        
                        
                        if self.newCodeOptions.contains(codeName) {
                            let indexPath = NSIndexPath(forRow: index, inSection: 0)
                            
                            let cell = self.inboxTable.cellForRowAtIndexPath(indexPath)
                            cell!.backgroundColor = self.appDelegate.allColorsArray[1]
                            
                            
                            UITableViewCell.animateWithDuration(3.5, animations: { () -> Void in
                                cell!.backgroundColor = self.appDelegate.allColorsArray[0]
                            })
                            
                        }
                        index++
                    }
                    
                    
                }
                
                
            }

            
        })
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    func resetViewsTo(displayThis: String, duration: Double) {
        
        if displayThis == "PairView" {
            self.baseViewIsPair = true
            print("PairView")
            
            self.activityWheel.stopAnimating()
            self.activityWheel.hidden = true
            
            
            self.genView.pickerView.hidden = true
            self.genView.labelView_PickerTime.hidden = true
            
            self.genView.button_Shuffle.hidden = true
            
            
            self.genView.button_OtherTimes.selected = false
            

            self.textField.placeholder = "Pair Code"
            self.textField.hidden = false

            
            self.genView.button_Gen.hidden = false
            
            self.genView.label_Time.hidden = true
            
            
            
            self.navigationItem.setRightBarButtonItem(self.navItem_Generate, animated: false)
            
            
            
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                
                
                //offsets the y Origin of the view so it is underneath nav bar
                let offSetY: CGFloat = self.view.frame.height
                self.baseView_Gen.frame = CGRect(x: 0.0, y: offSetY, width: UIScreen.mainScreen().bounds.width, height: 180 + self.view.frame.height)
                
                
                
                let textFieldWidth: CGFloat = (self.view.frame.width - 16.0)
                self.textField.frame = CGRect(x: 8.0, y: 9.0, width: textFieldWidth, height: self.textField.frame.height)
                

                
                //tableFrame = pickerFrame (except for y value)
                let tableFrameOriginal = CGRect(x: -(44.0 * 6), y: self.tableView.frame.origin.y + 60, width: 40, height: (44.0 * 3))
                self.tableView.frame = tableFrameOriginal

                
                
                
                self.baseView_Gen.backgroundColor = self.appDelegate.allColorsArray[1]
                
                self.baseView.backgroundColor = self.appDelegate.allColorsArray[2]

            })
        }
        
        
            
            
            
            
            
        else if displayThis == "GenerateBase" {
            self.baseViewIsPair = false

            
            self.navigationItem.setRightBarButtonItem(self.navItem_Cancel, animated: true)
            
            self.textField.placeholder = "Leave blank for random codeName"
            
            
            
            self.genView.pickerView.hidden = true
            self.genView.labelView_PickerTime.hidden = true
            
            
            self.genView.button_OtherTimes.hidden = false
            self.genView.button_OtherTimes.selected = false
            
            
            self.genView.label_Time.hidden = false

            
            self.genView.button_OtherTimes.hidden = false
            
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                

                //90.0: baseView_Gen:: height of this view
                let yOffSet: CGFloat = self.view.frame.height - self.baseView.frame.height - 90 - 1
                self.baseView_Gen.frame = CGRect(x: 0.0, y: yOffSet, width: UIScreen.mainScreen().bounds.width, height: 90)
                
                

                
                //indicates time from scrollView
                let labelFrame = CGRect(x: 32.0, y: 0.0, width: UIScreen.mainScreen().bounds.width - 64, height: 90)
                self.genView.label_Time.frame = labelFrame
                
                
                let stringExpiration: String = self.utilities.durationToString(NSDate().dateByAddingTimeInterval(self.genView.duration * 60.0))
                self.genView.label_Time.text = "self destruct after\n\(stringExpiration)"

                self.genView.label_Time.layer.borderWidth = 0
                
                self.genView.label_Time.backgroundColor =  self.appDelegate.allColorsArray[1]
                
                
                self.textField.frame = CGRect(x: self.textField.frame.origin.x, y: self.textField.frame.origin.y, width: UIScreen.mainScreen().bounds.width - 16, height: self.textField.frame.height)
                
                
                
                
                
                self.baseView.backgroundColor = self.appDelegate.allColorsArray[1]
            
                self.baseView_Gen.backgroundColor = self.appDelegate.allColorsArray[1]
                
                
                }, completion: { (completed) -> Void in
                    

            })
        }
        
            
            
            
            
            
            
            
            
            
        else if displayThis == "TimeExtension" {
            self.genView.button_OtherTimes.selected = true
            self.genView.button_OtherTimes.hidden = false
            
            self.genView.label_Time.text = "self destruct after"

            UIView.animateWithDuration(duration, animations: { () -> Void in
                
                
                let textFieldWidth: CGFloat = (UIScreen.mainScreen().bounds.width - 16.0)
                self.textField.frame = CGRect(x: 8.0, y: 9.0, width: textFieldWidth - 36, height: self.textField.frame.height)
                
                
                }, completion: { (success) -> Void in
                    
                    
            })
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                
                let newHeight: CGFloat = self.genView.pickerView.frame.height + 30
                let yPosition: CGFloat = UIScreen.mainScreen().bounds.height - newHeight - self.baseView.frame.height
                self.baseView_Gen.frame = CGRect(x: 0.0, y: yPosition - 3, width: UIScreen.mainScreen().bounds.width, height: newHeight)
       
                
                
                
                //indicates time from scrollView
                let labelFrame = CGRect(x: -20, y: 10.0, width: UIScreen.mainScreen().bounds.width - 24, height: 62)
                self.genView.label_Time.frame = labelFrame

       
                
                }, completion: { (completed) -> Void in
                    
                    if completed {
                        self.genView.labelView_PickerTime.hidden = false
                        self.genView.pickerView.hidden = false
                        
                        self.genView.label_Time.backgroundColor = UIColor.whiteColor()
                    }
            })
        }

            
            
            
            
            
            
        
        else if displayThis == "NewCode" {
            print("NewCode")
            self.tableView.allowsSelection = false
            self.newCodeSelectedOrCancled = false
            
            self.genView.button_OtherTimes.selected = true
            self.genView.button_OtherTimes.hidden = true
            
            self.tableView.hidden = false
            
            
            self.genView.button_Shuffle.hidden = false
            
            self.genView.label_Time.hidden = false

            
            self.genView.pickerView.hidden = true
            self.genView.labelView_PickerTime.hidden = true
            
            
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                
                
                let sharedHeight: CGFloat = 30 + (self.baseView.frame.height  / 2) + (40.0 / 2)
                print(self.kbSize.height)
                
                //45.0: newFrameButtonShuffle.height
                let newHeightBaseGen: CGFloat = self.baseView_Gen.frame.height + self.baseView.frame.height + 35
                let newYOriginBaseGen: CGFloat = UIScreen.mainScreen().bounds.height - newHeightBaseGen
                
                self.baseView_Gen.frame = CGRect(x: 0.0, y: newYOriginBaseGen, width: UIScreen.mainScreen().bounds.width, height: newHeightBaseGen)
                
                
                
                //indicates time from scrollView
                let newLabelFrame = CGRect(x: 32.0, y: 15, width: UIScreen.mainScreen().bounds.width - 64.0, height: sharedHeight)
                self.genView.label_Time.frame = newLabelFrame
                self.genView.label_Time.text = "select codeName"
                
                self.genView.label_Time.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.33)
                
                self.genView.label_Time.layer.borderWidth = 6
                self.genView.label_Time.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.67).CGColor
            
                
                
                let newFrameButtonShuffle = CGRect(x: 32.0, y: newHeightBaseGen - sharedHeight - 15, width: UIScreen.mainScreen().bounds.width - 64.0, height: sharedHeight)
                self.genView.button_Shuffle.frame = newFrameButtonShuffle
                
                self.genView.button_Shuffle.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.33)
                
                self.genView.button_Shuffle.layer.borderWidth = 6
                self.genView.button_Shuffle.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.67).CGColor
                
                
                
                
                let newFrameTableView = CGRect(x: 32.0, y: newYOriginBaseGen + newLabelFrame.height, width: UIScreen.mainScreen().bounds.width - 64, height: self.tableView.bounds.height)
                self.tableView.frame = newFrameTableView

                
                
                
                }, completion: { (completed) -> Void in
                    
                    if completed {
                        self.generateCode()
                        
                    }
            })
        }

    }
    
    
    
    
    
    
    
    
    
    func showTimePicker() {
        
        if self.genView.button_OtherTimes.selected {
            self.resetViewsTo("GenerateBase", duration: 0.67)
        }
        else {
            let day = floor(self.genView.duration / (24 * 60))
            let hour = floor((self.genView.duration % (24 * 60)) / 60)
            let minute = floor((self.genView.duration % (24 * 60)) % 60)
            
            self.genView.pickerView.selectRow(Int(day), inComponent: 0, animated: false)
            self.genView.pickerView.selectRow(Int(hour), inComponent: 1, animated: false)
            self.genView.pickerView.selectRow(Int(minute), inComponent: 2, animated: false)
            
            
            
            self.resetViewsTo("TimeExtension", duration: 1.0)
        }
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    func keyBoardShow(notification: NSNotification) {
        self.kbIsUp = true
        
        var info: Dictionary = notification.userInfo!
        self.kbSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size)!


      
        
        if self.kbIsUp {
            self.genView.button_OtherTimes.hidden = true
            UIView.animateWithDuration(0.10, animations: { () -> Void in
                
                //90.0: baseView_Gen:: height of this view
                //1.0: gap between the two
                let yPosition: CGFloat =  self.baseView.frame.origin.y - self.kbSize.height
                self.baseView.frame = CGRect(x: 0.0, y: yPosition, width: UIScreen.mainScreen().bounds.width, height: self.baseView.frame.height + self.kbSize.height)
                
                if !self.baseViewIsPair {
                    self.baseView_Gen.frame.size.height = 90.0
                    self.baseView_Gen.frame.origin.y =  yPosition - 90 - 1
                    
                }

            })
            

            
        }
        
        
        if !self.baseViewIsPair {
            //lower generate base extension from pickerview to smaller view
            self.resetViewsTo("GenerateBase", duration: 0.0)
            self.genView.button_OtherTimes.hidden = true
        
        }
        
        
        
        self.navigationItem.setRightBarButtonItem(self.navItem_Cancel, animated: true)
    }
    
    
    
    func keyBoardHide(notification: NSNotification) {
        self.kbIsUp = false
        
        //var info: Dictionary = notification.userInfo!
        //var keyboardSize: CGSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size)!
        

        if !self.baseViewIsPair {            
            if self.shouldAdjustFirstResponder {
                UIView.animateWithDuration(0.33, animations: { () -> Void in
                    
                    //90.0: baseView_Gen:: height of this view
                    //1.0: gap between the two
                    let yPosition: CGFloat =  self.view.frame.height - (self.baseView.frame.height + 90 + 1)
                    self.baseView_Gen.frame = CGRect(x: 0.0, y: yPosition, width: UIScreen.mainScreen().bounds.width, height: 90)
                })
            }
            
        }
        else {
            self.textField.placeholder = "Pair Code"
        }

        self.shouldAdjustFirstResponder = true


    }
    
    
    
    
    
    
    
    //return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        

        //resign textField
        if self.textField.isFirstResponder() {
            self.textField.resignFirstResponder()
        }
        
        
        //pair
        if self.baseViewIsPair {
        
            
            if self.appDelegate.codeNames.contains(self.textField.text!) {
                
                self.presentViewController(self.alerts.alertsByType("pairingToTheirCode"), animated: true, completion: nil)
        
            //present alert if invalid
            } else if self.isValidCode(self.textField.text!) {
                
                self.pairWithCode(self.textField.text!)
                self.textField.text = ""
            }

        }
        
            
        //generate
        else {
            
            //present alert if invalid
            if self.isValidCode(self.textField.text!) {
                
                self.newCodeOptions = ["","...loading...",""]
                self.tableView.reloadData()
                
                
                self.shouldAdjustFirstResponder = false
                self.resetViewsTo("NewCode", duration: 1.2)
            }
        }
        
        
        
  

        
        return true
    }
    
    
    
    
    //touched textField
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        
        if self.appDelegate.userCodes.count >= 10 {
            self.presentViewController(self.alerts.alertsByType("inboxLimit"), animated: true, completion: nil)
            return false
        }
        
        
        //pair view
        if self.baseViewIsPair {
            self.textField.placeholder = "Enter Connection Code"
            
            //limit pairing attempts to 24 per day
            if self.appDelegate.numPairAttemptsInLast24 >= 10 {
                self.presentViewController(self.alerts.alertsByType("pairingLimitExceeded"), animated: true, completion: nil)
                return false
            }
        
        
        } else  {
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
        
        if tableView.tag == 0 {
            return self.appDelegate.userCodes.count
        }
        else {
            return 3
        }
        
    }
    
    

    
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            if let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForInbox") {
                
                let endAt = self.appDelegate.userCodes[indexPath.row].valueForKey("endAt") as? NSDate
                var dateAsString: String = "unknown"
                dateAsString = self.utilities.durationToString(endAt!)
                

                cell.backgroundColor = UIColor.whiteColor()
                
                cell.textLabel!.text = self.appDelegate.userCodes[indexPath.row].valueForKey("codeName") as? String
                cell.textLabel!.backgroundColor = UIColor.clearColor()
                
                cell.detailTextLabel!.text = dateAsString
                cell.detailTextLabel!.backgroundColor = UIColor.clearColor()
                return cell
            }
                
            else {
                return UITableViewCell()
            }
        }
        
        else {
            let cell = UITableViewCell()
            cell.textLabel!.text = self.newCodeOptions[indexPath.row]
            cell.textLabel!.textAlignment = NSTextAlignment.Center
            return cell
        }

        
    }
    


    

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.tag == 0 {

            if !self.textField.isFirstResponder() {
                self.performSegueWithIdentifier("enterConvo", sender: self)
            }
            else {
                self.inboxTable.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
            
        
        else {
            self.codeName = self.newCodeOptions[indexPath.row]
            
            self.saveNewCode(self.codeName)
            

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
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        let clearRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "clear", handler: { action, indexpath in
            
            
            if indexPath.row < self.appDelegate.userCodes.count {
                self.clearedSuccessLabel.tag = 8
                self.clearedSuccessLabel.frame = tableView.cellForRowAtIndexPath(indexPath)!.frame
                self.clearedSuccessLabel.frame.origin.y += (self.appDelegate.navBarSize.height + self.appDelegate.statusBarSize.height)
                
                self.clearedSuccessLabel.backgroundColor = self.appDelegate.allColorsArray[1].colorWithAlphaComponent(0.87)
                
                self.clearedSuccessLabel.text = "clearing servers..."
                self.clearedSuccessLabel.textAlignment = NSTextAlignment.Center
                self.clearedSuccessLabel.textColor = UIColor.whiteColor()
                
                self.view.addSubview(self.clearedSuccessLabel)
                
                let clearId: String = self.appDelegate.userCodes[indexPath.row].valueForKey("codeId") as! String
                self.clearServer_Messages([clearId])
            }

            tableView.editing = false
        })
        clearRowAction.backgroundColor = self.appDelegate.allColorsArray[1]
        
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "delete", handler: { action, indexpath in
            
            if indexPath.row < self.appDelegate.userCodes.count {
                
                let deleteId: String = self.appDelegate.userCodes[indexPath.row].valueForKey("codeId") as! String
                
                self.deleteFromServer(deleteId)
                
                self.appDelegate.shouldDeleteThese.append(deleteId)
                self.appDelegate.fetchFromCoreData()
                
                
                self.inboxTable.reloadData()

            }

            tableView.editing = false

        })
        
        
        let unknownAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "...", handler:{ action, indexpath in
            tableView.editing = false
        })
        unknownAction.backgroundColor = UIColor.whiteColor()
        
        
        
        if tableView.tag == 1 {
            return []
        }

        return [deleteRowAction, clearRowAction]
    }
    

    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    

    
    func deleteFromServer(deleteId: String) {
        
        let codeObject = PFObject(withoutDataWithClassName: "Connection", objectId: deleteId)

        do {
            try PFObject.deleteAll([codeObject])
        } catch let error as NSError {
            if error.code == 100 {
                //no internet signal
            }
        }
        
        self.clearServer_Messages([deleteId])
    }

    
    
    func clearServer_Messages(codeIdArray: [(String)]) {
        
        //clear the messages associated with this conversation
        //first have to query to find them
        let deleteQuery = PFQuery(className: "Messages")
        deleteQuery.whereKey("codeId", containedIn: codeIdArray)
        deleteQuery.findObjectsInBackgroundWithBlock({ (deleteMessages, errorClear) -> Void in
            if let error = errorClear {
                
                if error.code == 100 {
                    self.appDelegate.networkSignal = false
                }
                else {
                    self.appDelegate.networkSignal = true
                }
                
                
            }
            else if let deleteMessages = deleteMessages {
                self.appDelegate.networkSignal = true
                
                var errorDelete: NSError?
                var deleted: Bool
                do {
                    try PFObject.deleteAll(deleteMessages)
                    deleted = true
                } catch let error as NSError {
                    errorDelete = error
                    deleted = false
                } catch {
                    fatalError()
                }
                if let error = errorDelete {
                    
                    self.clearedSuccessLabel.text = "failed"
                    self.clearedSuccessLabel.backgroundColor = self.appDelegate.allColorsArray[2]
                    
                    if error.code == 100 {
                        self.appDelegate.networkSignal = false
                    }
                    else if error.code == 101 {
                        //object not found
                    }
                    
                    
                    
                    
                }
                else if deleted {
                    self.appDelegate.networkSignal = true
                    
                    self.clearedSuccessLabel.text = "success!"
                    
                }
                    
                else {
                    self.clearedSuccessLabel.text = "failed"
                    self.clearedSuccessLabel.backgroundColor = self.appDelegate.allColorsArray[2]
                }
                
                
                self.utilities.delay(1.7, closure: { () -> () in
                    self.clearedSuccessLabel.removeFromSuperview()
                })
            }
     

            
        })
        
    }
    
    
    

    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    

        
        
        
        self.queryCheck.cancel()
        self.queryConnection.cancel()
        self.queryAllCodes.cancel()
        
        self.resetViewsTo("PairView", duration: 0.0)
    }
    
    
    
    
    
    
    
    

    
    
    
    
    
    func isValidCode(input: String) -> Bool {
        
        
        
        //if they have no internet connection
        //if !self.appDelegate.networkSignal {
            //self.presentViewController(self.alerts.alertsByType("network"), animated: true, completion: nil)
            //return true
            //checkHere
            //no way to re evaluate stronger signal once assigned as false
        //}
            
            
            
        if !input.isEmpty {
            
                //code input must be at least 4
            if input.characters.count < 4  {
                self.presentViewController(self.alerts.alertsByType("short"), animated: true, completion: nil)
                return false
            
                
                
                //code input cannot be greater than 17
            } else if input.characters.count > 17 {
                self.presentViewController(self.alerts.alertsByType("long"), animated: true, completion: nil)
                return false
            
                
                
                //returns false if invalid punctuation used (also rejects too many spaces)
            } else if self.utilities.invalidPunc(input) {
                self.presentViewController(self.alerts.alertsByType("punc"), animated: true, completion: nil)
                return false
            

                //valid codes with text in textField will fall to this clause
            } else {
                return true
            }
            
        }
            
            
            
            
            
            
            
            //pair input cannot be blank
        else if self.baseViewIsPair {
            self.presentViewController(self.alerts.alertsByType("enterCodeToPair"), animated: true, completion: nil)
            return false
        }
            
            
            //generated codes without text in textField will be random (ie: purple monkey)
        else {
            return true
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