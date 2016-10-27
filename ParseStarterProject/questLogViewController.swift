//
//  questLogViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/25/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class questLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questsTaken: UITableView!
    

    @IBOutlet weak var questsGiven: UITableView!
    
    @IBOutlet weak var questsCompleted: UITableView!
    
    var takenData: NSMutableArray! = NSMutableArray()
    var givenData: NSMutableArray! = NSMutableArray()
    var completedData: NSMutableArray! = NSMutableArray()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questsTaken.delegate = self
        questsTaken.dataSource = self
        questsGiven.delegate = self
        questsGiven.dataSource = self
        questsCompleted.delegate = self
        questsCompleted.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell1: questTakenCellTableViewCell!
        var cell2: questGivenCellTableViewCell!
        var cell3: questsCompletedCellTableViewCell!
        
        if tableView == questsTaken {
             cell1 = questsTaken.dequeueReusableCellWithIdentifier("takenCell", forIndexPath: indexPath) as! questTakenCellTableViewCell
            
            return cell1
            
        } else if tableView == questsGiven {
             cell2 = questsGiven.dequeueReusableCellWithIdentifier("givenCell", forIndexPath: indexPath) as! questGivenCellTableViewCell
            return cell2
        } else {
             cell3 = questsCompleted.dequeueReusableCellWithIdentifier("completedCell", forIndexPath: indexPath) as! questsCompletedCellTableViewCell
            var completedDic = completedData.objectAtIndex(indexPath.row) as? NSString
            var completedArray = completedDic?.componentsSeparatedByString(":") as! [String]
            cell3.questName.text = completedArray[0] as String
            var time = completedArray[2] as String
            var timeDiff = dateDiff(time)
            cell3.timePassed.text = timeDiff
            cell3.completedLabel.text = completedArray[3] as String
            return cell3
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == questsTaken {
            if takenData.count > 0 {
                return takenData.count
            } else {
                return 0
            }
        } else if tableView == questsGiven {
            if givenData.count > 0 {
                return givenData.count
            } else {
                return 0
            }
        } else if tableView == questsCompleted {
            if completedData.count > 0 {
                return completedData.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    
    
    func displayError() {
        
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
