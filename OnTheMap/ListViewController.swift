//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/21/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    var users : [UUser] = [UUser]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        self.users = UClient.sharedInstance.users
        performUIUpdatesOnMain { 
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: ListTableViewController (UITableViewController)

extension ListViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Return number of map data points
        print(users.count)
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UdacityUserCell")!
        
        let user = users[indexPath.row]
        cell.textLabel!.text = user.firstName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: Open user's url in safari view
        let urlVC = self.storyboard!.instantiateViewControllerWithIdentifier("UserURLViewController") as! UserURLViewController
        
        urlVC.user = self.users[indexPath.row]
        
        navigationController!.pushViewController(urlVC, animated: true)
    }


}

