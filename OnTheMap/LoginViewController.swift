//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/26/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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
            guard let username = username.text, password = password.text else {
                print ("Problem with username/password!")
                return
            }
            mySpinner.hidden = false
            loginButton.enabled = false
            UClient.sharedInstance.login(username, password: password, vc: self)
        }
    }
    
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adjust spinner visibility (have it animate so that when it is called there is no lag
        mySpinner.startAnimating()
        mySpinner.hidden = true
        
        textFieldSetup(username)
        textFieldSetup(password)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        //clear fields after view disappears
        username.text = ""
        password.text = ""
        mySpinner.hidden = true
    }
    
    func textFieldSetup(textField: UITextField!){
        textField.textAlignment = .Left
        textField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        username.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if username.isFirstResponder() {
            view.frame.origin.y -= 150
          //  view.frame.origin.y -= getKeyboardHeight(notification)
        }
        if password.isFirstResponder() {
            view.frame.origin.y -= 30
//            view.frame.origin.y -= getKeyboardHeight(notification)
       }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func accountSignup(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("UAuthViewController")
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    
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

