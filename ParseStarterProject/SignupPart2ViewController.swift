//
//  SignupPart2ViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class SignupPart2ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var username: String!
    
    var password: String!
    
    var email: String!

    @IBOutlet var dateOfBirthField: UITextField!
    
    @IBOutlet var myPicker: UIPickerView!
    
    @IBOutlet var location: UITextField!
    
    var locationToSet: String!
    
    var locationManager = CLLocationManager()
    
    
    let pickerData = ["2000", "1999", "1998", "1997", "1996", "1995", "1994", "1993", "1992", "1991", "1990", "1989", "1988", "1987", "1986", "1985", "1984", "1983", "1982", "1981", "1980", "1979", "1978", "1977", "1976", "1975", "1974", "1973", "1972", "1971", "1970"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPicker.dataSource = self
        myPicker.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(pickerData[row])
        return pickerData[row]
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        
        var latitude = userLocation.coordinate.latitude
        
        var longitude = userLocation.coordinate.longitude
        
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        
        var course = userLocation.course
        
        var speed = userLocation.speed
        
        
        
        var altitude = userLocation.altitude
        
        
        
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation, completionHandler:  {
            placemarks, error in
            
            if error == nil && placemarks.count > 0 {
                var placemark = (placemarks.last as? CLPlacemark)!
                
                self.locationToSet = "\(placemark.locality)"
                println("\(placemark.locality)")
                
                self.locationManager.stopUpdatingLocation()
            }
        })
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateOfBirthField.text = "DOB: \(pickerData[row])"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signup(sender: UIButton) {
        var user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        if !dateOfBirthField.text.isEmpty{
            user.setObject(dateOfBirthField.text, forKey: "yob")
        }
        
        if !location.text.isEmpty {
            user.setObject(locationToSet, forKey: "location")
        }
       var userObj = PFObject(className: "Chats")
        userObj.setObject(username, forKey: "username")
        userObj.saveInBackground()
        
        
        myPicker.dataSource = self
        myPicker.delegate = self
        
        user.signUpInBackgroundWithBlock({
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                self.displayAlert("Error", Message: "There was an error signing up, please try again")
            } else {
                self.performSegueWithIdentifier("signupToMain", sender: self)
            }
        })
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    
    func displayAlert(title: String, Message: String) {
        var alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func useCurrentLocation(sender: UIButton) {
        if locationToSet != nil {
            location.text = locationToSet
        } else {
            location.text = "Swagtown"
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        dateOfBirthField.resignFirstResponder()
        location.resignFirstResponder()
        
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.dateOfBirthField.endEditing(true)
        self.location.endEditing(true)
        
        dateOfBirthField.resignFirstResponder()
        location.resignFirstResponder()
        
    }

    

}
