//
//  userProfileViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class userProfileViewController: UIViewController {
    
    @IBOutlet var userLevel: UILabel!
    @IBOutlet var health: UILabel!
    
    @IBOutlet var strength: UILabel!
    
    @IBOutlet var defense: UILabel!
    
    @IBOutlet var magic: UILabel!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var myTable: UITableView!
    
    @IBOutlet var imageToPost: UIImageView!

    @IBOutlet var progressBar: UIProgressView!
    
    var reviewTimes: NSMutableArray! = NSMutableArray()
    
    var starReview: NSMutableArray! = NSMutableArray()
    var wordReview: NSMutableArray! = NSMutableArray()
    var reviewerNames: NSMutableArray! = NSMutableArray()
    
    var avgRatingToPost: Double!
    
    @IBOutlet var bigstar1: UIImageView!
    @IBOutlet var bigstar2: UIImageView!
    @IBOutlet var bigstar3: UIImageView!
    @IBOutlet var bigstar4: UIImageView!
    @IBOutlet var bigstar5: UIImageView!
    
    @IBOutlet var firstSmallStar1: UIImageView!
    @IBOutlet var firstSmallStar2: UIImageView!
    @IBOutlet var firstSmallStar3: UIImageView!
    @IBOutlet var firstSmallStar4: UIImageView!
    @IBOutlet var firstSmallStar5: UIImageView!
    
    @IBOutlet var secondSmallStar1: UIImageView!
    @IBOutlet var secondSmallStar2: UIImageView!
    @IBOutlet var secondSmallStar3: UIImageView!
    @IBOutlet var secondSmallStar4: UIImageView!
    @IBOutlet var secondSmallStar5: UIImageView!
    
    @IBOutlet var timePassed1: UILabel!
    @IBOutlet var timePassed2: UILabel!
    
    @IBOutlet var imageToPost1: UIImageView!
    @IBOutlet var imageToPost2: UIImageView!
    
    var finalDate: String!
    var finalDate2: String!
    
    @IBOutlet var username1: UILabel!
    @IBOutlet var username2: UILabel!
    
    @IBOutlet weak var description1: UITextView!
    @IBOutlet weak var description2: UITextView!
    
    @IBOutlet weak var numberOfReviews: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadReviews()
        
    PFUser.currentUser()?.fetchInBackground()
        
        var x: Double! = PFUser.currentUser()!.objectForKey("experience") as? Double
        
        println("Grabbed x: \(x)")
        
        var l = (floor(25 + sqrt(625 + (100 * x)) / 50))
        
        println("floor l: \(l)")
        
        var totalL = 25 + sqrt(625 + (100 * x)) / 50
        
        println("total: \(totalL)")
        
        var remL = totalL - l
        
        var levelUpX = (((50 * l - 25) * (50 * l - 25)) - 625) / 100
        
        var ratio = (levelUpX * remL) / levelUpX
        
        println("ratio: \(ratio)")
        
        progressBar.progress = Float(ratio)
        
        if let reviews = PFUser.currentUser()!.objectForKey("reviewNum") as? [Int] {
            numberOfReviews.text = "\(reviews.count) Reviews"
        }
        
        if PFUser.currentUser()!.objectForKey("reviewNum") != nil {
            var reviewRatings = PFUser.currentUser()!.objectForKey("reviewNum") as! [Int]
            var reviewWords = PFUser.currentUser()!.objectForKey("reviewWords") as! [String]
            var reviewerNames = PFUser.currentUser()!.objectForKey("reviewerNames") as! [String]
            
            if reviewRatings.count > 1 {
                username1.text = reviewerNames[0]
            }
        } else {
            
        }
        
        var user1 = reviewerNames.objectAtIndex(0) as? String
        var user2 = reviewerNames.objectAtIndex(1) as? String
        
        username1.text = user1!
        username2.text = user2!
        
        description1.text = wordReview.objectAtIndex(0) as? String
        description2.text = wordReview.objectAtIndex(1) as? String
        
        var starRating1 = starReview.objectAtIndex(0) as? Int
        var starRating2 = starReview.objectAtIndex(1) as? Int
        
        if starRating1 == 1 {
            firstSmallStar1.alpha = 1
        } else if starRating1 == 2 {
            firstSmallStar1.alpha = 1
            firstSmallStar2.alpha = 1
        } else if starRating1 == 3 {
            firstSmallStar1.alpha = 1
            firstSmallStar2.alpha = 1
            firstSmallStar3.alpha = 1
        } else if starRating1 == 4 {
            firstSmallStar1.alpha = 1
            firstSmallStar2.alpha = 1
            firstSmallStar3.alpha = 1
            firstSmallStar4.alpha = 1
        } else if starRating1 == 5 {
            firstSmallStar1.alpha = 1
            firstSmallStar2.alpha = 1
            firstSmallStar3.alpha = 1
            firstSmallStar4.alpha = 1
            firstSmallStar5.alpha = 1
        }
        
        if starRating2 == 1 {
            secondSmallStar1.alpha = 1
        } else if starRating2 == 2 {
            secondSmallStar1.alpha = 1
            secondSmallStar2.alpha = 1
        } else if starRating2 == 3 {
            secondSmallStar1.alpha = 1
            secondSmallStar2.alpha = 1
            secondSmallStar3.alpha = 1
        } else if starRating2 == 4 {
            secondSmallStar1.alpha = 1
            secondSmallStar2.alpha = 1
            secondSmallStar3.alpha = 1
            secondSmallStar4.alpha = 1
        } else if starRating2 == 5 {
            secondSmallStar1.alpha = 1
            secondSmallStar2.alpha = 1
            secondSmallStar3.alpha = 1
            secondSmallStar4.alpha = 1
            secondSmallStar5.alpha = 1
        }
        
        var userQuery = PFUser.query()
        userQuery?.whereKey("username", equalTo: user1!)
        var userObject1 = userQuery?.getFirstObject()
        
        if userObject1?.objectForKey("ProfilePic") != nil {
            userObject1!.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    self.imageToPost1.image = downloadedImage
                    self.imageToPost1.clipsToBounds = true
                    self.imageToPost1.contentMode = UIViewContentMode.ScaleAspectFill
                    self.imageToPost1.layer.cornerRadius = self.imageToPost.frame.height / 2
                    
                }
                
            })
        }
        
        
        
        userQuery?.whereKey("username", equalTo: user2!)
        var userObject2 = userQuery?.getFirstObject()
        
        if userObject2?.objectForKey("ProfilePic") != nil {
            userObject2!.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    self.imageToPost2.image = downloadedImage
                    self.imageToPost2.clipsToBounds = true
                    self.imageToPost2.contentMode = UIViewContentMode.ScaleAspectFill
                    self.imageToPost2.layer.cornerRadius = self.imageToPost2.frame.height / 2
                    
                }

        })
    }
        
        userLevel.text = "\(l)"
        
        
        
        PFUser.currentUser()!.fetchInBackground()
        
        username.text = PFUser.currentUser()!.username!
        
        println("Still Working")
        
        var healthLevel = PFUser.currentUser()?.objectForKey("healthLevel") as? Int
        health.text = "\(healthLevel!)"
        
        println("Health worked")
        
        var strengthLevel = PFUser.currentUser()?.objectForKey("strengthLevel") as? Int
        strength.text = "\(strengthLevel!)"
        
        println("StrengthWorked")
        
        var defenseLevel = PFUser.currentUser()?.objectForKey("defenseLevel") as? Int
        
        defense.text = "\(defenseLevel!)"
        
        println("Defense worked")
        
        var magicLevel = PFUser.currentUser()?.objectForKey("defenseLevel") as? Int
        magic.text = "\(magicLevel!)"
        
        println("magic worked")
        
        if avgRatingToPost == 1 {
            bigstar1.alpha = 1
        } else if avgRatingToPost == 2 {
            bigstar1.alpha = 1
            bigstar2.alpha = 1
        } else if avgRatingToPost == 3 {
            bigstar1.alpha = 1
            bigstar2.alpha = 1
            bigstar3.alpha = 1
        } else if avgRatingToPost == 4 {
            bigstar1.alpha = 1
            bigstar2.alpha = 1
            bigstar3.alpha = 1
            bigstar4.alpha = 1
        } else if avgRatingToPost == 5 {
            bigstar1.alpha = 1
            bigstar2.alpha = 1
            bigstar3.alpha = 1
            bigstar4.alpha = 1
            bigstar5.alpha = 1
        }
        
        if PFUser.currentUser()!.objectForKey("ProfilePic") != nil {
            userObject1!.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    self.imageToPost.image = downloadedImage
                    
                }
            })

            imageToPost.clipsToBounds = true
            imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
            imageToPost.layer.cornerRadius = imageToPost.frame.height / 2
            
        } else {
            displayAlert("Could not fetch profile picture", message: "You will now be Steve")
        }
        


        
        println("image worked")
        
        var transform = CGAffineTransformMakeScale(1.0, 11.0)
        progressBar.transform = transform
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func loadReviews() {
        starReview = PFUser.currentUser()?.objectForKey("reviewNum") as? NSMutableArray
        println("Stars: \(starReview) ")
        wordReview = PFUser.currentUser()?.objectForKey("reviewWords") as? NSMutableArray
        println(wordReview)
        reviewerNames = PFUser.currentUser()?.objectForKey("reviewerNames") as? NSMutableArray
        reviewTimes = PFUser.currentUser()!.objectForKey("ReviewTimes") as? NSMutableArray
        println(reviewerNames)
        var sum = 0
        for star in starReview {
            sum = sum + Int(star as! NSNumber)
        }
        println("sum: \(sum)")
        
        var avgRating = sum / starReview.count
        avgRatingToPost = round(Double(avgRating))
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tabBarController?.tabBar.hidden = false
        
        loadReviews()
        
        var date1 = reviewTimes.objectAtIndex(0) as? String
        
        var date2 = reviewTimes.objectAtIndex(1) as? String
        
        if date1 != nil {
            finalDate = dateDiff(date1!)
        }
        
        if date2 != nil {
            finalDate2 = dateDiff(date2!)
        }
        
        timePassed1.text = finalDate
        timePassed2.text = finalDate2
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFullReviews" {
            var svc = segue.destinationViewController as! FullReviewsTableViewController
            
            svc.usernames = reviewerNames
            svc.reviewDescriptions = wordReview
            svc.ratingNums = starReview
            svc.timesPosted = reviewTimes
        }
    }
    

}
