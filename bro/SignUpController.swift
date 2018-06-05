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
        
        FirstNameTextField.layer.borderWidth = 1
        FirstNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        FirstNameTextField.layer.cornerRadius = 10
        LastNameTextField.layer.borderWidth = 1
        LastNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        LastNameTextField.layer.cornerRadius = 10
        EmailTextField.layer.borderWidth = 1
        EmailTextField.layer.borderColor = UIColor.lightGray.cgColor
        EmailTextField.layer.cornerRadius = 10
        UsernameTextField.layer.borderWidth = 1
        UsernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        UsernameTextField.layer.cornerRadius = 10
        PasswordTextField.layer.borderWidth = 1
        PasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
        PasswordTextField.layer.cornerRadius = 10
        PasswordConfirmationTextField.layer.borderWidth = 1
        PasswordConfirmationTextField.layer.borderColor = UIColor.lightGray.cgColor
        PasswordConfirmationTextField.layer.cornerRadius = 10
        
        FirstNameTextField.text = ""
        LastNameTextField.text = ""
        EmailTextField.text = ""
        UsernameTextField.text = ""
        PasswordTextField.text = ""
        PasswordConfirmationTextField.text = ""
        
        FirstNameTextField.placeholder = "First name"
        LastNameTextField.placeholder = "Last name"
        EmailTextField.placeholder = "Email address"
        UsernameTextField.placeholder = "Username"
        PasswordTextField.placeholder = "Password"
        PasswordConfirmationTextField.placeholder = "Password Confirmation"
    }
    
    @IBAction func registration(_ sender: Any) {
        let apiRequest = ApiRequest.init()
        if let firstName = FirstNameTextField.text, let lastName = LastNameTextField.text, let username = UsernameTextField.text, let email = EmailTextField.text, let password = PasswordTextField.text {
            apiRequest.registration(
                firstName : firstName,
                lastName : lastName,
                username : username,
                email : email,
                password: password) { (isRegister) -> (Void) in
                    if isRegister {
                        apiRequest.connection(
                            email: email,
                            password: password) { (token) -> (Void) in
                                if let token = token {
                                    let defaults = UserDefaults.standard
                                    defaults.set(token, forKey: "token")

                                    apiRequest.getUser(token: token){(userResponse) -> (Void)
                                        in
                                        if let userResponse = userResponse {
                                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: userResponse)
                                            defaults.set(encodedData, forKey : "user")
                                        }
                                    }
                                    
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! UITabBarController
                                    self.present(nextViewController, animated:true)
                                }
                        }
                    }
            }
        }
    }
}
