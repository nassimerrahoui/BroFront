//
//  SettingsTableViewController.swift
//  bro
//
//  Created by m2sar on 04/06/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let userDefault = UserDefaults.standard
    let apiRequest = ApiRequest.init()
    var token :String?
    

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var geolocation: UISwitch!
    @IBOutlet weak var logout: UIButton!
    @IBAction func logout(_ sender: Any) {
        let token = userDefault.string(forKey: "token")
        let apiRequest = ApiRequest.init()
        apiRequest.logout(token: token!) { (isLogout) -> (Void)
            in
            if isLogout {
                self.userDefault.removeObject(forKey: "token")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Loading")
                self.present(nextViewController, animated:false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = userDefault.string(forKey: "token")
        apiRequest.getUser(token: token!){(userResponse) -> (Void) in
            if userResponse != nil {
                self.username.text?.append((userResponse?.username)!)
                self.firstName.text?.append((userResponse?.firstName)!)
                self.lastName.text?.append((userResponse?.lastName)!)
                self.email.text?.append((userResponse?.emailAddress)!)
                self.geolocation.setOn((userResponse?.isGeolocalised)!, animated: false)
            }
        }
        self.username.isUserInteractionEnabled = false
        self.firstName.isUserInteractionEnabled = false
        self.lastName.isUserInteractionEnabled = false
        self.email.isUserInteractionEnabled = false
        self.password.isUserInteractionEnabled = false
        self.geolocation.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsTableViewController.editButtonPressed))
    }
    
    func editButtonPressed(){
        if !username.isEditing && !email.isEditing && !password.isEditing {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SettingsTableViewController.editButtonPressed))
            
            username.isUserInteractionEnabled = true
            email.isUserInteractionEnabled = true
            password.isUserInteractionEnabled = true
            geolocation.isEnabled = true
            
            logout.isEnabled = false
            
        }
        else if !(username.text?.isEmpty)! && !(email.text?.isEmpty)! && !(firstName.text?.isEmpty)! && !(lastName.text?.isEmpty)! {
            apiRequest.updateSettings(token: token!, localizable: geolocation.isOn, firstName: firstName.text!, lastName: lastName.text!, username: username.text!, email: email.text!, password: password.text) { (res) -> (Void) in
                if res {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsTableViewController.editButtonPressed))
                    
                    self.username.isUserInteractionEnabled = false
                    self.email.isUserInteractionEnabled = false
                    self.password.isUserInteractionEnabled = false
                    self.geolocation.isEnabled = false
                    
                    self.logout.isEnabled = true

                }
            }
            
        }
    }
}

