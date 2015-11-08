//
//  MoreInfoViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MoreInfoViewController: UIViewController, MKMapViewDelegate {
    
    var questName: String!
    
    var username: String!
    
    var timePosted: String!
    
    var desc: String!
    
    var points: String!
    
    var lat: NSString!
    
    var lon: NSString!
    
    var timer: String!
    
    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet var star1: UIImageView!

    @IBOutlet var star3: UIImageView!
    @IBOutlet var star2: UIImageView!
    
    @IBOutlet var star4: UIImageView!
    
    @IBOutlet var star5: UIImageView!
    
    @IBOutlet var questFIeld: UILabel!
    
    @IBOutlet var timeField: UILabel!
    
    @IBOutlet var DescField: UITextView!
    
    @IBOutlet var pointsField: UILabel!
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var usernameField: UILabel!
    
    var avgRatingToPost: Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if avgRatingToPost == 1 {
            star1.alpha = 1
        } else if avgRatingToPost == 2 {
            star1.alpha = 1
            star2.alpha = 1
        } else if avgRatingToPost == 3 {
            star1.alpha = 1
            star2.alpha = 1
            star3.alpha = 1
        } else if avgRatingToPost == 4 {
            star1.alpha = 1
            star2.alpha = 1
            star3.alpha = 1
            star4.alpha = 1
        } else if avgRatingToPost == 5 {
            star1.alpha = 1
            star2.alpha = 1
            star3.alpha = 1
            star4.alpha = 1
            star5.alpha = 1
        }
        
        usernameField.text = username
        
        var query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        var object = query?.getFirstObject()
        
        if object!.objectForKey("ProfilePic") != nil {
            let downloadedImage: UIImage = UIImage(data: object!.objectForKey("ProfilePic")!.getData()!)!
            imageToPost.image = downloadedImage as UIImage
            imageToPost.clipsToBounds = true
            imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
            imageToPost.layer.cornerRadius = imageToPost.frame.height / 2
            
        }
        
        
        timeField.text = timePosted
        questFIeld.text = questName
        DescField.text = desc
        pointsField.text = points
        

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptQuest(sender: UIButton) {
        
    }
    
    func loadReviews() {
        var starReview = PFUser.currentUser()?.objectForKey("reviewNum") as? NSMutableArray
        var sum = 0
        for star in starReview! {
            sum = sum + Int(star as! NSNumber)
        }
        println("sum: \(sum)")
        
        var avgRating = sum / starReview!.count
        avgRatingToPost = round(Double(avgRating))
    }
    
    

}
