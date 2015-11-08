//
//  CurrentJobsViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Firebase
import Parse
import MapKit
import CoreLocation

class CurrentJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var myTable: UITableView!
    
    var questNames: NSMutableArray! = NSMutableArray()
    var latitudes: NSMutableArray! = NSMutableArray()
    var longitudes: NSMutableArray! = NSMutableArray()
    var questTypes: NSMutableArray! = NSMutableArray()
    var descriptions: NSMutableArray! = NSMutableArray()
    var rewards: NSMutableArray! = NSMutableArray()
    var timers: NSMutableArray! = NSMutableArray()
    var senders: NSMutableArray! = NSMutableArray()
    var dates: NSMutableArray! = NSMutableArray()
    
    var locationManager = CLLocationManager()
    
    var messagesRef: Firebase!
    
    var questNameToSend: String!
    var descToSend: String!
    var pointsToSend: String!
    var timeToPost: String!
    
    var usernameToSend: String!
    
    var latToSend: NSString!
    var lonToSend: NSString!
    
    var timerToSend: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTable.delegate = self
        myTable.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        questNameToSend = questNames.objectAtIndex(indexPath.row) as? String
        descToSend = descriptions.objectAtIndex(indexPath.row) as? String
        pointsToSend = rewards.objectAtIndex(indexPath.row) as? String
        var date = dates.objectAtIndex(indexPath.row) as? String
        
        println("Date: \(date)")
        
        timerToSend = timers.objectAtIndex(indexPath.row) as? String
        
        var finalDate: String!
        
        if date != nil {
            finalDate = dateDiff(date!)
        }
        
        timeToPost = finalDate
        
        usernameToSend = senders.objectAtIndex(indexPath.row) as? String
        
        latToSend = latitudes.objectAtIndex(indexPath.row) as? NSString
        lonToSend = longitudes.objectAtIndex(indexPath.row) as? NSString
        
        self.performSegueWithIdentifier("moreInfoCtrl", sender: self)
        
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "moreInfoCtrl" {
            var svc = segue.destinationViewController as! MoreInfoViewController
            svc.questName = questNameToSend
            svc.username = usernameToSend
            svc.timePosted = timeToPost
            svc.desc = descToSend
            svc.points = pointsToSend
            svc.lat = latToSend
            svc.lon = lonToSend
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        messagesRef = Firebase(url: "https://questly.firebaseio.com/quests")
        messagesRef.observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            
            if let questName = snapshot.value.objectForKey("questName") as? String {
                self.questNames.addObject(questName)
                println(questName)
            }
            if let latitude = snapshot.value.objectForKey("userLat") as? String {
                self.latitudes.addObject(latitude)
            }
            
            if let longitude = snapshot.value.objectForKey("userLon") as? String {
                self.longitudes.addObject(longitude)
            }
            
            if let questType = snapshot.value.objectForKey("questType") as? String {
                self.questTypes.addObject(questType)
            }
            
            if let descriptionItem = snapshot.value.objectForKey("description") as? String {
                self.descriptions.addObject(descriptionItem)
            }
            
            if let reward = snapshot.value.objectForKey("reward") as? String {
                self.rewards.addObject(reward)
            }
            
            if let timer = snapshot.value.objectForKey("timer") as? String {
                self.timers.addObject(timer)
            }
            if let sender = snapshot.value.objectForKey("sender") as? String {
                self.senders.addObject(sender)
            }
            if let date = snapshot.value.objectForKey("Date") as? String {
                self.dates.addObject(date)
            }
            
            self.myTable.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = myTable.dequeueReusableCellWithIdentifier("questsCell", forIndexPath: indexPath) as! QuestsTableViewCell
        if senders.count > indexPath.row {
            cell.descriptionField.text = descriptions.objectAtIndex(indexPath.row) as? String
            cell.questName.text = questNames.objectAtIndex(indexPath.row) as? String
            cell.prizePoints.text = rewards.objectAtIndex(indexPath.row) as? String
            
            println("descrption: \(descriptions.objectAtIndex(indexPath.row) as? String)")
            println("questName: \(questNames.objectAtIndex(indexPath.row))")
            println("prizePoints: \(rewards.objectAtIndex(indexPath.row))")
            
            var longitudeString = longitudes.objectAtIndex(indexPath.row) as? NSString
            var longitude = longitudeString?.doubleValue
            var latitudeString = latitudes.objectAtIndex(indexPath.row) as? NSString
            var latitude = latitudeString!.doubleValue
            
            println("longitude: \(longitude)")
            var loc2 = CLLocation(latitude: latitude, longitude: longitude!)
            var loc1 = CLLocation(latitude: userLat, longitude: userLon)
            println("loc1: \(loc1)")
            println("loc2: \(loc2)")
            
            var distance = loc2.distanceFromLocation(loc1)
            
            let distanceInKm = distance / 1000
            
            let distanceInMiles = distanceInKm * 0.6
            
            let truncated = round(distanceInMiles)
            
            println(truncated)
            
            cell.distance.text = "\(truncated) miles away"
            
            var date = dates.objectAtIndex(indexPath.row) as? String
            
            println("Date: \(date)")
            
            var finalDate: String!
            
            if date != nil {
                finalDate = dateDiff(date!)
            }
            
            
            
            cell.timePosted.text = "\(finalDate)"

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
    
    var userLat: CLLocationDegrees!
    var userLon: CLLocationDegrees!
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        println("Should grab")
        
        var latitude = userLocation.coordinate.latitude
        
        var longitude = userLocation.coordinate.longitude
        
        userLat = latitude
        userLon = longitude
        
        locationManager.stopUpdatingLocation()
        
    }
    

}
extension NSDate {
    
    func yearsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.YearCalendarUnit, fromDate: date, toDate: self, options: NSCalendarOptions()).year
    }
    func monthsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.MonthCalendarUnit, fromDate: date, toDate: self, options: NSCalendarOptions()).month
    }
    func weeksFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekCalendarUnit, fromDate: date, toDate: self, options: NSCalendarOptions()).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.DayCalendarUnit, fromDate: date, toDate: self, options: NSCalendarOptions()).day
    }
    func hoursFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.HourCalendarUnit, fromDate: date, toDate: self, options: NSCalendarOptions()).hour
    }
    func minutesFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.MinuteCalendarUnit, fromDate: date, toDate: self, options: NSCalendarOptions()).minute
    }
    func secondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.SecondCalendarUnit, fromDate: date, toDate: self, options: NSCalendarOptions()).second
    }
    var relativeTime: String {
        let now = NSDate()
        if now.yearsFrom(self)   > 0 {
            return now.yearsFrom(self).description  + " year"  + { return now.yearsFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.monthsFrom(self)  > 0 {
            return now.monthsFrom(self).description + " month" + { return now.monthsFrom(self)  > 1 ? "s" : "" }() + " ago"
        }
        if now.weeksFrom(self)   > 0 {
            return now.weeksFrom(self).description  + " week"  + { return now.weeksFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.daysFrom(self)    > 0 {
            if now.daysFrom(self) == 1 { return "Yesterday" }
            return now.daysFrom(self).description + " days ago"
        }
        if now.hoursFrom(self)   > 0 {
            return "\(now.hoursFrom(self)) hour"     + { return now.hoursFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.minutesFrom(self) > 0 {
            return "\(now.minutesFrom(self)) minute" + { return now.minutesFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        if now.secondsFrom(self) > 0 {
            if now.secondsFrom(self) < 15 { return "Just now"  }
            return "\(now.secondsFrom(self)) second" + { return now.secondsFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        return ""
    }
}