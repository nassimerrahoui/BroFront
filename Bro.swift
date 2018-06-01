//
//  Bro.swift
//  bro
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation

class Bro {
    let id : String
    var username : String
    var position : Position
    var isGeolocalised : Bool
    
    //    init(id : NSObject, firstName : String, lastName : String, username : String, emailAddress : String, isGeolocalised : Bool){
    init(){
        id = RAND_MAX.bigEndian.description
        username = "Tom Jedusor"
        isGeolocalised = true
        position = Position(title: "", coordinate: <#CLLocationCoordinate2D#>)
    }
}
