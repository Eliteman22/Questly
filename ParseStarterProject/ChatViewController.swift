//
//  ChatViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Firebase
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var messageField: UITextField!
    
    @IBOutlet var myTable: UITableView!

    @IBOutlet var chatName: UILabel!
    
    var user1: String!
    var user2: String!
    
    var usernames: NSMutableArray! = NSMutableArray()
    var messages: NSMutableArray! = NSMutableArray()
    var images: NSMutableArray! = NSMutableArray()
    
    var seller: String!
    
    var messagesRef: Firebase!
    
    var imageToPost: UIImage!
    
    var base64String: NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTable.delegate = self
        myTable.dataSource = self
        
        chatName.text = "\(user1) and \(user2)"
        messagesRef = Firebase(url: "https://questly.firebaseio.com/chats/\(user1)+\(user2)")
        messagesRef.observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            
            if let sender = snapshot.value.objectForKey("sender") as? String {
                self.usernames.addObject(sender)
            }
            if let text = snapshot.value.objectForKey("text") as? String {
                self.messages.addObject(text)
            }
            
            if let image = snapshot.value.objectForKey("picture") as? String {
                var decodedData = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions())
                var decodedImage = UIImage(data: decodedData!)
                self.images.addObject(decodedImage!)
            }
            self.myTable.reloadData()
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCellWithIdentifier("messagesCell", forIndexPath: indexPath) as! MessageTableViewCell
        
        cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
        cell.imageToPost.clipsToBounds = true
        cell.imageToPost.layer.cornerRadius = cell.imageToPost.layer.frame.height / 2
        
        cell.usernameToPost.text = usernames.objectAtIndex(indexPath.row) as? String
        cell.messageToPost.text = messages.objectAtIndex(indexPath.row) as? String
        cell.imageToPost.image = images.objectAtIndex(indexPath.row) as? UIImage
        
        
        return cell
        
        
    }
    
    @IBAction func submitMessage(sender: UIButton) {
        if !messageField.text.isEmpty {
            let postRef = messagesRef.childByAppendingPath("ENTER QUEST NAME HERE BRO")
            
            if PFUser.currentUser()!.objectForKey("Pic") != nil {
                let downloadedImage: UIImage = UIImage(data: PFUser.currentUser()!.objectForKey("Pic")!.getData()!)!
                imageToPost = downloadedImage
                
                var imageData: NSData = UIImagePNGRepresentation(imageToPost)
                base64String = imageData.base64EncodedStringWithOptions(.allZeros)
                
                let post = ["sender": "\(PFUser.currentUser()!.username!)", "text":"\(messageField.text)", "picture":"\(base64String)"]
                let postRef = messagesRef.childByAutoId()
                postRef.setValue(post)
                messageField.text = ""
                
            }
            
            let numberOfSections = self.myTable.numberOfSections()
            let numberOfRows = self.myTable.numberOfRowsInSection(numberOfSections - 1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: numberOfSections-1)
                self.myTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.moveView(notification.userInfo!, up: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.moveView(notification.userInfo!, up: false)
    }
    
    func moveView(userInfo: NSDictionary, up: Bool) {
        var keyboardEndFrame: CGRect = CGRect()
        userInfo[UIKeyboardFrameEndUserInfoKey]!.getValue(&keyboardEndFrame)
        
        var animationCurve: UIViewAnimationCurve = UIViewAnimationCurve.EaseOut
        userInfo[UIKeyboardAnimationCurveUserInfoKey]!.getValue(&animationCurve)
        
        var animationDuration: NSTimeInterval = NSTimeInterval()
        userInfo[UIKeyboardAnimationDurationUserInfoKey]!.getValue(&animationDuration)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        var keyboardFrame: CGRect = self.view.convertRect(keyboardEndFrame, toView: nil)
        var y = keyboardFrame.size.height * (up ? -1 : 1)
        self.view.frame = CGRectOffset(self.view.frame, 0, y)
        
        UIView.commitAnimations()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    

}
