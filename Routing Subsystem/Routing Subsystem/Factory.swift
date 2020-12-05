//
//  Factory.swift
//  Routing Subsystem
//
//  Created by Antonio on 2020/12/2.
//

import MapKit
import UIKit

class Factory: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D

    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
