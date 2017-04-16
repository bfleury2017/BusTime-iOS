//
//  AppDelegate.swift
//  BusTime
//
//  Created by Brian Fleury on 3/6/16.
//  Copyright © 2016 Fleury. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func checkDays()->String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        let fullDate = formatter.stringFromDate(date)
        
        if fullDate.containsString("Saturday") || fullDate.containsString("Sunday") {
            return "No service on weekends"
        } else if fullDate.containsString("check") {
            let holiday = "Thanksgiving"
            return "No service on: \(holiday)"
        } else {
            return "0"
        }
    }
    
    func compareBusTimes(busTime: String) ->Bool {
        let date = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        let currentDate = formatter.stringFromDate(date)
        
        //format the object for AM/PM (h:mm a)
        formatter.dateFormat = "MM/dd/yy h:mm a"
        let busDate = formatter.dateFromString(currentDate + " " + busTime)
        let elapSeconds = busDate?.timeIntervalSinceNow
        
        //if time is more than 30 seconds away but not more than 20 minutes?
        if elapSeconds > 30{
            return true
        } else {
            return false
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
    }


}
