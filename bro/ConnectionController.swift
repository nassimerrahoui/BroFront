//
//  HomeController.swift
//  bro
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class ConnectionController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func updateUrlApi(_ sender: UITextField) {
        UserDefaults.standard.set(sender.text, forKey: "urlApi")
    }
    
    override func viewDidLoad() {
        signInButton.layer.cornerRadius = 10
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.lightGray.cgColor
  
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.lightGray.cgColor
        super.viewDidLoad()
    }
    
}
