//
//  EULAViewController.swift
//  sleiGh
//
//  Created by Austin Matese on 6/29/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit

class EULAViewController: UIViewController {
    
    
    @IBOutlet weak var EULAField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.EULAField.scrollsToTop = true


        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let range = NSMakeRange(0, 0)
        self.EULAField.scrollRangeToVisible(range)
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
