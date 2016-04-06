//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 4/1/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    @IBOutlet weak var buttonLogout: UIBarButtonItem!
    
    @IBAction func logout(sender:AnyObject) {
        UClient.sharedInstance.deleteSession(self)
    }
    
    @IBAction func dropAPin(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            let inputLocationVC = self.storyboard!.instantiateViewControllerWithIdentifier("InputLocationViewController")
            self.presentViewController(inputLocationVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func reload(sender: AnyObject) {
        //TODO: separate functions into: get&present vs just get
//        let mapVC = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController")
//        let listVC = self.storyboard!.instantiateInitialViewController("ListViewController")
//        self.navigationController!.pushViewController(MapViewController, animated: true)
        
        if Reachability.isConnectedToNetwork() == true {
            UClient.sharedInstance.getStudentLocations(self)
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                return
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            
        }

    }
    
}
