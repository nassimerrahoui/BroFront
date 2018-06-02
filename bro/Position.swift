//
//  Position.swift
//  bro
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation
import MapKit

class Position: NSObject, NSCoding, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var pin: Position!
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let latitude = aDecoder.decodeDouble(forKey: "latitude")
        let longitude = aDecoder.decodeDouble(forKey: "longitude")
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(title: title, coordinate: coordinate)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(coordinate.latitude, forKey: "latitude")
        aCoder.encode(coordinate.longitude, forKey: "longitude")
    }
    
    override var description: String { return "[title : \(title)\ncoordinate : \(coordinate)\npin : \(pin)]" }
}
