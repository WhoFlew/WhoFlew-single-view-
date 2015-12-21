//
//  DialogueViewController.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/14/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit
import Foundation
import Parse
import Bolts

class DialogueVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let utilities = Utilities()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //contains the content for the send bar at the bottom of view
    @IBOutlet weak var baseView_Send: UIView!
    //textView and sendButton for new messages
    @IBOutlet weak var button_Send: UIButton!
    @IBOutlet weak var textView: UITextView!
    //image fills inbox when empty
    let imageUnderKb = UIImageView(image: UIImage(named: "1080PiGone.png"))
    
    var kbSize: CGSize = CGSize()
    var kbIsUp: Bool = false
    
    //'tap to write' covers the textView 
    //thinBorder seperates the textview from the messages in table
    @IBOutlet weak var label_Cover: UILabel!
    @IBOutlet weak var label_ThinBorder: UILabel!
    

    
    var messageArray = [(String)]()
    var orderArray = [(Int)]()

    
    //order of this user
    var userOrder: Int = 1
    var pairs = [(String)]()
    
    var codeName: String = "PiGone"
    var codeId: String = "PiGone"

    
    var queryConnection = PFQuery(className: "Connection")
    var queryMessages = PFQuery(className: "Messages")
    
    
    var canSendMessage: Bool = false
    //indicator color waits to change color until message sent
    var numMessagesWaiting: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 50.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
    
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        self.tableView.separatorColor = UIColor.whiteColor()
        
        self.button_Send.hidden = true
        self.label_ThinBorder.hidden = true
        

        self.label_Cover.layer.cornerRadius = 12
        self.label_Cover.layer.masksToBounds = true
        

        self.textView.layer.cornerRadius = 9
        self.textView.layer.masksToBounds = true
        
        self.textView.scrollEnabled = false
        self.textView.sizeToFit()
        
        self.textView.editable = true
        self.textView.autocorrectionType = UITextAutocorrectionType.Yes
        
        


        
        
        //self.textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.baseView_Send.translatesAutoresizingMaskIntoConstraints = false
        

        let imageLenSquare: CGFloat = UIScreen.mainScreen().bounds.width * 0.75
        self.imageUnderKb.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - imageLenSquare, imageLenSquare, imageLenSquare)
        self.imageUnderKb.clipsToBounds = true
        
        
        let whiteCoverView = UIView(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - (imageLenSquare * 2), width: UIScreen.mainScreen().bounds.width, height: imageLenSquare * 2))
        whiteCoverView.backgroundColor = UIColor.whiteColor()
        
        
        self.view.insertSubview(self.imageUnderKb, atIndex: 0)
        self.view.insertSubview(whiteCoverView, atIndex: 0)
      

    }
    

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
        

        
        let notifcaitonCenter = NSNotificationCenter.defaultCenter()
        
        notifcaitonCenter.addObserver(self, selector: "adjustKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        
        notifcaitonCenter.addObserver(self, selector: "adjustKeyboard:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        
        notifcaitonCenter.addObserver(self, selector: "queryMessagesClass", name: "NotificationIdentifierNewMessage", object: nil)

        
        notifcaitonCenter.addObserver(self, selector: "screenShot", name: UIApplicationUserDidTakeScreenshotNotification, object: nil)
        
        
        
        
        //set the codeName as the title on the top Nav bar
        self.title = self.codeName
        

        //cover label will turn red when network is not available
        if self.appDelegate.networkSignal {
            self.label_Cover.backgroundColor = self.appDelegate.allColorsArray[1]
            self.label_Cover.text = "tap to write"
        }
        
        else {
            self.label_Cover.backgroundColor = self.appDelegate.allColorsArray[2]
            self.label_Cover.text = "weak network signal"
            
            
            //changes back to original
            self.utilities.delay(6.0, closure: { () -> () in
                self.label_Cover.backgroundColor = self.appDelegate.allColorsArray[1]
                self.label_Cover.text = "tap to write"
            })
        }
        
   

        self.messageArray.removeAll(keepCapacity: false)
        self.orderArray.removeAll(keepCapacity: false)
        
        self.messageArray = ["verifying access..."]
        self.orderArray = [0]
        
        self.tableView.reloadData()
        

        
        self.queryConnection.cancel()
        self.queryMessages.cancel()
        
        self.queryConnectionClass()
        
    }
    
    
    
    
    func queryConnectionClass() {
    
        self.queryConnection.whereKey("objectId", equalTo: self.codeId)
        self.queryConnection.findObjectsInBackgroundWithBlock { (userCodes, error) -> Void in
            
            if let error = error {
                
                if error.code == 100 {
                    self.appDelegate.networkSignal = false
                }
                else {
                    self.appDelegate.networkSignal = true
                }
                
                
            }
            else if let userCodes = userCodes {
                self.appDelegate.networkSignal = true
                
                self.messageArray.removeAll(keepCapacity: false)
                self.orderArray.removeAll(keepCapacity: false)
                
                if userCodes.count == 1 {
                    self.canSendMessage = true
                    
                    let thisCode = userCodes.first!
                    
                    
                    self.pairs = thisCode.valueForKey("pairs") as! [(String)]
                    
                    
                    //self.orderArray = thisCode.valueForKey("order")
                    //self.sizeLimit = thisCode.valueForKey("sizeLimit")
                    //self.deleteInterval = thisCode.valueForKey("deleteInterval")
                    
  
                    if self.pairs.contains(self.appDelegate.userName) {
                        
                        let order = self.pairs.indexOf(self.appDelegate.userName)! + 1
                        self.userOrder = order
                    
                    }
                    else {
                        //self.partWaysAlert(false)
                    }
                    
                    
                    
                    
                    self.queryMessagesClass()
                    
                }
                
            }
            
            
        }
    }
    
    
    
    
    
    func queryMessagesClass() {
        
        self.queryMessages.whereKey("codeId", equalTo: self.codeId)
        self.queryMessages.limit = 620
        self.queryMessages.orderByAscending("createdAt")
        
        
        self.queryMessages.findObjectsInBackgroundWithBlock { (messages, errorPoint) -> Void in
            
            if let error = errorPoint {
                
                if error.code == 100 {
                    self.appDelegate.networkSignal = false
                }
                else {
                    self.appDelegate.networkSignal = true
                }
                
            }
                
            else if let messages = messages {
                self.appDelegate.networkSignal = true

                
                
                self.orderArray.removeAll(keepCapacity: false)
                self.messageArray.removeAll(keepCapacity: false)
                
                for text in messages {
                    
                    let whoFlew = text.valueForKey("order") as! Int
                    let message = text.valueForKey("message") as! String
                    
                    self.orderArray.append(whoFlew)
                    self.messageArray.append(message)
                }
                
                self.tableView.reloadData()
                
                
                
                if self.tableView.numberOfRowsInSection(0) > 0 {
                    //scrolls tableView to show the last message in view
                    let lastIndex = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1, inSection: 0)
                    self.tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                }
                

            }
        }
        
    }
    

    
    
    
    
    
    @IBAction func pressedSend(sender: AnyObject) {
        
        let textInput: String = self.textView.text
        self.textView.text = ""
        
        self.numMessagesWaiting++

        if !textInput.isEmpty {
            self.messageArray.append(textInput)
            self.orderArray.append(self.userOrder)
            
            self.tableView.reloadData()
            
            //scrolls tableView to show the last message in view
            let lastIndex = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
            
            
            self.sendPush()
            
            
            
            self.saveMessage(textInput)
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func sendPush() {
        
        
        var pairsToPush = [(String)]()
        for userId in self.pairs {
            if userId != self.appDelegate.userName && userId != "PiGone" {
                pairsToPush.append(userId)
            }
        }
        

        let push = ["4E159BB1-7B45-44E0-894A-96ABF36803EC"]
        if push.count >= 1 {
            
            //send push that says a new user joined
            let uQuery: PFQuery = PFUser.query()!
            uQuery.whereKey("username", containedIn: push)
            
            let pushQuery: PFQuery = PFUser.query()!
            pushQuery.whereKey("user", matchesQuery: uQuery)
            
            let push: PFPush = PFPush()
            push.setQuery(pushQuery)
            
            print("Ping")
            push.setMessage("Ping")
            
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
    
    
    
    
    
    
    
    
    func saveMessage(textInput: String) {


        let messageTable = PFObject(className: "Messages")
    
        messageTable.setValue(self.userOrder, forKey: "order")
        messageTable.setValue(textInput, forKey: "message")
        messageTable.setValue(self.codeId, forKey: "codeId")
        
        
        messageTable.saveInBackgroundWithBlock { (sucess: Bool, errorSave: NSError?) -> Void in
            
            if let error = errorSave {
                
                if error.code == 100 {
                    self.appDelegate.networkSignal = false
                }
                else {
                    self.appDelegate.networkSignal = true
                }
                self.messageArray.removeLast()
                self.messageArray.removeLast()
            }
                
            else if sucess {
                self.appDelegate.networkSignal = true
                //array indicating whether or not inbox should allow conversation to be cleared
                
                
            }
            else {
                //unclear what would fall to this case
                //but it would logically follow to remove the message
                self.messageArray.removeLast()
                self.messageArray.removeLast()
            }
            
            //self.messageSending = false
            self.numMessagesWaiting--
            //checkHere
            
            
            self.tableView.reloadData()
        }
    }
    
    

    
    
    func screenShot() {
        print("screen shot")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell: MessageTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForMessages") as? MessageTableViewCell {
            
            let order = self.orderArray[indexPath.row]
  
            if self.userOrder == order {
                
                cell.rightBar.backgroundColor = self.appDelegate.allColorsArray[self.userOrder]
                
                cell.leftBar.backgroundColor = UIColor.clearColor()

                cell.labelMessage.text = self.messageArray[indexPath.row]
                cell.labelMessage.textAlignment = NSTextAlignment.Right
            }
                
            else {
                cell.leftBar.backgroundColor = self.appDelegate.allColorsArray[order]
                
                cell.rightBar.backgroundColor = UIColor.clearColor()
                
                cell.labelMessage.text = self.messageArray[indexPath.row]
                cell.labelMessage.textAlignment = NSTextAlignment.Left
            }
            
            
            //right indicator bar is clear until message is sent
            if (self.orderArray.count - self.numMessagesWaiting) <= indexPath.row {
                cell.rightBar.backgroundColor = UIColor.whiteColor()
            }

            return cell
        }
            
        else {
            return UITableViewCell()
        }
        
        
    }

    
    
    

    
    
    

    
    func adjustKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        if notification.name == UIKeyboardWillHideNotification {
            
            if !self.textView.hasText() {
                
                self.label_Cover.hidden = false
                
                self.button_Send.hidden = true
                self.label_ThinBorder.hidden = true
            }


    
            
            UIView.animateWithDuration(1.2, animations: { () -> Void in

                
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)

                
                }, completion: { (sucess) -> Void in
                    
            })
                
            
            
        } else {
            
            self.label_Cover.hidden = true
            
            self.button_Send.hidden = false
            self.label_ThinBorder.hidden = false
            

            
            UIView.animateWithDuration(0.1, animations: {

                
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - keyboardViewEndFrame.height)

                
                
                }, completion: { (success) -> Void in
                    if success {
                        
                        
                        if self.tableView.numberOfRowsInSection(0) > 0 {
                            //scrolls tableView to show the last message in view
                            let lastIndex = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1, inSection: 0)
                            self.tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                        }

                     
                
                    }
                
                })
        }
        

            
    }
    
        
        
        
    
    
    
    
    

    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    

        if self.appDelegate.noReply.contains(self.codeName) {
            return false
        }
        
        else if !self.appDelegate.networkSignal {
            self.label_Cover.backgroundColor = self.appDelegate.allColorsArray[2]
            self.label_Cover.text = "weak network signal"
            
            
            self.utilities.delay(6.0, closure: { () -> () in
                self.label_Cover.backgroundColor = self.appDelegate.allColorsArray[1]
                self.label_Cover.text = "tap to write"
            })
            
            return false
        }
        
            
        else {
            return true
        }
    }
    

    
    
    
    
    
    
    
    

    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NotificationIdentifierNewMessage", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationUserDidTakeScreenshotNotification, object: nil)
        
        
        self.queryConnection.cancel()
        self.queryMessages.cancel()
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
