//
//  TimesTableViewController.swift
//  BusTime
//
//  Created by Brian Fleury on 3/6/16.
//  Copyright © 2016 Fleury. All rights reserved.
//

import UIKit

class TimesTableViewController: UITableViewController {

    var times: [String]!
    var type: String!
    var location: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var title = location
        let midRange = title.startIndex.advancedBy(0)...title.startIndex.advancedBy(3)
        title.removeRange(midRange)
        
        self.navigationItem.title = title
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return times.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimesCell", forIndexPath: indexPath)

        let color = setColors(indexPath.row)
        cell.backgroundColor = color

        cell.textLabel?.text = times[indexPath.row]
//        cell.detailTextLabel?.text = "Subtitle"

        return cell
    }

    func setColors(row: Int)->UIColor {

        let lightBrown = UIColor(red: 249, green: 234, blue: 202)
        let lightGreen = UIColor(red: 216, green: 234, blue: 209)
        let lightBlue = UIColor(red: 209, green: 220, blue: 244)

        let lightPurple = UIColor(red: 251, green: 191, blue: 218)
        let aqua = UIColor(red: 181, green: 229, blue: 237)
        
        var color = UIColor.whiteColor()
        //set even rows background color based on type
        if row % 2 == 0 {
            if type.containsString("Crosstown") {
                color = lightBrown
            } else if type.containsString("Heights"){
                color = lightGreen
            } else if type.containsString("Penacook"){
                color = lightBlue
            }
        }
        
        //set cell background color for breaks (purple) and shift change (aqua)
        if location.containsString("State House") {
            if type.containsString("Heights") && row == 8{
                color = lightPurple
            } else if !type.containsString("Heights") {
                if row == 3 || row == 8 {
                    color = lightPurple
                }
            }
        } else if location.containsString("Eagle Square") {
            if type.containsString("Heights") {
                if row == 2 {
                    color = lightPurple
                } else if row == 5 {
                    color = aqua
                }
            } else if !type.containsString("Heights") {
                if row == 5 {
                    color = aqua
                }
            }
        }
        
        return color
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
