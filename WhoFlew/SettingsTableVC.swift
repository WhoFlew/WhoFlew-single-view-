//
//  SettingsTableVC.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/14/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 5
        }
        else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Details"
        }
        else {
            return "WhoFlew, a Juup production"
        }
    }

    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        //"Details"
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForSettings")!
                cell.textLabel!.text = "Infinite Connection: Enter Suffix"
                return cell
            }
            
            else if indexPath.row == 1 {
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForSettings")!
                cell.textLabel!.text = "Inbox Size Limit: 10"
                return cell
            }
                
            else {
                
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForSettings")!
                cell.textLabel!.text = "NickNames Coming Soon!"
                return cell
                
            }
        }
            
            
            
            
            
        
        //"WhoFlew, a Juup production"
        else {
            if indexPath.row == 0 {
                
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForSettings")!
                cell.textLabel!.text = "Share WhoFlew"
                return cell
            }
            
            else if indexPath.row == 1 {
                
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForSettings")!
                cell.textLabel!.text = "Share your Opinion"
                return cell
            }
                
            else if indexPath.row == 2 {
                
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForSettings")!
                cell.textLabel!.text = "Contact Us"
                return cell
            }
                
            else if indexPath.row == 3 {
                
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForSettings")!
                cell.textLabel!.text = "Rules"
                return cell
            }
                
            else {
                
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellForSettings")!
                cell.textLabel!.text = "Terms of Service"
                return cell

            }
        }
            
            
    }
    
    

        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        //"Details"
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //infinite connection
            }
                
            else if indexPath.row == 1 {
                //inbox size limit
                
                let dismiss = UIAlertAction(title: "✌️", style: UIAlertActionStyle.Cancel, handler: nil)

                let alert = UIAlertController(title: "☝️", message: "No adds. No in app purchases. Due to the size of our user base compared to our servers, we can only offer 10 connections per user.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(dismiss)
                
                self.presentViewController(alert, animated: true, completion: nil)

            }
                
            else {
                //nickNames coming soon
                
            }
        }
            
        //"WhoFlew, a Juup production"
        else {
            
            
            //share whoflew
            if indexPath.row == 0 {
            
                let messageComposer = MessageComposer()
                if (messageComposer.canSendText()) {
                    // Obtain a configured MFMessageComposeViewController
                    let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                    
                    // Present the configured MFMessageComposeViewController instance
                    // Note that the dismissal of the VC will be handled by the messageComposer instance,
                    // since it implements the appropriate delegate call-back
                    self.presentViewController(messageComposeVC, animated: true, completion: nil)
                } else {
                    // Let the user know if his/her device isn't able to send text messages
                    let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                }
            }
              
                
            //share your opinion
            else if indexPath.row == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string : "https://www.itunes.apple.com/us/app/whoflew/id997725666?mt=8")!)
                    
                }
                
                
            //contact us
            else if indexPath.row == 2 {
                
            }
               
            
            //rules
            else if indexPath.row == 3 {
                
            }
               
                
            //terms of serivce
            else {
                self.performSegueWithIdentifier("showTerms", sender: self)
            }
        }

    
    }

    
    
    
    
    
    
    
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
