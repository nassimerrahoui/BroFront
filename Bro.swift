//
//  Bro.swift
//  bro
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation
import MapKit

class Bro : NSObject, NSCoding {
    var username : String
    var position : Position
    var isGeolocalised : Bool
    
    init(username : String, isGeolocalised : Bool, position: Position){
        self.username = username
        self.isGeolocalised = isGeolocalised
        self.position = Position(title: username, coordinate: CLLocationCoordinate2D.init())
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let position = aDecoder.decodeObject(forKey: "position") as! Position
        let isGeolocalised = aDecoder.decodeBool(forKey: "isGeolocalised")
        self.init(username: username, isGeolocalised: isGeolocalised, position: position)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(position, forKey: "position")
        aCoder.encode(isGeolocalised, forKey: "isGeolocalised")
    }
    
    override var description: String { return "[username : \(username)\nposition : \(position)\nisGeolocalised : \(isGeolocalised)]" }
}
