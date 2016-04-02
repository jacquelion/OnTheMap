//
//  InputLinkViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 4/1/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InputLinkViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var mediaURL: UITextField!
    var location : String!
    var latitude : Double!
    var longitude : Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks![0] as? CLPlacemark {
                
                var region: MKCoordinateRegion = self.myMapView.region
                region.center.latitude = (placemark.location?.coordinate.latitude)!
                region.center.longitude = (placemark.location?.coordinate.longitude)!
                
                region.span = MKCoordinateSpanMake(0.5, 0.5)
                
                //Establish center point of map view to placemark
                self.myMapView.setRegion(region, animated: true)
                self.myMapView.addAnnotation(MKPlacemark(placemark: placemark))
                
                //get Longitude/Latitude coordinates from placemark location
                self.longitude = (placemark.location?.coordinate.longitude)!
                self.latitude = (placemark.location?.coordinate.latitude)!
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        //clear fields after view disappears
        mediaURL.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addUserData(sender: AnyObject) {
       getUserData()
    }
    
    private func getUserData() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(UClient.sharedInstance.userKey)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            //PARSE Data:
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            guard let user = parsedResult["user"] as? NSDictionary, let firstName = user["first_name"] as? String, let lastName = user["last_name"] as? String else {
                print("Problem with getting usser data for Parsed Result: \(parsedResult)")
                return
            }
            
            print("User: ", user, ", firstName: ", firstName, ", lastName: ", lastName)
            UClient.sharedInstance.firstName = firstName
            UClient.sharedInstance.lastName = lastName
            
            self.postLink()
        }
        task.resume()
    }
    
    private func postLink() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let url = mediaURL.text! as? String else {
            print("error on mediuURL text")
            return
        }
        
        guard let mapString = location as? String else {
            print("error with locaiton")
            return
        }
        
        let s = "{\"uniqueKey\": \"\(UClient.sharedInstance.userKey)\", \"firstName\": \"\(UClient.sharedInstance.firstName)\", \"lastName\": \"\(UClient.sharedInstance.lastName)\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        print(s)
        request.HTTPBody = s.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            dispatch_async(dispatch_get_main_queue()){
                self.dismissViewControllerAnimated(true, completion: nil)

            }
        }
        task.resume()
        
    }
}
