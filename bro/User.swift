//
//  User.swift
//  bro
//
//  Created by m2sar on 25/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation

class User : Bro {
    var firstName, lastName, emailAddress : String
    
    init(id : String, firstName : String, lastName : String, username : String, emailAddress : String, isGeolocalised : Bool){
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        super.init()
    }
    
    func set(position : Position){
        self.position = position
    }
}
