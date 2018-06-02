//
//  User.swift
//  bro
//
//  Created by m2sar on 25/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation
import MapKit

class User : Bro {
    var firstName, lastName, emailAddress : String
    
    init(firstName : String, lastName : String, username : String, emailAddress : String, isGeolocalised : Bool){
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        super.init(username: firstName, isGeolocalised: isGeolocalised, position: Position.init(title: username, coordinate: CLLocationCoordinate2D.init()))
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(position : Position){
        self.position = position
    }
}
