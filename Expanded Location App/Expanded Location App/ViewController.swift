//
//  ViewController.swift
//  Expanded Location App
//
//  Created by Taulant Xhakli on 2/17/20.
//  Copyright © 2020 Taulant Xhakli. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit

let manager = CLLocationManager()

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var latitude: Double?
    var longitude: Double?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var myLongitude: UITextField!
    @IBOutlet weak var myLatitude: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"wallpaper.jpg")!)
        
        let location = CLLocationCoordinate2D(latitude: 41.042045,
            longitude: -73.936764)
        
        let location2 = CLLocationCoordinate2D(latitude: 40.8506556,
            longitude: -73.9709715)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)

        let sourcePlaceMark = MKPlacemark(coordinate: location)
        let destinationPlaceMark = MKPlacemark(coordinate: location2)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        self.mapView.delegate = self
        
        
        let annotation = MKPointAnnotation()
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = location2
        annotation.coordinate = location
        annotation2.title = "Fort Lee"
        annotation.title = "STAC"
        annotation.subtitle = "Costello Hall"
        mapView.addAnnotation(annotation)
        mapView.addAnnotation(annotation2)
        myLatitude.text = "41.042045"
        myLongitude.text = "-73.936764"
    }
    //MARK:- Color of the waypoint.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2.0
        return renderer
    }
    
    //MARK:- Selected Segment Button.
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
          mapView.mapType = .standard
        } else {
          mapView.mapType = .satellite
        }
    }

}
