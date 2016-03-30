////
////  UUser.swift
////  OnTheMap
////
////  Created by Jacqueline Sloves on 3/26/16.
////  Copyright © 2016 Jacqueline Sloves. All rights reserved.
////
//
////MARK: - UdacityUser
//
//struct UUser {
//
//    //MARK: Properties
//    let firstName: String
//    let lastName: String
//    let id: Int
//    
//    let lat: Double
//    let long: Double
//    
//    let mediaURL: String
//    
//    //let coordinate = CLLocationCoordinate2D(latititude: lat, longitude: long)
//    
//    //MARK: Initializers
//    
//    //Construct a location from a Dictionary
//    init(dictionary: [String: AnyObject]) {
//        
//    }
//    
//    static func usersFromResults(results: [[String:AnyObject]]) -> [UUser] {
//        var users = [UUser]()
//        
//        //iterate through array of users, each user is a dictionary
//        for result in results {
//            users.append(UUser(dictionary: result))
//        }
//        
//        return users
//    }
//
//}
