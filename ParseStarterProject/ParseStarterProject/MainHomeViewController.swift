//
//  MainHomeViewController.swift
//  Questly
//
//  Created by Flavio Lici on 11/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class MainHomeViewController: UIViewController {

    @IBOutlet var midButton: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        midButton.constant = self.view.frame.width / 2

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    

}
