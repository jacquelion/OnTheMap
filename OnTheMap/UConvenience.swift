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

    func loginUdacity() {
        
    
    
    }
    
    func getStudentLocations() {
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
            
            //loadTableViewData()
            
        }
        
        task.resume()
        
    }

    func loadTableViewData () {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil) //nil bundle defaults to Main
//        //let viewController = UIViewController(nibName: "", bundle: NSBundle.mainBundle()
//        dispatch_async(dispatch_get_main_queue()) {
//            let vc = storyboard.instantiateViewControllerWithIdentifier("NavBarViewController") as! UINavigationController
//            
//            storyboard.presentViewController(vc, animated: true, completion: nil)
//        }
//    }
}
}
    
    //TODO: Pass in email and user instead of View Controller
//    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
//    
//        // chain completion handlers for each request so that they run one after the other
//        login() { (success, userKey, errorString) in
//            if success {
//                //Store key
//                self.userKey = userKey
//                print("SUCCESS logging in, getting userKey: ", userKey)
//                
//                self.getUserInfo(){ (success, errorString) in
//                    
//                    if success {
//                    //Store User Info (i.e. Name)
//                        
//                        self.getMapLocations() {(success, errorString) in
//                            
//                            if success {
//                                //store locations as points on map
//                            }
//                            completionHandlerForAuth(success: success, errorString: errorString)
//                        
//                        }
//                    
//                    } else {
//                        completionHandlerForAuth(success: success, errorString: errorString)
//                    }
//                
//                }
//                
//            } else {
//                completionHandlerForAuth(success: success, errorString: errorString)
//            }
//        
//        }
//    }
//    
//        
//
//
//    private func login(completionHandlerForULogin: (success: Bool, userKey: String?, errorString: String?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [String: AnyObject]()
//        let jsonBody = "{\(UClient.JSONBodyKeys.udacity): {\(UClient.JSONBodyKeys.username): \"jacqueline.sloves@gmail.com\", \(UClient.JSONBodyKeys.password): \"darkstar\"}}"
//        
//        /* 2. Make the request */
//        taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
//
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                print(error)
//                completionHandlerForULogin(success: false, userKey: nil, errorString: "Login Failed (User Key).")
//            } else {
//                if let userKey = results[UClient.JSONResponseKeys.Session] as? String {
//                    completionHandlerForULogin(success: true, userKey: userKey, errorString: nil)
//                } else {
//                    print("Could not find \(UClient.JSONResponseKeys.Session) in \(results)")
//                    completionHandlerForULogin(success: false, userKey: nil, errorString: "Login Failed (User Key).")
//                }
//            }
//        }
//    }
//    
//    private func getUserInfo(completionHandlerForUserInfo: (success: Bool, errorString: String?) -> Void){
//    
//    }
//    
//    private func getMapLocations(completionHandlerForMapLocations: (success: Bool, errorString: String?) -> Void){
//    
//    }
//    
//    
//}