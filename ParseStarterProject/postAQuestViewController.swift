//
//  postAQuestViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Firebase
import Parse
import MapKit


class postAQuestViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var questName: UITextField!
    
    @IBOutlet var questType: UITextField!
    
    @IBOutlet var reward: UITextField!
    
    @IBOutlet var timer: UITextField!
    
    @IBOutlet var descriptionField: UITextField!
    
    var messagesRef: Firebase!
    
    var locationManager = CLLocationManager()
    
    var lonToSet: String!
    var latToSet: String!
    
    var Date: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Date = getCurrentShortDate()

        messagesRef = Firebase(url: "https://questly.firebaseio.com/quests")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Full
        
        let components = NSDateComponents()
        components.day = 1
        components.hour = 2
        
        let string = formatter.stringFromDateComponents(components)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getCurrentShortDate() -> String {
        var todaysDate = NSDate()
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        var DateInFormat = dateFormatter.stringFromDate(todaysDate)
        
        return DateInFormat
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        
        var latitude = userLocation.coordinate.latitude
        
        var longitude = userLocation.coordinate.longitude
        
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        
     
        
        
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
                
        self.lonToSet = "\(longitude)"
        self.latToSet = "\(latitude)"
                
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
   
    @IBAction func postToFirebase(sender: UIButton) {
        if !questName.text.isEmpty && !questType.text.isEmpty && !reward.text.isEmpty && !timer.text.isEmpty && !descriptionField.text.isEmpty {
            println("lon: \(lonToSet)")
            println("lat: \(latToSet)")
            println(questName.text)
            let postRef = messagesRef.childByAppendingPath("\(PFUser.currentUser()!.username!): \(questName.text)")
            
            
            let post = ["sender": "\(PFUser.currentUser()!.username!)", "questName": "\(questName.text)", "questType": "\(questType.text)", "reward": "\(reward.text)", "timer": "\(timer.text)", "description": "\(descriptionField.text)", "userLon":lonToSet, "userLat":latToSet, "Date": Date]
            let postRef1 = messagesRef.childByAutoId()
            postRef1.setValue(post)
            questName.text = ""
            questType.text = ""
            reward.text = ""
            timer.text = ""
            descriptionField.text=""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        
        
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        questName.resignFirstResponder()
        questType.resignFirstResponder()
        reward.resignFirstResponder()
        timer.resignFirstResponder()
        descriptionField.resignFirstResponder()
        
    }

}
