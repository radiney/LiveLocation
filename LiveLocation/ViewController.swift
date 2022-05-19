//
//  ViewController.swift
//  LiveLocation
//
//  Created by user217360 on 5/13/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mkMaps: MKMapView!
    @IBOutlet weak var lblAddress: UILabel!
    
    let locationManager = CLLocationManager()
    let distanceMeters : Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationService()
    }
    
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            configLocationManager()
            checkLocationAutorization()
        } else{
            //show alert how to turn on location service in settings
        }
    }
    	
    func configLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mkMaps.delegate = self
    }
    
    func centeralizeMapOnUserLocation() {
           if let currentLocation = locationManager.location?.coordinate {
               let currentRegion = MKCoordinateRegion.init(center: currentLocation, latitudinalMeters: distanceMeters, longitudinalMeters: distanceMeters				)
               mkMaps.setRegion(currentRegion, animated: true)
           }
       }
    
    func  checkLocationAutorization(){
        switch CLLocationManager.authorizationStatus(){
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show alert explaining
            break
        case .denied:
            //show alert how to turn on location service in settings
            break
        case .authorizedAlways:
            //todo
            break
        case .authorizedWhenInUse:
            mkMaps.showsUserLocation = true
            centerMapOnUser()
            break
        }
    }
    
    func getCenterLocation(for mkMaps: MKMapView) -> CLLocation{
        let latitude = mkMaps.centerCoordinate.latitude
        let longtitude = mkMaps.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longtitude)
    }
    
    func centerMapOnUser(){
        if let currentLocation = locationManager.location?.coordinate {
            let currentRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: distanceMeters, longitudinalMeters: distanceMeters)
            mkMaps.setRegion(currentRegion, animated: true)
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {
            return
        }
        let currentRegion = MKCoordinateRegion.init(center: latestLocation.coordinate, latitudinalMeters: distanceMeters, longitudinalMeters: distanceMeters)
        mkMaps.setRegion(currentRegion, animated: true)
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mkMaps)
    }
}
