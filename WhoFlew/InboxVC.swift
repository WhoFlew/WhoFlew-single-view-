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

    
    @IBOutlet weak var connectionBar: UIView!
    
    @IBOutlet weak var buttonGenerate: UIButton!

    @IBOutlet weak var buttonPair: UIButton!
    
    @IBOutlet weak var DynamicView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        self.inboxTable.delegate = self
        self.inboxTable.dataSource = self
    
        
        self.buttonPair.layer.cornerRadius = 12
        self.buttonPair.layer.masksToBounds = true
        
        self.buttonGenerate.layer.cornerRadius = 12
        self.buttonGenerate.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
   
    @IBAction func addConvo(sender: AnyObject) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        //var DynamicView=UIView(frame: CGRectMake(0, (screenHeight * 0.15), screenWidth, (screenHeight * 0.75)))
        DynamicView.backgroundColor=UIColor.whiteColor().colorWithAlphaComponent(0.75)
      
        DynamicView.layer.cornerRadius=5
        DynamicView.layer.borderWidth=0.5
        DynamicView.alpha = 0.0
        
        UIView.animateWithDuration(0.5, animations: {
           self.DynamicView.alpha = 1.0
        })
        
        let popSize: CGRect = DynamicView.bounds
        
        
        
        
        
        //Generation Conversation Title
        let generateTitle =  UILabel() as UILabel
        generateTitle.frame = CGRectMake(screenWidth/2, popSize.height * 0.05, 175, 50)
        generateTitle.text = "Generate Conversation"
        DynamicView.addSubview(generateTitle)
        
        //Slider
        let durationSlider = UISlider() as UISlider
        durationSlider.frame = CGRectMake(25, popSize.height * 0.15, 250, 50)
        DynamicView.addSubview(durationSlider)
        
        //TextField for Custom Name
        let customField = UITextField() as UITextField
        customField.frame = CGRectMake(0, popSize.height * 0.25, 300, 50)
        customField.placeholder = "Enter custom conversation name..."
        DynamicView.addSubview(customField)
        
        //Button for Custom Name
        let customButton   = UIButton() as UIButton
        customButton.frame = CGRectMake(25, popSize.height * 0.35, 200, 35)
        customButton.backgroundColor = UIColor.blueColor()
        customButton.setTitle("Create Custom", forState: UIControlState.Normal)
        customButton.addTarget(self, action: "customName:", forControlEvents: UIControlEvents.TouchUpInside)
        DynamicView.addSubview(customButton)
        
        //Button for Random Name
        let randomButton   = UIButton() as UIButton
        randomButton.frame = CGRectMake(25, popSize.height * 0.45, 200, 35)
        randomButton.backgroundColor = UIColor.blueColor()
        randomButton.setTitle(" Create Random", forState: UIControlState.Normal)
        randomButton.addTarget(self, action: "randomName:", forControlEvents: UIControlEvents.TouchUpInside)
        DynamicView.addSubview(randomButton)
        
        //Horiztonal Separator 
        let hSeparator = UIView() as UIView
        hSeparator.frame = CGRectMake(25, popSize.height * 0.6, screenWidth * 0.85, 1)
        hSeparator.backgroundColor =  UIColor.grayColor().colorWithAlphaComponent(0.45)
        DynamicView.addSubview(hSeparator)
        
        //Pair Conversation Title
        let pairTitle =  UILabel() as UILabel
        pairTitle.frame = CGRectMake(screenWidth/2, popSize.height * 0.65, 175, 50)
        pairTitle.text = "Pair To Conversation"
        DynamicView.addSubview(pairTitle)
        
        //TextField for Pair Name
        let pairField = UITextField() as UITextField
        pairField.frame = CGRectMake(0, popSize.height * 0.75, 300, 50)
        pairField.placeholder = "Enter pair code..."
        DynamicView.addSubview(pairField)
        
        //Button for Pair Name
        let pairButton   = UIButton() as UIButton
        pairButton.frame = CGRectMake(25, popSize.height * 0.85, 200, 35)
        pairButton.backgroundColor = UIColor.blueColor()
        pairButton.setTitle("Pair Now", forState: UIControlState.Normal)
        pairButton.addTarget(self, action: "randomName", forControlEvents: UIControlEvents.TouchUpInside)
        DynamicView.addSubview(pairButton)
        
        
    }

    func customName(sender:UIButton!)
    {
        //Take duration and store custom name
    }
    
    func randomName(sender:UIButton!)
    {
            //Take duration and generate random name and store it
    }
    func pairName(sender:UIButton!)
    {
        //Pair to this conversation
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
