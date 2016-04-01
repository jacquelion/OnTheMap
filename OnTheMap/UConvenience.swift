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
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
    
        // chain completion handlers for each request so that they run one after the other
        login() { (success, userKey, errorString) in
            if success {
                //Store key
                self.userKey = userKey
                print("SUCCESS logging in, getting userKey: ", userKey)
                
                self.getUserInfo(){ (success, errorString) in
                    
                    if success {
                    //Store User Info (i.e. Name)
                        
                        self.getMapLocations() {(success, errorString) in
                            
                            if success {
                                //store locations as points on map
                            }
                            completionHandlerForAuth(success: success, errorString: errorString)
                        
                        }
                    
                    } else {
                        completionHandlerForAuth(success: success, errorString: errorString)
                    }
                
                }
                
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        
        }
    }
    
        


    private func login(completionHandlerForULogin: (success: Bool, userKey: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        let jsonBody = "{\(UClient.JSONBodyKeys.udacity): {\(UClient.JSONBodyKeys.username): \"jacqueline.sloves@gmail.com\", \(UClient.JSONBodyKeys.password): \"darkstar\"}}"
        
        /* 2. Make the request */
        taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in

            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForULogin(success: false, userKey: nil, errorString: "Login Failed (User Key).")
            } else {
                if let userKey = results[UClient.JSONResponseKeys.Session] as? String {
                    completionHandlerForULogin(success: true, userKey: userKey, errorString: nil)
                } else {
                    print("Could not find \(UClient.JSONResponseKeys.Session) in \(results)")
                    completionHandlerForULogin(success: false, userKey: nil, errorString: "Login Failed (User Key).")
                }
            }
        }
    }
    
    private func getUserInfo(completionHandlerForUserInfo: (success: Bool, errorString: String?) -> Void){
    
    }
    
    private func getMapLocations(completionHandlerForMapLocations: (success: Bool, errorString: String?) -> Void){
    
    }
    
    
}