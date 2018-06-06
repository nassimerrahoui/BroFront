//
//  LoadingController.swift
//  bro
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation
import UIKit

class LoadingController: UIViewController {
    
    let userDefault = UserDefaults.standard
    var apiRequest : ApiRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let urlApi = userDefault.string(forKey: "urlApi")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let token = userDefault.string(forKey: "token")
        if let urlApi = urlApi {
            apiRequest = ApiRequest(urlAPI: urlApi)
        } else {
            apiRequest = ApiRequest(urlAPI: "")
        }
            if let token = token, let apiRequest = apiRequest {
                apiRequest.getUser(token: token){(userResponse) -> (Void)
                    in
                    if let userResponse = userResponse {
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: userResponse)
                        self.userDefault.set(encodedData, forKey : "user")
                        
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! UITabBarController
                        self.present(nextViewController, animated:false)
                    } else {
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationConnection") as! UINavigationController
                        self.present(nextViewController, animated:false)
                    }
                }
            } else {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationConnection") as! UINavigationController
                self.present(nextViewController, animated:false)
            }
    }
}


