//
//  DialogueViewController.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/14/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit

class DialogueVC: UIViewController {

    @IBOutlet weak var sendBarView: UIView!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelCover: UILabel!
    
    

    var kbHeight: CGFloat = 0.0
    

    @IBOutlet var pageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelCover.layer.cornerRadius = 12
        self.labelCover.layer.masksToBounds = true
        
        

        self.textView.layer.cornerRadius = 9
        self.textView.layer.masksToBounds = true
        self.textView.scrollEnabled = false
        self.textView.sizeToFit()
        
        self.textView.editable = true
        self.textView.autocorrectionType = UITextAutocorrectionType.Yes
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)

        
    }
    
    
    
    func keyboardDidHide(notification: NSNotification) {
        println("here")
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println("here1")
    }
    

    
    func keyboardChange(notification: NSNotification){
        
        if self.kbHeight == 0 {
            
            self.labelCover.hidden = true
            self.buttonSend.hidden = false
        }
        
        
        
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                
                if self.sendBarView.frame.height + self.kbHeight > self.kbHeight + self.sendBarView.frame.origin.y {
                    
                }
                else {
                    self.kbHeight = keyboardSize.height - self.kbHeight
                    //only move frame if its at the bottom
                  
                }
                
                self.kbHeight = keyboardSize.height
                
            }
        }
        
    }
    

    
    
    func animateTextField(up: Bool) {
        var movement = (up ? -kbHeight : kbHeight)
        
        var duration: Double = 0.0
        if up {
            duration = 1.67
        }
        
        
        
        UIView.animateWithDuration(duration, animations: {
            
            self.pageView.frame = CGRectMake(0.0, 0.0, self.pageView.frame.size.width, self.pageView.frame.size.height - self.kbHeight)
            
        })
        

        
        self.kbHeight = 0
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.buttonSend.hidden = true
        self.buttonSend.layer.cornerRadius = 9
        self.buttonSend.layer.masksToBounds = true
        
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
