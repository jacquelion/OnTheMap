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
        
        login()
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
            print("RESPONSE from U-LOGIN: ", response)
            print("DATA from U-LOGIN: ", NSString(data: newData, encoding: NSUTF8StringEncoding))
                
                //TODO: Check for Status Code, and present alert view if not 200
//                guard let statuscode = newData["status code"] as? Int else {
//                    print("Error on Status Code.")
//                    return
//                }
//                
//                if statuscode != 200 {
//                    let alertView = UIAlertView(title: "Alert", message: "The username and password combination is not registered with Udacity. Please try again.", delegate: self, cancelButtonTitle: "OK")
//                    alertView.show()
//                }
            }
            
            
            
            
        }
        task.resume()
        print("FINISHED U-LOGIN")
  //      getStudentLocations()
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
            print("DATA from PARSE: ", NSString(data: data!, encoding: NSUTF8StringEncoding))
            print("RESPONSE from PARSE: ", response)
        }
        task.resume()
        
    performSegueWithIdentifier("SegueLoadMapView", sender: self)

    
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

