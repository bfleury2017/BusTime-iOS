//
//  AllTypesTableViewController.swift
//  BusTime
//
//  Created by Brian Fleury on 3/12/16.
//  Copyright © 2016 Fleury. All rights reserved.
//

import UIKit

class AllTypesTableViewController: UITableViewController {

    var dict:AnyObject!
    var types:AnyObject!
    var factory:NIKFontAwesomeIconFactory!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "All Stops"

        let buslist = NSBundle.mainBundle().pathForResource("buslist", ofType: "plist")
        dict = NSDictionary(contentsOfFile: buslist!)
        
        //get the listing of bus types
        types = (dict.allKeys as! [String]).sort()
        
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return types.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("allstopsCell", forIndexPath: indexPath)

        //set colors for type icons
        setFactoryColor(indexPath.row)
        let image = setImages(indexPath.row)
        cell.imageView?.image = image

        //get the string for the route detail - begin to end
        let type = types[indexPath.row] as! String
        let typesDict = dict!.objectForKey(type)!
        let typeDetail = typesDict.objectForKey("Route")! as! String
        
        cell.textLabel?.text = type
        cell.detailTextLabel?.text = typeDetail
        
        return cell
    }
    
    func setImages(row: Int)->UIImage {
        var image: UIImage!
        let mapMarker = factory.createImageForIcon(NIKFontAwesomeIcon.MapMarker)
        
        image = mapMarker
        return image
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
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell( sender as! UITableViewCell)!
        
        let typesDict:AnyObject = dict.objectForKey(types[indexPath.row])!
        let locations = typesDict.objectForKey("AllLocations")! as! [String]
        
        let locationsVC = segue.destinationViewController as! AllLocationsTableViewController
        locationsVC.locations = locations
        locationsVC.type = types[indexPath.row] as! String
        locationsVC.dict = dict
    }


}
