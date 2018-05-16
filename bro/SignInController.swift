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
        UsernameTextField.text = nil
        PasswordTextField.text = nil
        
        UsernameTextField.placeholder = "Username"
        PasswordTextField.placeholder = "Password"
    }
}
