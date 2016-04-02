//
//  InputLocationViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 4/1/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import Foundation
import UIKit

class InputLocationViewController: UIViewController {
    
    @IBOutlet weak var address: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FindOnMap(sender: AnyObject) {
        if (address.text == "") {
            let alert = UIAlertController(title: "Empty Fields", message: "Please enter a valid address.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                //stop login if there are empty fields
                return
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("InputLinkViewController") as! InputLinkViewController
            vc.location = address.text!
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
 }

