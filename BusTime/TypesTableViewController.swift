//
//  TypesTableViewController.swift
//  BusTime
//
//  Created by Brian Fleury on 3/6/16.
//  Copyright © 2016 Fleury. All rights reserved.
//

import UIKit

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

class TypesTableViewController: UITableViewController {

    var dict:AnyObject!
    var types:AnyObject!
    var factory:NIKFontAwesomeIconFactory!
    let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let buslist = NSBundle.mainBundle().pathForResource("buslist", ofType: "plist")
        dict = NSDictionary(contentsOfFile: buslist!)
        
        //get the listing of bus types
        types = (dict.allKeys as! [String]).sort()
        
        self.navigationItem.title = "Routes"
        
        factory = NIKFontAwesomeIconFactory.barButtonItemIconFactory()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }

    func checkRouteTime(time: String)->NSTimeInterval {
        let date = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        let currentDate = formatter.stringFromDate(date)
        
        //format the object for AM/PM (h:mm a)
        formatter.dateFormat = "MM/dd/yy h:mm a"
        let busDate = formatter.dateFromString(currentDate + " " + time)
        let elapSeconds = busDate?.timeIntervalSinceNow
        return elapSeconds!
    }
    
    func getBusTimes(type: String, firstTime: Bool)->[String] {
        let typesDict = dict!.objectForKey(type)!
        let locationsDict = typesDict.objectForKey("Locations")! as! NSDictionary
        let locationsForType = locationsDict.allKeys as! [String]
        let locations = locationsForType.sort()
        
        var location: String!
        if firstTime {
            //get the times for the first location on route
            location = locations[0]
        } else {
            //get the times for the last location on route
            location = locations[locations.count - 1]
        }
        let busTimes = locationsDict.objectForKey(location)! as! [String]
        return busTimes
    }
    
    func setFactoryColor(row: Int) {
        let crosstownBrown = UIColor(red: 237, green: 168, blue: 32)
        let heightsGreen = UIColor(red: 68, green: 178, blue: 78)
        let penacookBlue = UIColor(red: 63, green: 128, blue: 192)
        
        //set icon colors based on route type
        if row < 2 {
            factory.colors = [crosstownBrown]
        } else if row < 4 {
            factory.colors = [heightsGreen]
        } else {
            factory.colors = [penacookBlue]
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("TypesCell", forIndexPath: indexPath)
        
        //set colors for type icons
        setFactoryColor(indexPath.row)
        let image = setImages(indexPath.row)
        cell.imageView?.image = image

        //get route detail from list
        let type = types[indexPath.row] as! String
        let typesDict = dict!.objectForKey(type)!
        let typeDetail = typesDict.objectForKey("Route")! as! String

        cell.textLabel?.text = type
        cell.detailTextLabel?.text = typeDetail
        
        return cell
    }
    
    func setImages(row: Int)->UIImage {
        var image: UIImage!
        
        let bus = factory.createImageForIcon(NIKFontAwesomeIcon.Bus)
        let clock = factory.createImageForIcon(NIKFontAwesomeIcon.ClockO)
        
        image = bus
        
        let type = types[row] as! String
        let typesDict = dict!.objectForKey(type)!
        var primaryLocationTimes = getBusTimes(type, firstTime: true)
        var lastLocationTimes = getBusTimes(type, firstTime: false)
        
        //loop through times and do math
        var elapPrimSeconds: NSTimeInterval!
        var secondsBeforeLast: NSTimeInterval!
        
        
        //        primaryLocationTimes = ["9:00 PM","9:04 PM","9:10 PM","9:15 PM","9:30 PM"]
        //        lastLocationTimes = ["9:30 PM","9:32PM","9:35 PM","9:38 PM","9:40 PM"]
        
        for time in primaryLocationTimes {
            elapPrimSeconds = checkRouteTime(time)
            print(time)
            print(elapPrimSeconds)
            //            elapPrimSeconds = -300
            //if primary start time is more than 1 minute but less than 40
            if elapPrimSeconds < -60 {
                break
            }
        }
        
        for time in lastLocationTimes {
            secondsBeforeLast = checkRouteTime(time)
            print(secondsBeforeLast)
            //            secondsBeforeLast = 500
            //if current time is less than 1 minute before last location start
            if secondsBeforeLast > 60 {
                break
            }
        }
        
        //        if elapPrimSeconds < -60 && secondsBeforeLast > 60 {
        //            cell.imageView?.image = bus
        //        } else {
        //            cell.imageView?.image = clock
        //        }
        
        
        //get the string for the route detail - begin to end
        let typeDetail = typesDict.objectForKey("Route")! as! String
        
        //see if today is a weekend or holiday
        let dayStatus = myDelegate.checkDays()
        //
        //        if dayStatus == "0" {
        //            cell.imageView?.image = bus
        ////            for time in busTimes {
        ////                if myDelegate.compareBusTimes(time) {
        ////                    cell.imageView?.image = bus
        ////                    break
        ////                } else {
        ////                    cell.imageView?.image = clock
        ////                }
        ////            }
        //        } else {
        //            cell.imageView?.image = clock
        //        }
        
        return image
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row > 1 {
//            cell.backgroundColor = UIColor.cyanColor()
        }
        if indexPath.row == 0 || indexPath.row == 1 {
            //heights color
//            cell.backgroundColor = UIColor.greenColor()
//            cell.textLabel?.textColor = UIColor.greenColor()
        } else if indexPath.row == 2 || indexPath.row == 3 {
            //penacook color
//            cell.backgroundColor = UIColor.cyanColor()
        } else {
            //crosstown color
//            cell.backgroundColor = UIColor.grayColor()
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell( sender as! UITableViewCell)!

        var locations = []
        let typesDict:AnyObject = dict.objectForKey(types[indexPath.row])!
        let locationsDict:AnyObject = typesDict.objectForKey("Locations")!

        let locationsForType = locationsDict.allKeys as! [String]
        locations = locationsForType.sort()
        
        let locationsVC = segue.destinationViewController as! LocationTableViewController
        locationsVC.locations = locations as! [String]
        locationsVC.type = types[indexPath.row] as! String
        locationsVC.dict = dict
    }
    

}
