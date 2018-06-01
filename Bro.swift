//
//  Bro.swift
//  bro
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation
import MapKit

class Bro {
    var username : String
    var position : Position
    var isGeolocalised : Bool
    
    init(username : String, isGeolocalised : Bool, position: Position){
        self.username = "Tom Jedusor"
        self.isGeolocalised = true
        self.position = Position(title: username, coordinate: CLLocationCoordinate2D.init())
    }
    
    init(){
        username = "Tom Jedusor"
        isGeolocalised = true
        position = Position(title: username, coordinate: CLLocationCoordinate2D.init())
    }
}
