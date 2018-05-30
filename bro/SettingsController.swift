//
//  SettingsController.swift
//  bro
//
//  Created by m2sar on 25/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UIViewController {
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //@TODO n'a pas été tester attention
    @IBAction func logOut(_ sender: Any) {
        let token = userDefault.string(forKey: "token")
        let apiRequest = ApiRequest.init()
        let logout = apiRequest.logout(token: token!)
        if logout {
        userDefault.removeObject(forKey: "token")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Loading")
        self.present(nextViewController, animated:false)
        }
    }
}
