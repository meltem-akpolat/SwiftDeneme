//
//  VCHarita.swift
//  DropDown
//
//  Created by easistem on 14.07.2017.
//  Copyright © 2017 meltem akpolat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VCHarita: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var currentLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lokasyonKontrolu()
    }
    
    func lokasyonKontrolu() {
        
        // Lokasyon servislerini kontrol et..
        if (CLLocationManager.locationServicesEnabled()) {
            manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
        }
      
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = manager.location!
           
            let coordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            let span = MKCoordinateSpanMake(0.003, 0.003)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated:true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "title"
            annotation.subtitle = "subtitle"
            self.mapView.addAnnotation(annotation)
            
        }
        
        DispatchQueue.main.async {
            self.manager.startUpdatingLocation()
        }
    }
    
    // MKMapView Delegate
  
    // Annotation eklendiğinde çağrılır
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.isDraggable = true
            
            let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }

    // Pini hareket ettirdiğimiz bölgenin lokasyon verilerini alma..
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.ending {
            let droppedAt = view.annotation?.coordinate
            
            print("Lokasyon Verileri: \(droppedAt!)")
        }
    }
}
