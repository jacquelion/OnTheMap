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
    
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    @IBOutlet weak var accountSignupButton: UIButton!
    @IBOutlet weak var loginButton: BorderedButton!
   
    @IBAction func loginButton(sender: AnyObject) {
        
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
    
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adjust spinner visibility (have it animate so that when it is called there is no lag
        mySpinner.startAnimating()
        mySpinner.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        //clear fields after view disappears
        username.text = ""
        password.text = ""
    }
    
    @IBAction func accountSignup(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("UAuthViewController")
        self.presentViewController(vc!, animated: true, completion: nil)
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
        
        request.HTTPBody = s.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        mySpinner.hidden = false
        let task = session.dataTaskWithRequest(request) { data, response, error in
            self.mySpinner.stopAnimating()

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
                case 400:
                    let alert = UIAlertController(title: "Bad Request", message: "There is a problem with the request.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default) { _ in
                        dispatch_async(dispatch_get_main_queue()) {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }                         }
                    alert.addAction(action)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(alert, animated: true){}
                    }
                case 500...599:
                    let alert = UIAlertController(title: "Internal Server Error", message: "The server encountered an unexpected condition which prevented it from fulfilling the request. Please try again a little later.", preferredStyle: .Alert)
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
                
                //Chain Login via Udacity API with Getting Student Location Info from Parse API
                UClient.sharedInstance.getStudentLocations(self)
                //UClient.sharedInstance.getMapLocations()
                
            }
            
        }
        task.resume()

    }
    
//    private func getStudentLocations() {
//        UClient.sharedInstance.getStudentLocations(self)
//        loadTableViewData()
//              
//    }
    
    func loadTableViewData () {
        dispatch_async(dispatch_get_main_queue()) {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NavBarViewController") as! UINavigationController
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
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

