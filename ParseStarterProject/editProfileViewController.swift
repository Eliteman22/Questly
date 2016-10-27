//
//  editProfileViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class editProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var username: UILabel!
    
    var isPosted: Bool = false
    
    @IBOutlet weak var imageToPost: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = PFUser.currentUser()!.username!

        if PFUser.currentUser()!.objectForKey("ProfilePic") != nil {
            let downloadedImage: UIImage = UIImage(data: PFUser.currentUser()!.objectForKey("ProfilePic")!.getData()!)!
            imageToPost.image = downloadedImage
            imageToPost.clipsToBounds = true
            imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        isPosted = true
        
        if imageToPost.image != nil {
            let imageData = imageToPost.image
            let imageFile: PFFile = PFFile(name: "propic.png", data: UIImageJPEGRepresentation(imageData, 0.8))!
            PFUser.currentUser()?.setObject(imageFile, forKey: "ProfilePic")
            PFUser.currentUser()?.saveInBackground()
            self.displayAlert("Congratulations", message: "Your profile picture has been changed")
        } else {
            self.displayAlert("Error", message: "Could not update profile picture")
        }
        
    }
    
    @IBAction func changePicture(sender: UIButton) {
        var image = UIImagePickerController()
        image.delegate = self
        let alertController = UIAlertController(title: "Where would you like to upload from", message: "Choose: ", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {
            (action) in
            image.sourceType = UIImagePickerControllerSourceType.Camera
            image.allowsEditing = true
            self.presentViewController(image, animated: true, completion: nil)
            
            
        }))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (action) in
            
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = true
            self.presentViewController(image, animated: true, completion: nil) 
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
