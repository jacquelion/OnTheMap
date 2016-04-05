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
        logout()
    }
    
    @IBAction func dropAPin(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            let inputLocationVC = self.storyboard!.instantiateViewControllerWithIdentifier("InputLocationViewController")
            self.navigationController!.pushViewController(inputLocationVC, animated: true)
        }
    }
    
    @IBAction func reload(sender: AnyObject) {
        //TODO: separate functions into: get&present vs just get
        //self.viewWillAppear(true)
//        UClient.sharedInstance.getStudentLocations(self)
    }
    
    private func logout() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        dispatch_async(dispatch_get_main_queue()) {
            //TODO: Figure out how to get back to Login Page
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        task.resume()
    }

}
