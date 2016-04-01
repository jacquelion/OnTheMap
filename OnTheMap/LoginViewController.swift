//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/26/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
   
    @IBAction func loginButton(sender: AnyObject) {
//        UClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
//            performUIUpdatesOnMain {
//                if success {
//                    //self.completeLogin()
//                } else {
//                    self.displayError(errorString)
//                }
//            }
//        }
        
        if (username.text == "" || password.text == "" ) {
            let alert = UIAlertController(title: "Empty Fields", message: "Please enter both a valid username and password.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                //stop login if there are empty fields
                return
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
        } else {
            login()
        }
    }
    // @IBOutlet weak var loginButton: BorderedButton!
    
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureBackground()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    private func login () {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       
        guard let username = username.text, password = password.text else {
            print ("Problem with guard!")
            return
        }
        let s = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        print("Request.HTTPBody String: ", s)

        request.HTTPBody = s.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print("ERROR ON U-LOGIN")
            } else {
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                
            //TODO: Check for Status Code, and present alert view if not 200
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
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }                         }
                        alert.addAction(action)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentViewController(alert, animated: true){}
                        }
                    default:
                        let alert = UIAlertController(title: "Alert", message: "The username and password combination is not registered with Udacity. Please try again.", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "OK", style: .Default) { _ in
                            dispatch_async(dispatch_get_main_queue()) {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                        alert.addAction(action)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentViewController(alert, animated: true){}
                    }
                }
                //PARSE DATA: UClient.convertDataWithCompletionHandler
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
             
                /* Use the data! */
                //Store User Key
                
                guard let account = parsedResult["account"] as? NSDictionary, let userKey = account["key"] as? String else {
                    print("Error getting userKey")
                    return
                }
                UClient.sharedInstance.userKey = userKey
                print(UClient.sharedInstance.userKey)
                
                self.getStudentLocations()
                
                
            }

        }
        task.resume()
        print("FINISHED U-LOGIN")
        
    }
    
    private func getStudentLocations() {
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
           
            self.loadTableViewData()
            
        }
        
        task.resume()
        
    }
    
    func loadTableViewData () {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("SegueLoadMapView", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueLoadMapView" {
            if let MapViewController = segue.destinationViewController as? MapViewController {
                MapViewController.users = UClient.sharedInstance.users
            }
        }
    }
    
    
    private func logout() {
    
    }
}
    
    
    
//MARK: - Login View Controller (Configure UI)
    
extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        debugTextLabel.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
}

