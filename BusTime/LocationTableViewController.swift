//
//  ScheduleTableViewController.swift
//  BusTime
//
//  Created by Brian Fleury on 3/6/16.
//  Copyright © 2016 Fleury. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {


    var dict:AnyObject!
    var locationsDict:AnyObject!
    var busTimes: [String]!
    var locations: [String]!
    var type: String!
    var nextBus: String!

    let myDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        let typesDict = dict!.objectForKey(type)!
        locationsDict = typesDict.objectForKey("Locations")!
        
        self.navigationItem.title = type
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath)

        let location = locations[indexPath.row]
        
        var textLabel = location
        //set text color for transfer locations
        var textColor = UIColor.blackColor()
        if location.containsString("State House") || location.containsString("Eagle Square") {
            textColor = UIColor.redColor()
            textLabel = "\(location) - TRANSFER"
        }
        
        cell.textLabel?.textColor = textColor
        cell.textLabel?.text = textLabel

        //set the subtitle text color and detail based on results
        var detailColor = UIColor.blackColor()
        detailColor = getBusTimes(indexPath.row, location: location)
        cell.detailTextLabel?.textColor = detailColor
        let subtitle = "Next bus: \(nextBus)"
        cell.detailTextLabel?.text = subtitle
        
        return cell
    }

    func setTextColorTransferLocation(location: String)->UIColor {
        if location == "State House" || location == "Eagle Square" {
            return UIColor.redColor()
        }
        
        return UIColor.blackColor()
    }
    
    func getBusTimes(row: Int, location: String)->UIColor {
        let timesDict = locationsDict.objectForKey(location)!
        
        busTimes = timesDict as! [String]
        
        //see if today is a weekend or holiday
        let dayStatus = myDelegate.checkDays()
        
        if dayStatus == "0" {
            for time in busTimes {
                if myDelegate.compareBusTimes(time) {
                    nextBus = time
                    break
                } else {
                    //end of run, set to first time in morning
                    nextBus = busTimes[0]
                }
            }
        } else {
            //set the detail text red and show weekend or holiday message
            nextBus = dayStatus
            return UIColor.grayColor()
        }
        
        return UIColor.blackColor()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell( sender as! UITableViewCell)!

        let location = locations[indexPath.row]
        let timesDict = locationsDict.objectForKey(location)!
        
        busTimes = timesDict as! [String]
        
        let locationsVC = segue.destinationViewController as! TimesTableViewController
        locationsVC.type = type
        locationsVC.times = busTimes
        locationsVC.location = locations[indexPath.row]
    }
    

}
