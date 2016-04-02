//
//  UserURLViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/31/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import Foundation
import UIKit

class UserURLViewController: UIViewController, UIWebViewDelegate {
    var user: UUser?
    
    var urlString: String = ""
    
    @IBOutlet weak var myWebView: UIWebView!
    
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myWebView.delegate = self
        self.myWebView.scalesPageToFit = true
        
        self.mySpinner.startAnimating()
        
        urlString = (self.user?.mediaURL)!
        
        if let url = NSURL(string: urlString) {
            let urlRequest = NSURLRequest(URL: url)
            self.myWebView.loadRequest(urlRequest)
        }
    
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.mySpinner.stopAnimating()
    }
    
    
    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
