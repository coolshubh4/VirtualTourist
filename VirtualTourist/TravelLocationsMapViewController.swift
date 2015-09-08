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
    var mapAnnotations = [MKPointAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.hidden = true
        longPress = UILongPressGestureRecognizer(target: self, action: "dropPin:")
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
        
        mapView.delegate = self
    }
    
    func dropPin(gesture: UILongPressGestureRecognizer) {
        
        var mapAnnotation = MKPointAnnotation()
        let touchPoint: CGPoint = gesture.locationInView(mapView)
        let touchPointCoordinates: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        if UIGestureRecognizerState.Began == gesture.state {
            println("Pin dropped: \(touchPointCoordinates.latitude) -- \(touchPointCoordinates.longitude)")
            mapAnnotation.coordinate = touchPointCoordinates
            mapAnnotations.append(mapAnnotation)
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(self.mapAnnotations)
        }
    }

}

