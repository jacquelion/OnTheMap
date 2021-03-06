//
//  UAuthViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/26/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit

//MARK: - UdacityAuthViewController: UIViewController

class UAuthViewController: UIViewController {

    //MARK: Properties
    
    var urlRequest: NSURLRequest? = nil
    var requestToken: String? = nil
    var completionHandlerForView: ((success: Bool, errorString: String?) -> Void)? = nil
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    //MARK: Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signin")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        
        NavigationItem.title = "Udacity Auth"
        NavigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(UAuthViewController.cancelAuth))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    //Mark: Cancel Auth Flow
    
    func cancelAuth() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: UdacityAuthViewController: UIWebViewDelegate

//TODO: Why is this an extension rather than part of original class above?
extension UAuthViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //TODO: Get proper authorizationURL
        if webView.request!.URL!.absoluteString == "" {
            dismissViewControllerAnimated(true) {
                self.completionHandlerForView!(success: true, errorString: nil)
            }
        }
    }
}
