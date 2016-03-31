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
     
     Step 1: Create a new request token
     Step 2a: Ask the user for permission via the website
     Step 3: Create a session ID
     Bonus Step: Go ahead and get the user id 😄!
     */
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
    
        // chain completion handlers for each request so that they run one after the other
        login() { (success, userKey, errorString) in
            if success {
                self.userKey = userKey
                print("SUCCESS")
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        
        }
    }
    
        
//        getRequestToken() { (success, requestToken, errorString) in
//            
//            if success {
//                
//                // success! we have the requestToken!
//                self.requestToken = requestToken
//                
//                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
//                    
//                    if success {
//                        self.getSessionID(requestToken) { (success, sessionID, errorString) in
//                            
//                            if success {
//                                
//                                // success! we have the sessionID!
//                                self.sessionID = sessionID
//                                
//                                self.getUserID() { (success, userID, errorString) in
//                                    
//                                    if success {
//                                        
//                                        if let userID = userID {
//                                            
//                                            // and the userID 😄!
//                                            self.userID = userID
//                                        }
//                                    }
//                                    
//                                    completionHandlerForAuth(success: success, errorString: errorString)
//                                }
//                            } else {
//                                completionHandlerForAuth(success: success, errorString: errorString)
//                            }
//                        }
//                    } else {
//                        completionHandlerForAuth(success: success, errorString: errorString)
//                    }
//                }
//            } else {
//                completionHandlerForAuth(success: success, errorString: errorString)
//            }
//        }
//    }
    
    private func login(completionHandlerForULogin: (success: Bool, userKey: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        let jsonBody = "{\"udacity\": {\"username\": \"jacqueline.sloves@gmail.com\", \"password\": \"darkstar\"}}"
        
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
    
    
    
    
}