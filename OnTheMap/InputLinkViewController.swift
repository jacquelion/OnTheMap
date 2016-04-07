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

class InputLinkViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    var location : String!
    var latitude : Double!
    var longitude : Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mediaURL.delegate = self
        mySpinner.startAnimating()
        
        UClient.sharedInstance.getUserData(self)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
                self.mySpinner.hidden = true
                let alert = UIAlertController(title: "Geocoder Failed", message: "Please enter a city and state, (i.e. Cupertino, CA).", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) { _ in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    return
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
                
            } else {
                
                
                guard let placemark = placemarks![0] as? CLPlacemark else {
                    let alert = UIAlertController(title: "Geocoder Failed", message: "Please enter a city and state, (i.e. Cupertino, CA).", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        return
                    }
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true){}
                }
                
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
                
                self.mySpinner.hidden = true
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        //clear fields after view disappears
        mediaURL.text = ""
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        mediaURL.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Insert Code re Editing
        mediaURL.text = "https://"
        
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputLinkViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if mediaURL.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addUserData(sender: AnyObject) {
        
        guard let url = mediaURL.text! as? String else {
            print("error on mediuURL text")
            return
        }
        
        if url == "" || url == "https://" {
            let alert = UIAlertController(title: "Empty Fields", message: "Please enter a valid url.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                //stop login if there are empty fields
                return
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
        }
        
        guard let mapString = location as? String else {
            print("error with location")
            return
        }
        
        if Reachability.isConnectedToNetwork() == true {
            UClient.sharedInstance.postLink(url, mapString: mapString, latitude: latitude, longitude: longitude, vc: self)
            print("Internet connection OK")
        } else {
            mySpinner.hidden = true
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                return
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        }
        
        mySpinner.hidden = false
    }
}
