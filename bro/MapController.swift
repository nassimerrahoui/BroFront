//
//  ViewController.swift
//  bro
//
//  Created by m2sar on 15/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet var searchBarMap: UISearchBar!
    
    let userDefault = UserDefaults.standard
    var pin:Position!
    var position : Position?
    let locationManager = CLLocationManager()
    var myTimer: Timer!
    var user : User?
    
    override func viewDidLoad() {
        searchBarMap.delegate = self
                myMap.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let apiRequest = ApiRequest.init()
        let token = userDefault.string(forKey: "token")
        var annotationsList = [Position]()
        
        let decoded = userDefault.data(forKey: "user")
        if let decoded = decoded{
            user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? User
        }

        if let token = token {
            myTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (Timer) in
                self.myMap.removeAnnotations(annotationsList)
                if let user = self.user {
                    self.position = Position(title: user.username, coordinate: self.myMap.userLocation.coordinate)
                    if let position = self.position{
                        if user.isGeolocalised {
                            apiRequest.sendPosition(token: token, lat: position.coordinate.latitude, lng: position.coordinate.longitude) { (res) -> (Void) in
                                if res == true {
                                }
                            }
                        }
                    }
                }
                apiRequest.getBrosOf(tokenOfUser: token) {(Bros) -> (Void) in
                    if let bros = Bros  {
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: bros)
                        self.userDefault.set(encodedData, forKey : "BrosList")
                        for bro in bros {
                            if bro.isGeolocalised {
                                self.myMap.addAnnotation(bro.position)
                                self.myMap.selectAnnotation(bro.position, animated: true)
                                annotationsList.append(bro.position)
                            }
                        }
                    }
                }
            })
            
            if let user = user {
                
                apiRequest.getLastPostion(username: user.username) { (position) -> (Void) in
                    if let position = position {
                        
                        let center = CLLocationCoordinate2D(latitude: position.coordinate.latitude , longitude: position.coordinate.longitude)
                        let width = 2000.0 // meters
                        let height = 2000.0
                        let region = MKCoordinateRegionMakeWithDistance(center, width, height)
                        self.myMap.setRegion(region, animated: true)
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        myTimer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "meme")
        annotationView.image = UIImage(named: "meme1")
        let transform = CGAffineTransform(scaleX: 0.5, y:0.5)
        annotationView.transform = transform
        return annotationView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarMap.resignFirstResponder()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBarMap.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let placemarks = placemarks {
                    let placemark = placemarks.first
                    let anno = MKPointAnnotation()
                    if let placemark = placemark {
                        if let location = placemark.location{
                            anno.coordinate = location.coordinate
                            anno.title = self.searchBarMap.text!
                            
                            self.myMap.addAnnotation(anno)
                            self.myMap.selectAnnotation(anno, animated: true)
                        }
                    }
                }
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


