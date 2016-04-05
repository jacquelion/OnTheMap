//
//  UConvenience.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/26/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit
import Foundation

//MARK: - UClient (Convenient Resource Methods)

extension UClient {

    //MARK: Authentication (GET) Methods
    /*
     Steps for Authentication...
     
     Step 1: Login To Udacity
     Step 2: Get User Data
     Step 3: Get Map Locations
     */

    func login() {
       
    }
    
    func getMapLocations(completionHandlerForLocations: (success: Bool, users: [UUser], errorString: String?) -> Void) {
        let parameters = [ParameterKeys.ParseAppId:  Constants.ParseApplicationID, ParameterKeys.ParseAPIKey : Constants.ParseApiKey]
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) {(results, error) in
            if let error = error {
                print(error)
                completionHandlerForLocations(success: false, users: [], errorString: "Login Failed (Session ID).")
            } else {
                if let users = UUser.usersFromResults(results as! [[String : AnyObject]]) as? [UUser]{
                    completionHandlerForLocations(success: true, users: users, errorString: nil)
                } else {
                    print("Could not find \(UClient.JSONResponseKeys.User) in \(results)")
                    completionHandlerForLocations(success: false, users: [], errorString: "Login Failed (Session ID).")
                }
            }
        }
    }
    
    func getStudentLocations(vc: UIViewController) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        
        print("REQUEST on PARSE: ", request)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            //TODO: Add guard statements
            
            //PARSE DATA: UClient.convertDataWithCompletionHandler
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            print("Parsed Result: ", parsedResult)
            
            guard let results = parsedResult["results"] as? [[String: AnyObject]] else {
                print("Could not get results")
                return
            }
            
            guard let users = UUser.usersFromResults(results) as? [UUser] else {
                print("Error getting users from Results")
                return
            }
            
            UClient.sharedInstance.users = users
            
            self.loadTableViewData(vc)
            
        }
        
        task.resume()
        
    }

    func loadTableViewData (vc: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) //nil bundle defaults to Main
        //let viewController = UIViewController(nibName: "LoginViewController", bundle: NSBundle.mainBundle())
        dispatch_async(dispatch_get_main_queue()) {
            let navController = storyboard.instantiateViewControllerWithIdentifier("NavBarViewController") as! UINavigationController
            //let loginVC = storyboard.instantiateInitialViewController()
            vc.presentViewController(navController, animated: true, completion: nil)
        }
    }
}

    
 