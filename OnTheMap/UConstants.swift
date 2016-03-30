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
        static let ApiKey : String = ""
        
        //MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "api"
        static let AuthorizationURL: String = "https://www.udacity.com/api/session"
        
    
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
    
    }
    
    //MARK: Parameter Keys
    struct ParameterKeys {
    
    }
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        
    }
    
    
    //MARK JSON Response Keys
    struct JSONResponseKeys {
        
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
