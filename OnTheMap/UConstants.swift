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
        
        //POST (Create) a Session:
        //"https://www.udacity.com/api/session"
        
        //DELETE (Log Out) a Session: 
        //"https://www.udacity.com/api/session"
        
        //GET Public User Data
        //"https://www.udacity.com/api/users/<user_id>"
    
    }
    
    //MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    //MARK: Parameter Keys
    struct ParameterKeys {
    
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
    }
    
}
