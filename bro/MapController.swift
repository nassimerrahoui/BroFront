//
//  ViewController.swift
//  bro
//
//  Created by m2sar on 15/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude)
        let width = 2000.0 // meters
        let height = 2000.0
        let region = MKCoordinateRegionMakeWithDistance(center, width, height)
        DispatchQueue.main.async {
            self.myMap.setRegion(region , animated: true)
        }
    }
}

