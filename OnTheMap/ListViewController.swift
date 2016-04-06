//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/21/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var users = [UUser]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.users = UserDictionay.sharedInstance.users
        self.tableView.reloadData()
 
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        dispatch_async(dispatch_get_main_queue()) {
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: ListTableViewController (UITableViewController)

extension ListViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Return number of map data points
        print(users.count)
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UdacityUserCell")!
        
        let user = users[indexPath.row]
        cell.textLabel!.text = "\(user.firstName) \(user.lastName)"
        cell.detailTextLabel!.text =  "\(user.mediaURL)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: Open user's url in safari view
        
        let selectedIndexPath = self.tableView.indexPathForSelectedRow
        let selectedUserURL = self.users[selectedIndexPath!.row].mediaURL
        
        let app = UIApplication.sharedApplication()
        if let toOpen = selectedUserURL as? String {
            print("OPENING URL: ")
            app.openURL(NSURL(string: toOpen)!)
        }

        
        //self.performSegueWithIdentifier("segueDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
        
        if segue.identifier == "segueDetail" {
            //store index of user
            let selectedIndexPath = self.tableView.indexPathForSelectedRow
            //deselect row
            self.tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
            //pass user data to UserURLViewController
            
            let urlVC = segue.destinationViewController as! UserURLViewController
            
            //let urlVC = self.storyboard!.instantiateViewControllerWithIdentifier("UserURLViewController") as! UserURLViewController
        
            urlVC.user = self.users[selectedIndexPath!.row]
            //instantiate UserURLViewController
            //navigationController!.pushViewController(urlVC, animated: true)
        }
    }


}

