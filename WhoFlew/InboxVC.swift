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
    let utilities = Utilities()
    
    @IBOutlet var inboxTable: UITableView!
    @IBOutlet weak var navItem_Edit: UIBarButtonItem!
    //right bar item: button toggles between generate and pair views at the bottom
    var navItem_Generate: UIBarButtonItem!
    var navItem_Cancel: UIBarButtonItem!
    var baseViewIsPair: Bool = true
    
    
    
    
    @IBOutlet weak var connectionBar: UIView!
    @IBOutlet weak var baseView: UIView!
    var baseView_Ext: UIView!
    
    @IBOutlet weak var button_Go: UIButton!
    @IBOutlet weak var textField: UITextField!
    var kbSize: CGSize = CGSize()
    var kbIsUp: Bool = false
    
    var activityWheel = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    
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
        self.button_Go.layer.cornerRadius = 12
        self.button_Go.layer.masksToBounds = true
        
        
        //loading wheel replaces button
        self.activityWheel.frame = self.button_Go.frame
        self.baseView.addSubview(self.activityWheel)
        self.activityWheel.hidden = true
        
        
        
        //89.0: height of pair/generate view (textfield and button)
        //100.0: height of this view
        //1.0: gap between the two
        var yPosition: CGFloat = self.view.frame.size.height - 89.0 - 100.0 - 1.0
        
        self.baseView_Ext = UIView(frame: CGRect(x: 0.0, y: yPosition, width: self.view.frame.size.width, height: 100))
        self.baseView_Ext.backgroundColor = self.appDelegate.allColorsArray[1]
        
        self.view.addSubview(self.baseView_Ext)
        self.baseView_Ext.hidden = true
        
        
        
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
            
            
            
            
            
        //generated codes without text in textField will be random (ie: purple monkey)
        else if self.button_Go.titleLabel!.text == "Generate" {
            return true
        }
        
            
        //pair input cannot be blank
        else {
            self.presentViewController(self.alertsByType("enterCodeToPair"), animated: true, completion: nil)
            return false
        }

    }
    
    
    @IBAction func pressedGo(sender: AnyObject) {
        
        
        if self.isValidCode(self.textField.text) {
            self.button_Go.hidden = true
            
            self.activityWheel.startAnimating()
            self.activityWheel.hidden = false
            
            
            if self.button_Go.titleLabel!.text == "Pair" {
                self.pairWithCode(self.textField.text)
            }
            else if self.button_Go.titleLabel!.text == "Generate" {
                self.generateCode(self.textField.text)
            }
            
        }
            
        //clear textField text is not valid codeName
        else {
            self.textField.text = ""
        }

    }
    
    
    func pairWithCode(codeName: String) {
        
        
        //reset button title
    }
    
    func generateCode(codeName: String) {
        
        
        //reset button title
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func keyBoardShow(notification: NSNotification) {
        self.kbIsUp = true
        
        var info: Dictionary = notification.userInfo!
        self.kbSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        

        if self.kbIsUp {
            self.connectionBar.frame.offset(dx: 0.0, dy: -self.kbSize.height)
            
            if !self.baseViewIsPair {
                self.baseView_Ext.frame.origin.y =  self.baseView_Ext.frame.origin.y - self.kbSize.height
            }
        }
        
        
        
        self.navigationItem.setRightBarButtonItem(self.navItem_Cancel, animated: true)
    }
    
    
    
    func keyBoardHide(notification: NSNotification) {
        self.kbIsUp = false
        
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size)!
        

        //89.0: height of pair/generate view (textfield and button)
        //100.0: height of this view
        //1.0: gap between the two
        self.baseView_Ext.frame.origin.y = self.view.frame.size.height - 89.0 - 100.0 - 1.0
    }
    
    
    
    
    
    //textfield for the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        
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
    
    
    
    func toggleRightNavItem(sender: AnyObject) {
        
        if self.textField.isFirstResponder() {
            self.textField.resignFirstResponder()
        }
        
        
        //tag 1: cancel button. stop image, sysmtem icon
        if sender.tag == 1 {
            self.textField.text = ""
        }
        
        
        //tag 0: generate button. plus image, system icon
        //tag 1: cancel button. stop image, sysmtem icon
        if !self.baseViewIsPair || sender.tag == 1 {
            self.baseViewIsPair = true
            
            self.navigationItem.setRightBarButtonItem(self.navItem_Generate, animated: true)
            
            self.button_Go.setTitle("Pair", forState: UIControlState.Normal)
            
            self.textField.placeholder = "Enter Connection Code"
            
            //views for generate
            self.baseView.backgroundColor = self.appDelegate.allColorsArray[2]
    
            
            self.baseView_Ext.hidden = true
            

        }
        else {
            self.baseViewIsPair = false
            
            self.navigationItem.setRightBarButtonItem(self.navItem_Cancel, animated: true)
            
            
            self.button_Go.setTitle("Generate", forState: UIControlState.Normal)
            
            
            self.textField.placeholder = "Leave Blank for Random Code"
            
            
            //views for generate
            self.baseView.backgroundColor = self.appDelegate.allColorsArray[1]
            

            self.baseView_Ext.hidden = false

        }
        
        
        
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