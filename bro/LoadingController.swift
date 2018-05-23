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

    @IBOutlet weak var testLabel: UILabel!
    var token : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if ( token != "") {
            testLabel.text = "Token !!!"
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! UITabBarController
            self.present(nextViewController, animated:false)
        } else {
            testLabel.text = "Pas de token! :("
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationConnection") as! UINavigationController
            self.present(nextViewController, animated:false)
        }
        
    }

}
