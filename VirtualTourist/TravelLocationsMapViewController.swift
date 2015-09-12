//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Shubham Tripathi on 06/09/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var longPress: UILongPressGestureRecognizer!
    //var mapAnnotations = [MKPointAnnotation]()
    var pinDropLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.hidden = true
        longPress = UILongPressGestureRecognizer(target: self, action: "dropPin:")
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
        
        mapView.delegate = self
    }
    
    func dropPin(gesture: UILongPressGestureRecognizer) {
        
        let touchPoint: CGPoint = gesture.locationInView(mapView)
        let touchPointCoordinates: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        //getPinDropLocation(CLLocation(latitude: touchPointCoordinates.latitude, longitude: touchPointCoordinates.longitude))
        
        if UIGestureRecognizerState.Began == gesture.state {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: touchPointCoordinates.latitude, longitude: touchPointCoordinates.longitude)) { placemarks, error in
                if error != nil {
                    let errMsg: String? = (error!.code == 8) ? "User location cannot be located on the map. Please retry with a different location" : "No network connection available"
                    println("\(errMsg)")
                } else {
                    if placemarks == nil {
                        println("No Lacation Data")
                        self.pinDropLocation = nil
                    } else {
                        var placemark = placemarks[0] as! CLPlacemark
                        println("placemark addressDictionary - \(placemark.addressDictionary)")
                        let name = placemark.addressDictionary["Name"] as! String
                        let area = placemark.addressDictionary["SubAdministrativeArea"] as! String
                        self.pinDropLocation = name + ", " + area
                        let mapAnnotation = MKPointAnnotation()
                        mapAnnotation.coordinate = touchPointCoordinates
                        mapAnnotation.title = "Dropped Pin"
                        mapAnnotation.subtitle = self.pinDropLocation
                        self.mapView.addAnnotation(mapAnnotation)
                    }
                }
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "mapAnnotation"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

}

