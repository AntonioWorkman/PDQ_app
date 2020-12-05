//
//  ViewController.swift
//  Routing Subsystem
//
//  Created by Antonio on 2020/11/25.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //This is a very important line. Do not change it or the map will not work.
        map.delegate = self
        

        let suzhou = Factory(title: "Pizza Delivered Quickly Suzhou Factory", coordinate: CLLocationCoordinate2D(latitude: 31.275242, longitude: 120.744016))
    

        map.addAnnotation(suzhou)
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()
            renderMap(location)
        }
        print(locations)
    }
    
    func renderMap(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        
//        let pdq = MKPointAnnotation()
//        pdq.coordinate = coordinate
//        map.addAnnotation(pdq)
    }
    
    @IBAction func confirmRequest(_ sender: UIButton) {
        getAddress()
    }

    func getAddress(){
        let geoCoder = CLGeocoder()

        //find a way to get the address from the database and place it in the brackets
        geoCoder.geocodeAddressString(){
            (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
            else{
                print("No Location Found")
                return
            }
            print(location)
            self.mapThis(destinationCoord: location.coordinate)
        }
    }
    
    
    
    
    func mapThis(destinationCoord : CLLocationCoordinate2D){
        let sourceCoordinate = (locationManager.location?.coordinate)!
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoord)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate{(response, error) in
            guard let response = response else {
                if error != nil {
                    print("Someting's Wrong :(")
                }
                return
            }
            let route = response.routes[0]
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    }
}
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .red
        return render
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     
        guard annotation is Factory else { return nil }

        let identifier = "Factory"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
    
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {

            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    
   
    
        
        //print("clicked")
       
//        func customerLocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            let mCustomerLocation:CLLocation = locations[0] as CLLocation
//            let center = CLLocationCoordinate2D(latitude: 31.275893, longitude: 120.738458)
//            let custRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//            map.setRegion(custRegion, animated: true)
//            map.addAnnotation(mCustomerLocation as! MKAnnotation)

    //        // Get user's Current Location and Drop a pin
    //        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
    //            mkAnnotation.coordinate = CLLocationCoordinate2DMake(mCustomerLocation.coordinate.latitude, mCustomerLocation.coordinate.longitude)
    //            mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mCustomerLocation.coordinate.latitude, mLongitude: mCustomerLocation.coordinate.longitude)
    //            map.addAnnotation(mkAnnotation)
//        }
    
    
}
