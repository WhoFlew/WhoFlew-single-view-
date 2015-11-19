//
//  DialogueViewController.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/14/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit
import Foundation

class DialogueVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //contains the content for the send bar at the bottom of view
    @IBOutlet weak var baseView_Send: UIView!
    //textView and sendButton for new messages
    @IBOutlet weak var button_Send: UIButton!
    @IBOutlet weak var textView: UITextView!
    var kbSize: CGSize = CGSize()
    var kbIsUp: Bool = false
    
    //'tap to write' covers the textView 
    //thinBorder seperates the textview from the messages in table
    @IBOutlet weak var label_Cover: UILabel!
    @IBOutlet weak var label_ThinBorder: UILabel!
    

    
    
    var codeName: String = "PiGone"
    var codeID: String = "PiGone"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 50.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
    
        
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
        self.baseView_Send.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name: UIKeyboardDidShowNotification, object: nil)

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardHide:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

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
            self.delay(6.0, closure: { () -> () in
                self.label_Cover.backgroundColor = self.appDelegate.allColorsArray[1]
                self.label_Cover.text = "tap to write"
            })
        }
        
   

       
        
        //scrolls tableView to show the last message in view
        var lastIndex = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
        
        
        self.tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell: MessageTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForMessages") as? MessageTableViewCell {
            
  
            if indexPath.row % 2 == 0 {
 
                
                cell.leftBar.backgroundColor = UIColor.redColor()
            
                cell.rightBar.backgroundColor = UIColor.clearColor()
                

                cell.labelMessage.text = "new message is very long and the very long message could mean that things are very long"
                cell.labelMessage.textAlignment = NSTextAlignment.Left
            }
            else {
                cell.leftBar.backgroundColor = UIColor.clearColor()

                cell.rightBar.backgroundColor = UIColor.redColor()
                
                cell.labelMessage.text = "new message"
                cell.labelMessage.textAlignment = NSTextAlignment.Right
            }

            return cell
        }
            
        else {
            return UITableViewCell()
        }
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    func keyBoardShow(notification: NSNotification) {
        
        var info: Dictionary = notification.userInfo!
        self.kbSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        
        
        if !self.kbIsUp {

            self.label_Cover.hidden = true
            
            self.button_Send.hidden = false
            self.label_ThinBorder.hidden = false
            

            
            UIView.animateWithDuration(0.1, animations: {
                
                self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - self.kbSize.height)
                
            })
            self.kbIsUp = true
            
        }
        
        
    }
    
    
    
    func keyBoardHide(notification: NSNotification) {
        
        var info: Dictionary = notification.userInfo!
        self.kbSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        
        
        if !self.textView.hasText() {

            self.label_Cover.hidden = false
            
            self.button_Send.hidden = true
            self.label_ThinBorder.hidden = true
        }

        if self.kbIsUp {
            
            self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height + self.kbSize.height)


            self.kbIsUp = false
        }
        
        

    }
    
    
    
    
    
    
    
    
    
    
    
    func textViewDidChange(textView: UITextView){
    }
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        

        if contains(self.appDelegate.noReply, self.codeName) {
            return false
        }
        
        else if self.appDelegate.networkSignal {
            self.label_Cover.backgroundColor = self.appDelegate.allColorsArray[2]
            self.label_Cover.text = "weak network signal"
            
            
            self.delay(6.0, closure: { () -> () in
                self.label_Cover.backgroundColor = self.appDelegate.allColorsArray[1]
                self.label_Cover.text = "tap to write"
            })
            
            return false
        }
        
            
        else {
            return true
        }
    }
    

    
    
    
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
