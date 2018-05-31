//
//  ViewController.swift
//  bro
//
//  Created by m2sar on 15/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet var searchBarMap: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarMap.delegate = self
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarMap.resignFirstResponder()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBarMap.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                
                let placemark = placemarks?.first
                let anno = MKPointAnnotation()
                
                anno.coordinate = (placemark?.location?.coordinate)!
                anno.title = self.searchBarMap.text!
                
                self.myMap.addAnnotation(anno)
                self.myMap.selectAnnotation(anno, animated: true)
                
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
            
    }
}

