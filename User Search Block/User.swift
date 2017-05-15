//
//  User.swift
//  User Search Block
//
//  Created by Ruslan on 05.05.17.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class User: NSObject {
    static var dictionary = [String: User]()
    static var mainUser: User! = nil
    static let placeholderImage = UIImage(named: "user_placeholder")
    
    var userId: String
    var username: String
    var profileURL: String
    var followers: Int
    
    var followed: Int = 0
    var status: String = ""
    var birthDate: NSDate? = nil
    var email: String = ""
    var location: String = ""
    var challenges: Int = 0
    var meFollow = false
    
    init(userId: String, username: String, profileURL: String, followers: Int = 0) {
        self.userId = userId
        self.username = username
        self.profileURL = profileURL
        self.followers = followers
    }
    
    func isMain() -> Bool {
        return userId == User.mainUser.userId
    }
}

extension User {
    class func userFromJson(json: JSON) -> User {
        let userId = json[JSONColumns.id].stringValue
        let username = json[JSONColumns.username].stringValue
        var profileUrl = json[JSONColumns.pictureUrl].stringValue
        if profileUrl != "" {
            profileUrl = NetworkingManager.host + profileUrl
        }
        let followers = json[JSONColumns.counters][JSONColumns.followers].intValue
        
        let user = User(userId: userId, username: username, profileURL: profileUrl, followers: followers)
        
        user.email = json[JSONColumns.email].stringValue
        user.followed = json[JSONColumns.counters][JSONColumns.followed].intValue
        user.status = json[JSONColumns.status].stringValue
        user.location = json[JSONColumns.location].stringValue
        user.challenges = json[JSONColumns.counters][JSONColumns.challenges].intValue
        
        if json[JSONColumns.me][JSONColumns.followed].stringValue == "true" {
            user.meFollow = true
        }
        
        let df = NSDateFormatter()
        df.timeZone = NSTimeZone(name: "UTC")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        user.birthDate = df.dateFromString(json[JSONColumns.birthDate].stringValue)
        
        return user
    }
    
    class func createOrGetUserFromJson(json: JSON) -> User {
        
        let userId = json[JSONColumns.author][JSONColumns.id].stringValue
        let user: User
        
        if !User.isExistsUser(userId) {
            
            user = User(userId: userId,
                        username: json[JSONColumns.author][JSONColumns.username].stringValue,
                        profileURL: NetworkingManager.host + json[JSONColumns.author][JSONColumns.pictureUrl].stringValue)
            
        } else {
            user = User.userByID(userId)
        }
        
        User.updateUser(userId, user: user)
        
        return user
    }
}

//{
//    "id": "586f7469a1bb8b000f376830",
//    "username": "tokhir",
//    "email": "tokhir@gmail.com",
//    "location": "Moscow",
//    "birthDate": "1991-01-26T00:00:00.000Z",
//    "pictureUrl": "/media/e956753301442e5a5ef2a3f3df801dec",
//    "joined": "2017-01-06T10:41:45.559Z",
//    "status": "testing the app",
//    "counters": {
//        "followers": 3,
//        "followed": 3,
//        "challenges": 1,
//        "reports": 1
//    }
//}

//"id": "586ce19fa1bb8b000f3767d8",
//"username": "Kirill Haar",
//"pictureUrl": "/media/50b02ef95e1f553eadd9dfb742b1b269",
//"counters": {
//    "followers": 8,
//    "followed": 6
//},
//"me": {
//    "follower": false,
//    "followed": false
//}

extension User {
    class func usersFromJson(json: JSON) -> [User] {
        var array = [User]()
        for item in json.arrayValue {
            let id =            item[JSONColumns.id].stringValue
            let username =      item[JSONColumns.username].stringValue
            let pictureUrl =    NetworkingManager.host + item[JSONColumns.pictureUrl].stringValue
            let followers =     item[JSONColumns.counters][JSONColumns.followers].intValue
            let user = User(userId: id, username: username, profileURL: pictureUrl, followers: followers)
            
            if item[JSONColumns.me][JSONColumns.followed].stringValue == "true" {
                user.meFollow = true
            }
            
            array.append(user)
        }
        
        return array
    }
    
    class func followersFromJson(json: JSON) -> [User] {
        var array = [User]()
        for item in json.arrayValue {
            let id =            item[JSONColumns.id].stringValue
            let username =      item[JSONColumns.username].stringValue
            let pictureUrl =    NetworkingManager.host + item[JSONColumns.pictureUrl].stringValue
            let followers = item[JSONColumns.counters][JSONColumns.followers].intValue
            let user = User(userId: id, username: username, profileURL: pictureUrl, followers: followers)
            
            if item[JSONColumns.me][JSONColumns.followed].stringValue == "true" {
                user.meFollow = true
            }
            
            array.append(user)
        }
        
        return array
    }
}

extension User {
    static func userByID(userId: String) -> User {
        return dictionary[userId]!
    }
    
    static func isExistsUser(userId: String) -> Bool {
        return dictionary[userId] != nil
    }
    
    static func updateUser(id: String, user: User) {
        dictionary[id] = user
    }
}

extension User {
    static func getRandomUsers() -> [User] {
        return Array<User>(dictionary.values)
    }
    
    static func getRandomUser() -> User {
        return User(userId: "", username: "", profileURL: "")
        //return Array<User>(dictionary.values)[Int(arc4random_uniform(UInt32(dictionary.values.count)))]
    }
    
    static func getRandomUserOld() -> User {
        return Array<User>(dictionary.values)[Int(arc4random_uniform(UInt32(dictionary.values.count)))]
    }
    
    static func generateRandomUsers() {
        let usernames = [
            "milana", "muamua", "pozvolte", "nadya", "yabalaban", "kostyagnyp", "isosn"
        ]
        let profileURLs = [
            "http://2.bp.blogspot.com/-YdXmeVkbbRg/TcmT4q3nIxI/AAAAAAAAC8Y/zO1eNeDONpg/s1600/tumblr_lkojzzHVcX1qzffago1_500.png",
            "https://lh4.googleusercontent.com/-OJZ-EGYgA_M/AAAAAAAAAAI/AAAAAAAAAD0/j-Zv5IQpIwA/photo.jpg",
            "https://scontent.xx.fbcdn.net/hprofile-xpa1/v/t1.0-1/c34.0.320.320/p320x320/996035_10152000798458672_560860759_n.jpg?oh=0d3a5c62cdb71be5e97dcddeb0dd1d75&oe=5753AF35",
            "https://scontent.xx.fbcdn.net/hprofile-xal1/v/t1.0-1/p320x320/11262029_855719664518665_1768117742266302073_n.jpg?oh=31350f5066502a46c2ddd4c7df529b9f&oe=578694E1",
            "https://pp.vk.me/c629213/v629213951/16556/TRpuiUo8DVA.jpg",
            "https://pp.vk.me/c311128/v311128164/a6a2/dK_IVWrktcc.jpg",
            "https://pp.vk.me/c629503/v629503181/3b684/MMx0Uvj_dZ4.jpg"
        ]
        for idx in 0..<usernames.count {
            let user = User(userId: "\(idx)", username: usernames[idx], profileURL: profileURLs[idx], followers: idx)
            dictionary["\(idx)"] = user
        }
    }
}
