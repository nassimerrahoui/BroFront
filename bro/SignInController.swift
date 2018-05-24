//
//  SignInController.swift
//  bro
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsernameTextField.layer.borderWidth = 1
        UsernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        UsernameTextField.layer.cornerRadius = 10
        PasswordTextField.layer.borderWidth = 1
        PasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
        PasswordTextField.layer.cornerRadius = 10

        UsernameTextField.text = ""
        PasswordTextField.text = ""
        
        UsernameTextField.placeholder = "Username"
        PasswordTextField.placeholder = "Password"
    }
}
