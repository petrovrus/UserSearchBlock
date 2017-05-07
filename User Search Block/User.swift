//
//  User.swift
//  User Search Block
//
//  Created by Ruslan on 05.05.17.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    static func usersFromJson (_ json: JSON) -> [(userPictureURL: URL, username: String)]
    {
        var users: [(URL, String)] = []
        for (_,subJson):(String, JSON) in json {
            users.append((subJson["pictureUrl"].url!, subJson["username"].string!)) //unwrap properly
        }
        return users
    }
}
