//
//  AppDelegate.swift
//  WhoFlew
//
//  Created by Austin Matese on 11/14/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit
import CoreData
import Parse
import Bolts


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //dictionary for simple types, used to store settings
    let userDefaults = NSUserDefaults.standardUserDefaults()
    //daily pair limit
    var datesOfPairAttempts = [(NSDate)]()
    var numPairAttemptsInLast24: Int = 0
    
    
    //parse server id and key, 0
    let idDialogue: String = "0tsej3yMuG95kbOaeQXLihgbsF9ycgNErj7UJAkK"
    let keyDialogue: String = "dRu62EGKeDARgT2hgTX9LLFJ1MPqKevaozUp5XJn"
    
    //true: when connection to the internet appears to be present (has yet to fail)
    //false: when internet/parse connection has failed
    var networkSignal: Bool = false
    
    
    
    var userName: String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
    
    
    var statusBarSize: CGSize!
    var navBarSize: CGSize!
    
    
    let allColorsArray =  [
        UIColor.clearColor(),
        UIColor(netHex:0x3b8af3),
        //UIColor(red: 251.0/255.0, green: 65.0/255.0, blue: 74.0/255.0, alpha: 1.0), //colorMelodRed
        UIColor.redColor(),
        UIColor(red: 92.0/255.0, green: 1, blue: 102.0/255.0, alpha: 1.0), //colorFroggertGreen
        UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 255.0/255.0, alpha: 1.0), //colorPurpleParadise
        UIColor.orangeColor(),
        UIColor.cyanColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blackColor(),
        UIColor.magentaColor(),
        UIColor.blueColor(),
        UIColor.brownColor()

    ]
    

    let colorSkyCrisp = UIColor(red: 58.0/255.0, green: 179.0/255.0, blue: 255.0/255.0, alpha: 1.0)

    
    
    //codes that dont let users send messages
    var noReply = ["welcome!"]
    var codesDeleted = [(String)]()
    var shouldDeleteThese = [(String)]()


    
    //objects in core data, stores details of conversation (endAt, shouldDelete, userOrder)
    var userCodes = [(NSManagedObject)]()

    
    //used to query all codes in the inbox
    var codeIds = [(String)]()
    //just the name of connections
    var codeNames = [(String)]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        

        
        
        //set up parse with id and key
        Parse.setApplicationId(self.idDialogue, clientKey: self.keyDialogue)
        
        

        
        
        
        
        //check here
        self.networkSignal = true
        
        
        
        
        
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
                
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
            
        } else {
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            
            
            
        }

        
        return true
    }
    
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifierNewMessage", object: nil)
        
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        //get into the incoming notification alert
        //this entire series of if-let is to destermine type of alert and then seperate codeName from textMessage
        if let aps = userInfo["aps"] as? NSDictionary {
            
            if let pushText = aps["alert"] as? String {
                
                let array = Array(arrayLiteral: pushText)
                
                if array.first == "A" {
                
                    PFPush.handlePush(userInfo)
                    NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifierNewUserPaired", object: nil)
                }
                else {
                    NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifierNewMessage", object: nil)
                    

                }
                
            }
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    
    
    
    
    
    
    
    
    
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.atomm.WhoFlew" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("WhoFlew", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("WhoFlew.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func fetchFromCoreData() {
        
        
        let context: NSManagedObjectContext = self.managedObjectContext!

        
        let request = NSFetchRequest(entityName: "Connections")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "endAt", ascending: true)]
        
        
        let results: NSArray = try! context.executeFetchRequest(request)
        
        
        self.userCodes.removeAll(keepCapacity: false)
        
        

        for code in results {
            
            
            let codeId = code.valueForKey("codeId") as! String
            let codeName = code.valueForKey("codeName") as! String
            
            let endAt = code.valueForKey("endAt") as? NSDate
            let shouldDelete = code.valueForKey("shouldDelete") as? Bool

            let userMade = code.valueForKey("userOrder") as! Int
            

            
            if !endAt!.timeIntervalSinceNow.isSignMinus &&
                !shouldDelete! &&
                    !self.shouldDeleteThese.contains(codeId) {
                    
                self.userCodes.append(code as! (NSManagedObject))
                
                self.codeIds.append(codeId)
                self.codeNames.append(codeName)
            }
            else {
                self.codesDeleted.append(codeName)
                self.managedObjectContext!.deleteObject(code as! NSManagedObject)
            }
            


            if userMade == 1 {
                //self.userMadeCount++
            }
            
            

        }
        self.saveContext()
        self.saveSettings()

        
        self.shouldDeleteThese.removeAll(keepCapacity: false)
    }
    
    
    
    
    
    
    func saveSettings() {
        
        self.userDefaults.setValue(self.datesOfPairAttempts, forKey: "datesOfPairAttempts")
        //self.userDefaults.setValue(self.alreadyHere, forKey: "alreadyHere")
        
    }
    
    
    
    
    
    
    func readSettings() {
        
        if self.userDefaults.objectForKey("datesOfPairAttempts") != nil {
            self.datesOfPairAttempts = self.userDefaults.arrayForKey("datesOfPairAttempts") as! [(NSDate)]
            
            for date in self.datesOfPairAttempts {
                if date.timeIntervalSinceNow >= (24.0 * 60.0  * 60.0) {
                    self.numPairAttemptsInLast24++
                }
            }
            
            
        }else {
            self.saveSettings()
        }
        
    }
    

}

