//
//  userProfileViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class userProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var userLevel: UILabel!
    @IBOutlet var health: UILabel!
    
    @IBOutlet var strength: UILabel!
    
    @IBOutlet var defense: UILabel!
    
    @IBOutlet var magic: UILabel!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var myTable: UITableView!
    
    @IBOutlet var imageToPost: UIImageView!

    @IBOutlet var progressBar: UIProgressView!
    
    var starReview: NSMutableArray! = NSMutableArray()
    var wordReview: NSMutableArray! = NSMutableArray()
    var reviewerNames: NSMutableArray! = NSMutableArray()
    
    var avgRatingToPost: Double!
    
    @IBOutlet var bigstar1: UIImageView!
    @IBOutlet var bigstar2: UIImageView!
    @IBOutlet var bigstar3: UIImageView!
    @IBOutlet var bigstar4: UIImageView!
    @IBOutlet var bigstar5: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFUser.logInWithUsername("flaviolici", password: "flavioeni")
        
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
        
        
    
        
        userLevel.text = "\(l)"
        
        
        
        myTable.delegate = self
        myTable.dataSource = self
        
        PFUser.currentUser()!.fetchInBackground()
        
        username.text = PFUser.currentUser()!.username!
    
        
        
        loadReviews()
        
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
            let downloadedImage: UIImage = UIImage(data: PFUser.currentUser()!.objectForKey("ProfilePic")!.getData()!)!
            imageToPost.image = downloadedImage as UIImage
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviewerNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("miniReviews", forIndexPath: indexPath) as! miniReviewTableViewCell
        
        cell.username.text = reviewerNames.objectAtIndex(indexPath.row) as? String
        cell.review.text = wordReview.objectAtIndex(indexPath.row) as? String
        var rating = starReview.objectAtIndex(indexPath.row) as? Int
        println("rating: \(rating)")
        
        if rating! == 1 {
            cell.star1.alpha = 1
        } else if rating! == 2 {
            cell.star1.alpha = 1
            cell.star2.alpha = 1
        } else if rating! == 3 {
            cell.star1.alpha = 1
            cell.star2.alpha = 1
            cell.star3.alpha = 1
        } else if rating! == 4 {
            cell.star1.alpha = 1
            cell.star2.alpha = 1
            cell.star3.alpha = 1
            cell.star4.alpha = 1
        } else {
            cell.star1.alpha = 1
            cell.star2.alpha = 1
            cell.star3.alpha = 1
            cell.star4.alpha = 1
            cell.star5.alpha = 1
        }
        
        var currentReviewer = reviewerNames.objectAtIndex(indexPath.row) as? String
        
        println("currentReviewer: \(currentReviewer)")
        
        var query = PFUser.query()
        query?.whereKey("username", equalTo: currentReviewer!)
        var object = query?.getFirstObject()
        
        
        
        if object?.objectForKey("ProfilePic") != nil {
            let downloadedImage: UIImage = UIImage(data: object!.objectForKey("ProfilePic")!.getData()!)!
            cell.imageToPost.image = downloadedImage as UIImage
            cell.imageToPost.clipsToBounds = true
            cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
            cell.imageToPost.layer.cornerRadius = imageToPost.frame.height / 2
            
        }
        
        
        return cell
    }
    
    func loadReviews() {
        starReview = PFUser.currentUser()?.objectForKey("reviewNum") as? NSMutableArray
        println("Stars: \(starReview) ")
        wordReview = PFUser.currentUser()?.objectForKey("reviewWords") as? NSMutableArray
        println(wordReview)
        reviewerNames = PFUser.currentUser()?.objectForKey("reviewerNames") as? NSMutableArray
        println(reviewerNames)
        var sum = 0
        for star in starReview {
            sum = sum + Int(star as! NSNumber)
        }
        println("sum: \(sum)")
        
        var avgRating = sum / starReview.count
        avgRatingToPost = round(Double(avgRating))
    }

}
