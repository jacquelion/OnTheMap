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
    
    func login(username: String, password: String, vc: UIViewController) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let s = "{\"\(JSONBodyKeys.udacity)\": {\"\(JSONBodyKeys.username)\": \"\(username)\", \"\(JSONBodyKeys.password)\": \"\(password)\"}}"
        
        print("LOGIN: ", s)
        
        request.HTTPBody = s.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                print("ERROR ON U-LOGIN")
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                
                guard let statuscode = (response as? NSHTTPURLResponse)?.statusCode else {
                    print("Error on Status Code.")
                    return
                }
                
                switch statuscode {
                case 200...299:
                    print("great status.")
                case 403:
                    let alert = UIAlertController(title: "Account not found", message: "Account not found or invalid credentials. Please ensure you have registered with Udacity and entered the correct username/password combination.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        dispatch_async(dispatch_get_main_queue()) {
                            vc.dismissViewControllerAnimated(true, completion: nil)
                        }                         }
                    alert.addAction(action)
                    dispatch_async(dispatch_get_main_queue()) {
                        vc.presentViewController(alert, animated: true){}
                    }
                case 400:
                    let alert = UIAlertController(title: "Bad Request", message: "There is a problem with the request.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        dispatch_async(dispatch_get_main_queue()) {
                            vc.dismissViewControllerAnimated(true, completion: nil)
                        }                         }
                    alert.addAction(action)
                    dispatch_async(dispatch_get_main_queue()) {
                        vc.presentViewController(alert, animated: true){}
                    }
                case 500...599:
                    let alert = UIAlertController(title: "Internal Server Error", message: "The server encountered an unexpected condition which prevented it from fulfilling the request. Please try again a little later.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        dispatch_async(dispatch_get_main_queue()) {
                            vc.dismissViewControllerAnimated(true, completion: nil)
                        }                         }
                    alert.addAction(action)
                    dispatch_async(dispatch_get_main_queue()) {
                        vc.presentViewController(alert, animated: true){}
                    }
                default:
                    let alert = UIAlertController(title: "Alert", message: "The username and password combination is not registered with Udacity. Please try again.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        dispatch_async(dispatch_get_main_queue()) {
                            vc.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                    alert.addAction(action)
                    dispatch_async(dispatch_get_main_queue()) {
                        vc.presentViewController(alert, animated: true){}
                    }
                }
                
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                // Use the data!
                //Store User Key
                
                guard let account = parsedResult["account"] as? NSDictionary, let userKey = account["key"] as? String else {
                    print("Error getting userKey")
                    return
                }
                UClient.sharedInstance.userKey = userKey
                
                //Chain Login via Udacity API with Getting Student Location Info from Parse API
                UClient.sharedInstance.getStudentLocations(vc)
            }
            
        }
        task.resume()
        
    }
    
    func getUserData() {
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
            
        }
        task.resume()
    }

    func getStudentLocations(vc: UIViewController) {
        //parameters include: Limit response to 100, and order ascending by updatedAt
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: ParameterKeys.ParseAppId)
        request.addValue(Constants.ParseApiKey, forHTTPHeaderField: ParameterKeys.ParseAPIKey)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                print("ERROR ON GET STUDENT LOCATIONS.")
                return
            }
            
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
            
            UserDictionay.sharedInstance.users = users
            
            self.loadTableViewData(vc)
            
        }
        
        task.resume()
        
    }
    
    func loadTableViewData(vc: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) //nil bundle defaults to Main
        
        dispatch_async(dispatch_get_main_queue()) {
            let navController = storyboard.instantiateViewControllerWithIdentifier("NavBarViewController") as! UINavigationController
            vc.presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    
    func postLink(url: String, mapString: String, latitude: Double, longitude: Double, vc: UIViewController) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: ParameterKeys.ParseAppId)
        request.addValue(Constants.ParseApiKey, forHTTPHeaderField: ParameterKeys.ParseAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let s = "{\"\(JSONResponseKeys.uniqueKey)\": \"\(UClient.sharedInstance.userKey)\", \"\(JSONResponseKeys.firstName)\": \"\(UClient.sharedInstance.firstName)\", \"\(JSONResponseKeys.lastName)\": \"\(UClient.sharedInstance.lastName)\", \"\(JSONResponseKeys.mapString)\": \"\(mapString)\", \"\(JSONResponseKeys.mediaURL)\": \"\(url)\", \"\(JSONResponseKeys.latitude)\": \(latitude), \"\(JSONResponseKeys.longitude)\": \(longitude)}"
        print(s)
        request.HTTPBody = s.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print("Error posting link.")
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.getStudentLocations(vc)
        }
        task.resume()
        
    }
    
    
    //MARK: Delete Methods
    
    func deleteSession(tabBarController: UITabBarController) {
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
                print("Error with Logout.")
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        dispatch_async(dispatch_get_main_queue()) {
            //TODO: Figure out how to get back to Login Page (Unwind segue?)
            //let storyboard = UIStoryboard(name: "Main", bundle: nil) //nil bundle defaults to Main
            
            tabBarController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        task.resume()
        }

}

    



 