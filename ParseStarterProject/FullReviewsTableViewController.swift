//
//  FullReviewsTableViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FullReviewsTableViewController: UITableViewController {
    
    var usernames: NSMutableArray! = NSMutableArray()
    var reviewDescriptions: NSMutableArray! = NSMutableArray()
    var ratingNums: NSMutableArray! = NSMutableArray()
    var timesPosted: NSMutableArray! = NSMutableArray()
    
    @IBOutlet weak var numReviews: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numReviews.text = "\(usernames.count) Reviews"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tabBarController?.tabBar.hidden = true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return usernames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewsCell", forIndexPath: indexPath) as! reviewsCellTableViewCell
        var reviewerName = usernames.objectAtIndex(indexPath.row) as? String
        
        cell.reviewerName.text = reviewerName!
        cell.reviewDesc.text = reviewDescriptions.objectAtIndex(indexPath.row) as? String
        var date = timesPosted.objectAtIndex(indexPath.row) as? String
        var finalDate: String!
        
        if date != nil {
            finalDate = dateDiff(date!)
        }
        
        if finalDate != nil {
            cell.timePosted.text = finalDate
        } else {
            cell.timePosted.text = "Nobody knows"
        }
        
        var rating = ratingNums.objectAtIndex(indexPath.row) as? Int
        
        if rating == 1 {
            cell.star1.alpha = 1
        } else if rating == 2 {
            cell.star1.alpha = 1
            cell.star2.alpha = 1
        } else if rating == 3 {
            cell.star1.alpha = 1
            cell.star2.alpha = 1
            cell.star3.alpha = 1
        } else if rating == 4 {
            cell.star1.alpha = 1
            cell.star2.alpha = 1
            cell.star3.alpha = 1
            cell.star4.alpha = 1
        } else if rating == 5 {
            cell.star1.alpha = 1
            cell.star2.alpha = 1
            cell.star3.alpha = 1
            cell.star4.alpha = 1
            cell.star5.alpha = 1
        }
        
        var query = PFUser.query()
        query?.whereKey("username", equalTo: reviewerName!)
        var object = query?.getFirstObject()
        
        if object?.objectForKey("ProfilePic") != nil {
            object!.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    cell.imageToPost.image = downloadedImage
                    cell.imageToPost.clipsToBounds = true
                    cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
                    cell.imageToPost.layer.cornerRadius = cell.imageToPost.frame.height / 2
                    
                }

        })
        }
        
        

        return cell
    }

    func dateDiff(dateStr:String) -> String {
        var f:NSDateFormatter = NSDateFormatter()
        f.timeZone = NSTimeZone.localTimeZone()
        f.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZZZ"
        
        var now = f.stringFromDate(NSDate())
        var startDate = f.dateFromString(dateStr)
        var endDate = f.dateFromString(now)
        var calendar: NSCalendar = NSCalendar.currentCalendar()
        
        let calendarUnits = NSCalendarUnit.CalendarUnitWeekOfMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond
        let dateComponents = calendar.components(calendarUnits, fromDate: startDate!, toDate: endDate!, options: nil)
        
        let weeks = abs(dateComponents.weekOfMonth)
        let days = abs(dateComponents.day)
        let hours = abs(dateComponents.hour)
        let min = abs(dateComponents.minute)
        let sec = abs(dateComponents.second)
        
        var timeAgo = ""
        
        if (sec > 0){
            if (sec > 1) {
                timeAgo = "\(sec) Seconds Ago"
            } else {
                timeAgo = "\(sec) Second Ago"
            }
        }
        
        if (min > 0){
            if (min > 1) {
                timeAgo = "\(min) Minutes Ago"
            } else {
                timeAgo = "\(min) Minute Ago"
            }
        }
        
        if(hours > 0){
            if (hours > 1) {
                timeAgo = "\(hours) Hours Ago"
            } else {
                timeAgo = "\(hours) Hour Ago"
            }
        }
        
        if (days > 0) {
            if (days > 1) {
                timeAgo = "\(days) Days Ago"
            } else {
                timeAgo = "\(days) Day Ago"
            }
        }
        
        if(weeks > 0){
            if (weeks > 1) {
                timeAgo = "\(weeks) Weeks Ago"
            } else {
                timeAgo = "\(weeks) Week Ago"
            }
        }
        
        println("timeAgo is===> \(timeAgo)")
        return timeAgo;
    }


}
