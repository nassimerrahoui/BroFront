//
//  SignUpController.swift
//  bro
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var PasswordConfirmationTextField: UITextField!
    @IBOutlet weak var BirthDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        FirstNameTextField.text = nil
        LastNameTextField.text = nil
        EmailTextField.text = nil
        UsernameTextField.text = nil
        PasswordTextField.text = nil
        PasswordConfirmationTextField.text = nil

        FirstNameTextField.placeholder = "First name"
        
        LastNameTextField.placeholder = "Last name"
        EmailTextField.placeholder = "Email address"
        UsernameTextField.placeholder = "Username"
        PasswordTextField.placeholder = "Password"
        PasswordConfirmationTextField.placeholder = "Password Confirmation"
        let maxDate: Date = Date()

        BirthDatePicker.datePickerMode = .date
        BirthDatePicker.maximumDate = maxDate
    }
}
