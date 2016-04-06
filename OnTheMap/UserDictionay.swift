//
//  UserDictionay.swift
//  OnTheMap
//
//  Created by Jacqueline Sloves on 4/6/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import Foundation

class UserDictionay {

    var users: [UUser] = []

    private init() {
    }
    
    static let sharedInstance = UserDictionay()
}
