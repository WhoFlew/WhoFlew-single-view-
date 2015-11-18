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
    @IBOutlet weak var navItem_Edit: UIBarButtonItem!
    //right bar item: button toggles between generate and pair views at the bottom
    var navItem_Generate: UIBarButtonItem!
    var navItem_Cancel: UIBarButtonItem!
    var baseViewIsPair: Bool = true
    
    
    
    
    @IBOutlet weak var connectionBar: UIView!
    @IBOutlet weak var baseView_Pair: UIView!
    var view_BaseGen: UIView!
    
    @IBOutlet weak var button_Pair: UIButton!
    @IBOutlet weak var textField: UITextField!
    var kbSize: CGSize = CGSize()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.inboxTable.delegate = self
        self.inboxTable.dataSource = self
        
        
        //button: plus system symbol, changes view at bottom
        //when pressed: from pair -> generate
        self.navItem_Generate = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "toggleRightNavItem:")
        self.navItem_Generate.tag = 0
        
        //button: x system symbol, changes view at bottom
        //when pressed: from anything -> pair, resign first responder and return
        self.navItem_Cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "toggleRightNavItem:")
        self.navItem_Cancel.tag = 1
        
        
        //nav bar starts as generate tab
        self.navigationItem.rightBarButtonItem = self.navItem_Generate
        
        //textField for generate/pair doesnt use auto correct
        self.textField.autocorrectionType = UITextAutocorrectionType.No
        
        
        //button for generate/pair toggle
        self.button_Pair.layer.cornerRadius = 12
        self.button_Pair.layer.masksToBounds = true
        
        
        
        //89.0: height of pair/generate view (textfield and button)
        //100.0: height of this view
        //1.0: gap between the two
        var yPosition: CGFloat = self.view.frame.size.height - 89.0 - 100.0 - 1.0
        
        self.view_BaseGen = UIView(frame: CGRect(x: 0.0, y: yPosition, width: self.view.frame.size.width, height: 100))
        self.view_BaseGen.backgroundColor = self.appDelegate.allColorsArray[1]
        
        self.view.addSubview(self.view_BaseGen)
        self.view_BaseGen.hidden = true
        
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        //keyboard notifactions
        //keyboard shown
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardShow:", name: UIKeyboardDidShowNotification, object: nil)
        //keyboard down
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardHide:", name: UIKeyboardDidHideNotification, object: nil)
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
    
    
    
    func toggleRightNavItem(sender: AnyObject) {
        
        if self.textField.isFirstResponder() {
            self.textField.resignFirstResponder()
        }
        
        
        
        //tag 0: generate button. plus image, system icon
        //tag 1: cancel button. stop image, sysmtem icon
        if !self.baseViewIsPair || sender.tag == 1 {
            self.baseViewIsPair = true
            
            self.navigationItem.setRightBarButtonItem(self.navItem_Generate, animated: true)
            
            self.button_Pair.setTitle("Pair", forState: UIControlState.Normal)
            
            self.textField.placeholder = "Enter Connection Code"
            
            //views for generate
            self.baseView_Pair.backgroundColor = self.appDelegate.allColorsArray[2]
    
            
            self.view_BaseGen.hidden = true
            

        }
        else {
            self.baseViewIsPair = false
            
            self.navigationItem.setRightBarButtonItem(self.navItem_Cancel, animated: true)
            
            
            self.button_Pair.setTitle("Generate", forState: UIControlState.Normal)
            
            
            self.textField.placeholder = "Leave Blank for Random Code"
            
            
            //views for generate
            self.baseView_Pair.backgroundColor = self.appDelegate.allColorsArray[1]
            

            self.view_BaseGen.hidden = false

        }
        
        
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    func keyBoardShow(notification: NSNotification) {
        
        var info: Dictionary = notification.userInfo!
        self.kbSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        
        var totalViewHeight = self.view.frame.size.height
        var view_BaseTouchBottom = self.connectionBar.frame.origin.y + self.connectionBar.frame.size.height
        
        if (totalViewHeight == view_BaseTouchBottom) {
            self.connectionBar.frame.offset(dx: 0.0, dy: -self.kbSize.height)
        }
        
        if !self.baseViewIsPair {
            self.view_BaseGen.frame.origin.y =  self.view_BaseGen.frame.origin.y - self.kbSize.height
        }
        
        self.navigationItem.setRightBarButtonItem(self.navItem_Cancel, animated: true)
    }
    
    
    
    func keyBoardHide(notification: NSNotification) {
        
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        
        if self.baseViewIsPair {
            println("here")
            self.view_BaseGen.frame.origin.y = self.view.frame.size.height - 89.0 - 100.0 - 1.0
        }

    }
    
    
    
    
    
    //textfield for the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        
        return true
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
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