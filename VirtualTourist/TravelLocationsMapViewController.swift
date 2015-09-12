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
    var pinDropLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longPress = UILongPressGestureRecognizer(target: self, action: "dropPin:")
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
    }
    
    func dropPin(gesture: UILongPressGestureRecognizer) {
        
        let touchPoint: CGPoint = gesture.locationInView(mapView)
        let touchPointCoordinates: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        if UIGestureRecognizerState.Began == gesture.state {
            let droppedPin = Pin(annotationLatitude: touchPointCoordinates.latitude, annotationLongitude: touchPointCoordinates.longitude)
            droppedPin.coordinate = touchPointCoordinates
            mapView.addAnnotation(droppedPin)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if view.selected {
            
            let pin = view.annotation as! Pin
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
            navigationController?.navigationBar.hidden = false
            navigationController?.pushViewController(controller, animated: true)
            controller.pin = pin
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "mapAnnotation"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinColor = .Red
            pinView!.animatesDrop = true
            //pinView!.setSelected(true, animated: true)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            navigationController?.navigationBar.hidden = false
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! UIViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

}

