//
//  mainMapViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
import Firebase


class mainMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var experienceBar: UIProgressView!

    @IBOutlet var userLevel: UILabel!
    
    @IBOutlet var healthBar: UIProgressView!
    
    @IBOutlet weak var rechargeAttack: UIProgressView!
   
    
    var questNames: NSMutableArray! = NSMutableArray()
    var latitudes: NSMutableArray! = NSMutableArray()
    var longitudes: NSMutableArray! = NSMutableArray()

    @IBOutlet weak var myMap: MKMapView!

    
    let baseCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    let radius: Double = 850000.0
    
    var locationManager: CLLocationManager! = CLLocationManager()
    
    var messagesRef: Firebase!
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        PFUser.currentUser()?.fetchInBackground()
        
        
        
        var x: Double! = PFUser.currentUser()!.objectForKey("experience") as? Double
        
        println("Grabbed x: \(x)")
        
        var l = (floor(25 + sqrt(625 + (100 * x)) / 50))
        
        println("floor l: \(l)")
        
        userLevel.text = "\(l)"
    

        
        var transform = CGAffineTransformMakeScale(1.0, 11.0)
        experienceBar.transform = transform
        
        var transform2 = CGAffineTransformMakeScale(1.0, 6.0)
        healthBar.transform = transform2
        
        
        var totalL = 25 + sqrt(625 + (100 * x)) / 50
        
        println("total: \(totalL)")
        
        var remL = totalL - l
        
        var levelUpX = (((50 * l - 25) * (50 * l - 25)) - 625) / 100
        
        var ratio = (levelUpX * remL) / levelUpX
        
        experienceBar.progress = Float(ratio)
        healthBar.progress = 100
        
        if PFUser.currentUser()!.objectForKey("ProfilePic") != nil {
            let downloadedImage: UIImage = UIImage(data: PFUser.currentUser()!.objectForKey("ProfilePic")!.getData()!)!
            imageToPost.image = downloadedImage as UIImage
            imageToPost.clipsToBounds = true
            imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
            imageToPost.layer.cornerRadius = imageToPost.frame.height / 2
            
        } else {
            displayAlert("Could not fetch profile picture", message: "You will now be Steve")
        }

        

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tabBarController?.tabBar.hidden = false
        
        messagesRef = Firebase(url: "https://questly.firebaseio.com/quests")
        messagesRef.observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            
            if let questName = snapshot.value.objectForKey("questName") as? String {
                self.questNames.addObject(questName)
                println(questName)
            }
            if let latitude = snapshot.value.objectForKey("userLat") as? NSString {
                self.latitudes.addObject(latitude)
            }
            
            if let longitude = snapshot.value.objectForKey("userLon") as? NSString {
                self.longitudes.addObject(longitude)
            }
            
            var preLon = snapshot.value.objectForKey("userLon") as? NSString
            var lon = preLon?.doubleValue
            var preLat = snapshot.value.objectForKey("userLat") as? NSString
            var lat = preLat?.doubleValue
            
            
            var questName = snapshot.value.objectForKey("questName") as? String
            
            var coord = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            
            var anotation = MKPointAnnotation()
            anotation.coordinate = coord
            anotation.title = "\(questName!)"
            self.myMap.addAnnotation(anotation)
        })

        
    }
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.image = UIImage(named: "Exclamation!")
            } else {
                pinView!.annotation = annotation
        }
        
        return pinView
        
        
        
    }


    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
   
        
        
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
    


    
}
