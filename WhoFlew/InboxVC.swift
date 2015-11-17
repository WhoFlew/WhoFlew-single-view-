//
//  InboxVC.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/14/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit





class InboxVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBOutlet var inboxTable: UITableView!
    @IBOutlet weak var buttonEdit: UIBarButtonItem!
    //right bar item: button toggles between generate and pair views at the bottom
    var buttonPair: UIBarButtonItem!
    var buttonGenerate: UIBarButtonItem!
    

    
    
    @IBOutlet weak var connectionBar: UIView!
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var timeSlide: UIView!

    @IBOutlet weak var buttonGo: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.inboxTable.delegate = self
        self.inboxTable.dataSource = self
    
        
        
        
        self.buttonPair = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "toggleNavItem:")
        self.buttonPair.tag = 0
        
        
        self.buttonGenerate = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "toggleNavItem:")
        self.buttonGenerate.tag = 1

        
        self.navigationItem.rightBarButtonItem = self.buttonGenerate
        
        
        
        self.textField.autocorrectionType = UITextAutocorrectionType.No
        
        self.buttonGo.layer.cornerRadius = 12
        self.buttonGo.layer.masksToBounds = true
        
    
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func toggleNavItem(sender: AnyObject) {
        
        self.textField.resignFirstResponder()


        
        
        //tag 0: pair button. item at top nav bar
        //tag 1: generate button. item at top nav bar
        if sender.tag == 0 {
            self.navigationItem.setRightBarButtonItem(self.buttonGenerate, animated: true)
            
            self.textField.placeholder = "Enter Connection Code"
            self.buttonGo.setTitle("Pair", forState: UIControlState.Normal)
            
            self.timeSlide.hidden = true
        }
        else {
            self.navigationItem.setRightBarButtonItem(self.buttonPair, animated: true)
            
            self.textField.placeholder = "Leave Blank for Random Code"
            self.buttonGo.setTitle("Generate", forState: UIControlState.Normal)
            
            self.timeSlide.hidden = false
        }
        
        

    }
    
    
    
    func keyBoardShow(notification: NSNotification) {
        
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        
        var totalViewHeight = self.view.frame.size.height
        var connectionBarTouchBottom = self.connectionBar.frame.origin.y + self.connectionBar.frame.size.height
        
        if (totalViewHeight == connectionBarTouchBottom) {
            self.connectionBar.frame.offset(dx: 0.0, dy: -keyboardSize.height)
        }

    }
    
    
    
    func keyBoardHide(notification: NSNotification) {
        
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        
        //self.scrollView.scrollRectToVisible(CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1), animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        self.performSegueWithIdentifier("enterConvo", sender: self)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    

    

    


    @IBAction func pressedEdit(sender: AnyObject) {
        
        if self.buttonEdit.title == "Edit" {
            self.inboxTable.setEditing(true, animated: true)
            self.buttonEdit.title = "Done"


        }
        else {
            self.inboxTable.setEditing(false, animated: true)
            self.buttonEdit.title = "Edit"

        }
        
    }
    
    
    

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editingStyle == .Delete {
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
