//
//  SignupViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var usernameField: UITextField!

    @IBOutlet var passwordField: UITextField!
    
    var usernameToSend: String!
    var emailToSend: String!
    var passwordToSend: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToPart2(sender: UIButton) {
        if emailField.text.isEmpty {
            displayAlert("Error", Message: "Please enter an email")
        } else if passwordField.text.isEmpty {
            displayAlert("Error", Message: "Please enter a password")
        } else if usernameField.text.isEmpty {
            displayAlert("Error", Message: "Please enter a username")
        } else {
            emailToSend = emailField.text
            usernameToSend = usernameField.text
            passwordToSend = passwordField.text
            self.performSegueWithIdentifier("signupPart2", sender: self)
        }
    }
    
    func displayAlert(title: String, Message: String) {
        var alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signupPart2" {
            var svc = segue.destinationViewController as! SignupPart2ViewController
            
            svc.username = usernameToSend
            svc.password = passwordToSend
            svc.email = emailToSend
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.emailField.endEditing(true)
        self.passwordField.endEditing(true)
        self.usernameField.endEditing(true)
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        
    }
}
