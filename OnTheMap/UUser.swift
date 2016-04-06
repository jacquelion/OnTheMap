//
//  UUser.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/26/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

//MARK: - UdacityUser

struct UUser {

    //MARK: Properties
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: AnyObject //id
    let updatedAt: String
    var users: [UUser] = []

    
//    let coordinate = CLLocationCoordinate2D(latititude: latitude, longitude: longitude)
    
    //MARK: Initializers
    
    //Construct a location from a Dictionary
    init(dictionary: [String: AnyObject]) {
        createdAt = dictionary["createdAt"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as AnyObject! //id
        updatedAt = dictionary["updatedAt"] as! String
    }
    
    static func usersFromResults(results: [[String:AnyObject]]) -> [UUser] {
        var users = [UUser]()
        
        //iterate through array of users, each user is a dictionary
        for result in results {
            users.append(UUser(dictionary: result))
        }
        
        return users
    }

    
}
