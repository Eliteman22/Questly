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

class MoreInfoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
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
    
    var level: Double!
    
    var locationManager: CLLocationManager! = CLLocationManager()
    
    var avgRatingToPost: Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var x: Double! = PFUser.currentUser()!.objectForKey("experience") as? Double
        
        println("Grabbed x: \(x)")
        
        level = (floor(25 + sqrt(625 + (100 * x)) / 50))
        
        println("lat: \(lat), lon: \(lon)")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        println("THE CONTROLLER LOADED")
        
        loadReviews()
        
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
        
        println("Almost done")
        timeField.text = timePosted
        questFIeld.text = questName
        DescField.text = desc
        pointsField.text = points
        println("Done")

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptQuest(sender: UIButton) {
        var questExists = false
        var levelWorks = true
        var questArray = PFUser.currentUser()!.objectForKey("CurrentQuests") as? [String]
        if !(questArray!.isEmpty) {
            for quest in questArray! {
                if quest == questName {
                    questExists = true
                }
            }
        }
        if questExists == true {
            var alert = UIAlertController(title: "Error", message: "You have already embarked on this quest", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        else if questArray?.count > Int(level) {
            var alert = UIAlertController(title: "Error", message: "You are not a high enough level to accept this quest", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Alert", message: "Are you sure you want to accept \(questName) for \(points) points?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
                (action) in
                var currentUser = PFUser.currentUser()!.username!
                let questsGiven = ["\(self.questName):\(currentUser)"]
                let activeQuest = ["\(self.questName):\(self.username)"]
                
    
                var query = PFQuery(className: "userQuests")
                query.whereKey("username", equalTo: self.username)
                var object = query.getFirstObject()
                object?.setObject(questsGiven, forKey: "questsGiven")
                
                var query2 = PFQuery(className: "activeQuest")
                query.whereKey("username", equalTo: activeQuest)
                
                
                
                self.performSegueWithIdentifier("questAccepted", sender: self)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
       
        
        let center = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: lon.doubleValue)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        let location = CLLocation(latitude: lat.doubleValue, longitude: lon.doubleValue)
        
        self.myMap.setRegion(region, animated: false)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) -> Void in
            
            if error == nil {
                if placemarks.count > 0 {
                    let pm: CLPlacemark = placemarks[0] as! CLPlacemark
                    self.myMap.showsUserLocation = true
                    let placemark = MKPointAnnotation()
                    placemark.coordinate = center
                    placemark.title = self.questName
                    placemark.subtitle = pm.locality
                    self.myMap.addAnnotation(placemark)
                }
            }
        })
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "questAccepted" {
            var svc = segue.destinationViewController as! ChatViewController
            svc.user1 = PFUser.currentUser()!.username!
            svc.user2 = username!
        }
    }
    

}
