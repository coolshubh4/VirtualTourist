//
//  Pin.swift
//  VirtualTourist
//
//  Created by Shubham Tripathi on 12/09/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import MapKit

class Pin: MKPointAnnotation {
    
    var pinLatitude: NSNumber
    var pinLongitude: NSNumber
    
    init(annotationLatitude: Double, annotationLongitude: Double) {
        self.pinLatitude = NSNumber(double: annotationLatitude)
        self.pinLongitude = NSNumber(double: annotationLongitude)
    }
    
    var pinCoordinate: CLLocationCoordinate2D {
        return super.coordinate
    }
}