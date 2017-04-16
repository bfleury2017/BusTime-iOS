//
//  InfoTableViewController.swift
//  BusTime
//
//  Created by Brian Fleury on 3/12/16.
//  Copyright © 2016 Fleury. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {

    var infoItems: [String]!
    var dict: AnyObject!
    var infoDict: AnyObject!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Information"

        let infoList = NSBundle.mainBundle().pathForResource("information", ofType: "plist")
        dict = NSDictionary(contentsOfFile: infoList!)
        
        //get the listings
        infoDict = dict!.objectForKey("General")!
        infoItems = (infoDict.allKeys as! [String]).sort()
        
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
        return infoItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("infocell", forIndexPath: indexPath)

        infoItems = (infoDict.allKeys as! [String]).sort()
        
        let infoItem = infoItems[indexPath.row]
        let infotext = infoDict!.objectForKey(infoItem)!
        
        cell.textLabel?.text = infoItem
//        cell.detailTextLabel?.text = test as! String

        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
