//
//  FirstViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/21/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    var users = [UUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mySpinner.startAnimating()
        loadData()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        self.users = UserDictionay.sharedInstance.users
        
        performUIUpdatesOnMain {
            self.self.loadData()
        }
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        self.mySpinner.stopAnimating()
        self.mySpinner.hidden = true
    }
    
    //    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
    //        self.mySpinner.stopAnimating()
    //        self.mySpinner.hidden = true
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData() {
        
        var annotations = [MKPointAnnotation]()
        
        //TODO: Create CUSTOM Student Location Struct
        for dictionary in users {
            let lat = CLLocationDegrees(dictionary.latitude )
            let long = CLLocationDegrees(dictionary.longitude )
            
            //use lat & long to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        // Add annotations to the map
        self.mapView.addAnnotations(annotations)
    }
    
    //MARK: -MKMapViewDelegate
    
    
    //Create a view with a "right callout accessory view"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIButton
        } else {
            pinView!.canShowCallout = true
            let button = UIButton(type: .DetailDisclosure) as UIButton // button with info sign in it
            pinView!.rightCalloutAccessoryView = button
        }
        
        pinView!.annotation = annotation
        return pinView
    }
    
    //Respond to taps
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("TAPPED! URL toOPEN: \(view.annotation?.subtitle)")
            let app = UIApplication.sharedApplication()
            
            guard let toOpen = view.annotation?.subtitle! else{
                print("Error on toOpen")
                return
            }
            
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: toOpen)!) {
                print("OPENING URL: ")
                app.openURL(NSURL(string: toOpen)!)
            } else {
                let alert = UIAlertController(title: "Invalid URL", message: "This is not a valid URL. Please select a different link to open.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    return
                }
                alert.addAction(action)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true){}
                }
            }
            
        }
    }
}

