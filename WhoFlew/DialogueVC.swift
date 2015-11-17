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

    //holds both the tableView and the sendBarView
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //contains the content for the send bar at the bottom of view
    @IBOutlet weak var sendBarView: UIView!
    //textView and sendButton for new messages
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var textView: UITextView!
    //'tap to write' covers the textView 
    //thinBorder seperates the textview from the messages in table
    @IBOutlet weak var labelCover: UILabel!
    @IBOutlet weak var labelThinBorder: UILabel!
    

    var textViewOriginalHeight: CGFloat = 34.0
    
    
    var codeName: String = "PiGone"
    var codeID: String = "PiGone"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 50.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
    
        
        self.buttonSend.hidden = true
        self.labelThinBorder.hidden = true
        

        self.labelCover.layer.cornerRadius = 12
        self.labelCover.layer.masksToBounds = true
        
        
        self.textView.layer.cornerRadius = 9
        self.textView.layer.masksToBounds = true
        
        self.textView.scrollEnabled = false
        self.textView.sizeToFit()
        
        self.textView.editable = true
        self.textView.autocorrectionType = UITextAutocorrectionType.Yes
        
        self.textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name: UIKeyboardDidShowNotification, object: nil)

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardHide", name: UIKeyboardDidHideNotification, object: nil)

    }
    

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
        
        self.scrollView.scrollRectToVisible(CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1), animated: true)

       
        if (self.tableView.contentSize.height >= UIScreen.mainScreen().bounds.size.height) {
            
            println(UIScreen.mainScreen().bounds.size.height)
            println(self.tableView.contentSize.height)
            
            var scrollPoint: CGPoint = CGPointMake(0.0, self.tableView.contentSize.height)
            self.tableView.setContentOffset(scrollPoint, animated: true)
        }
        else {
            var scrollPoint: CGPoint = CGPointMake(0.0, self.scrollView.frame.size.height - self.tableView.frame.height)
            self.tableView.setContentOffset(scrollPoint, animated: true)
        }
        
        
        self.tableView.reloadData()
        
        
        //set the codeName as the title on the top Nav bar
        self.title = self.codeName
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        var keyboardSize: CGSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        
        var viewOrigin: CGPoint = self.sendBarView.frame.origin
        var viewHeight: CGFloat = self.sendBarView.frame.size.height
        
        
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if (!CGRectContainsPoint(visibleRect, viewOrigin)) {
            
            var scrollPoint: CGPoint = CGPointMake(0.0, viewOrigin.y - visibleRect.size.height + viewHeight + 4)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
            
            self.labelCover.hidden = true
            
            self.buttonSend.hidden = false
            self.labelThinBorder.hidden = false
            
        }
    }
    
    
    
    func keyBoardHide() {
        
        
        if !self.textView.hasText() {

            self.labelCover.hidden = false
            
            self.buttonSend.hidden = true
            self.labelThinBorder.hidden = true
        }

        
        self.scrollView.scrollRectToVisible(CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1), animated: true)
        
    }
    
    
    
    
    
    
    
    func textViewDidChange(textView: UITextView){
    }
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        var noReply = ["welcome!"]
        if contains(noReply, self.codeName) {
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
