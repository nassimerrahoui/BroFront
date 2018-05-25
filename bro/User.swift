//
//  User.swift
//  bro
//
//  Created by m2sar on 25/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation

class User {
    let id : NSObject
    var firstName, lastName, username, emailAddress : String
    var isGeolocalised : Bool
    
    init(id : NSObject, firstName : String, lastName : String, username : String, emailAddress : String, isGeolocalised : Bool){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.username = username
        self.isGeolocalised = isGeolocalised
    }
}
