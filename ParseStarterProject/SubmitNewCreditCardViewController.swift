//
//  SubmitNewCreditCardViewController.swift
//  Questly
//
//  Created by Flavio Lici on 12/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SubmitNewCreditCardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var cardNumber: UITextField!
    
    @IBOutlet weak var exp: UITextField!
    
    @IBOutlet weak var cvc: UITextField!
    
    @IBOutlet weak var providerName: UILabel!
    
    @IBOutlet weak var myPicker: UIPickerView!
    var creditCards: [String]!
    
    @IBOutlet weak var currentProvider: UILabel!
    
    @IBOutlet weak var currentNumber: UILabel!
    
    @IBOutlet weak var card1View: UIView!
    
    @IBOutlet weak var card2View: UIView!

    @IBOutlet weak var card3View: UIView!
    
    var card1Info: [String]!
    var card2Info: [String]!
    var card3Info: [String]!
    
    var cardsInfo: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPicker.delegate = self
        myPicker.dataSource = self
        email.delegate = self
        cardNumber.delegate = self
        exp.delegate = self
        cvc.delegate = self
        //[EMAIL   CARDNUMBER     EXPERATION      CVC     PROVIDER]
        
        if let card1 = PFUser.currentUser()!.objectForKey("CardNumber1") as? String {
            card1Info = card1.componentsSeparatedByString(",")
            (currentProvider.viewWithTag(0) as! UILabel).text = card1Info[4]
            (currentNumber.viewWithTag(0) as! UILabel).text = card1Info[1]
            UIView.animateWithDuration(0.5, animations: {
                self.card1View.alpha = 1
            })
            
        }
        
        if let card2 = PFUser.currentUser()!.objectForKey("CardNumber2") as? String {
            card2Info = card2.componentsSeparatedByString(",")
            (currentProvider.viewWithTag(1) as! UILabel).text = card2Info[4]
            (currentNumber.viewWithTag(1) as! UILabel).text = card2Info[1]
            
            UIView.animateWithDuration(0.5, animations: {
                self.card2View.alpha = 1
            })
        }
        
        if let card3 = PFUser.currentUser()!.objectForKey("CardNumber3") as? String {
            card3Info = card3.componentsSeparatedByString(",")
            (currentProvider.viewWithTag(2) as! UILabel).text = card3Info[4]
            (currentNumber.viewWithTag(2) as! UILabel).text = card3Info[1]
            
            UIView.animateWithDuration(0.5, animations: {
                self.card3View.alpha = 1
            })
        }

       creditCards = ["Visa", "MasterCard", "American Express", "JCB", "Discover", "Diners Club"]
    }
    
    override func viewWillAppear(animated: Bool) {
        card1View.alpha = 0
        card2View.alpha = 0
        card3View.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        email.resignFirstResponder()
        cardNumber.resignFirstResponder()
        exp.resignFirstResponder()
        cvc.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        email.resignFirstResponder()
        cardNumber.resignFirstResponder()
        exp.resignFirstResponder()
        cvc.resignFirstResponder()
        
        return true
    }
    
    @IBAction func saveInfo(sender: UIButton) {
        if !email.text.isEmpty && !cardNumber.text.isEmpty && !exp.text.isEmpty && !cvc.text.isEmpty && providerName.text != "choose a card provider" {
            var creditCardInfo = "\(email.text),\(cardNumber.text),\(exp.text),\(cvc.text),\(providerName.text)"
            if PFUser.currentUser()?.objectForKey("CardNumber1") == nil {
                PFUser.currentUser()?.setObject(creditCardInfo, forKey: "CardNumber1")
            } else if PFUser.currentUser()?.objectForKey("CardNumber2") == nil {
                PFUser.currentUser()?.setObject(creditCardInfo, forKey: "CardNumber2")
            } else if PFUser.currentUser()?.objectForKey("CardNumber3") == nil {
                PFUser.currentUser()?.setObject(creditCardInfo, forKey: "CardNumber3")
            } else {
                displayAlert("Error", Message: "You have filled all your credit card slots")
            }
        } else {
            displayAlert("Error", Message: "Please fill out the required fields")
        }
    }
    
    func displayAlert(title: String, Message: String) {
        var alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return creditCards.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var provider = creditCards[row]
        providerName.text = provider
        
        return provider
    }
    
    
}
