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
        super.init(username: username, isGeolocalised: isGeolocalised, position: Position.init(title: username, coordinate: CLLocationCoordinate2D.init()))
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let emailAddress = aDecoder.decodeObject(forKey: "emailAddress") as! String
        let position = aDecoder.decodeObject(forKey: "position") as! Position
        let isGeolocalised = aDecoder.decodeBool(forKey: "isGeolocalised")
        self.init(firstName: firstName, lastName: lastName, username: username, emailAddress: emailAddress, isGeolocalised: isGeolocalised)
        self.set(position: position)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(emailAddress, forKey: "emailAddress")
    }
    
    func set(position : Position){
        self.position = position
    }
}
