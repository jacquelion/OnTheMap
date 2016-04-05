//
//  UConstants.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 3/26/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

// MARK: UClient (Constants)

extension UClient {

    //MARK: Constants
    struct Constants {
        
        //MARK: API Key
        static let ParseApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        
        //MARK: URLs - UDACITY
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "api"
        static let AuthorizationURL: String = "https://www.udacity.com/api/session"
        
        //MARK: URLs - PARSE
        static let ParseApiScheme = "https"
        static let ParseApiHost = "api.parse.com"
        static let ParseApiPath = "1"
        static let ParseAuthorizationURL: String = "https://api.parse.com/1/classes/"
        
    
    }
    
    //MARK: Methods
    struct Methods {
        
        //MARK: Session
        static let Session = "/session"
        
        //MARK: User Data
        static let Users = "/users"
        
        static let StudentLocation = "/StudentLocation"
        
        //POST (Create) a Session:
        //"https://www.udacity.com/api/session"
        
        //DELETE (Log Out) a Session: 
        //"https://www.udacity.com/api/session"
        
        //GET Public User Data
        //"https://www.udacity.com/api/users/<user_id>"
        
        //GET Student Locations
        //
    
    }
    
    //MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    //MARK: Parameter Keys
    struct ParameterKeys {
        static let ParseAppId = "X-Parse-Application-Id"
        static let ParseAPIKey = "X-Parse-REST-API-Key"
        static let limit = "limit"
    }
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        
    }
    
    
    //MARK JSON Response Keys
    struct JSONResponseKeys {
        
        static let statusCode = "status code"
        
        //MARK: Authorization
        static let Account = "account"
            static let Registered = "registered" //Bool
            static let Key = "key" //String
        
        //MARK: Session
        static let Session = "session"
            static let ID = "id" //SessionId: String
            static let Expiration = "expiration" //DateTime
        
        //MARK: User Data
        static let User = "user"
            static let FirstName = "first_name"
            static let LastName = "last_name"
        
        //MARK: Parse - User Data Results
        static let createdAt = "createdAt"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey" //id
        static let updatedAt = "updatedAt"
    }
    
}
