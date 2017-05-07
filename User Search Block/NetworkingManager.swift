//
//  NetworkingManager.swift
//  User Search Block
//
//  Created by Ruslan on 02.05.17.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingManager {
    //    static let host = "http://46.101.160.115"
    static let host = "http://52.58.79.74"
    static let URL = host + "/v1"
    static var headers = [
        "Content-Type": "application/json"
    ]
}

/*
// MARK: Authorization
extension NetworkingManager {
    static let LoginSuccess = "LoginSuccess"
    static let LoginFailure = "LoginFailure"
    class func login(username: String, password: String) {
        
        Alamofire.request(.POST, "\(URL)/auth", headers: headers, parameters: ["username": username, "password": password], encoding: .JSON)
            .response { request, response, data, error in
                
                if response?.statusCode == 200,
                    let data = data {
                    
                    let token = String(data: data, encoding: NSUTF8StringEncoding) ?? ""
                    headers["Authorization"] = "JWT \(token)"
                    
                    let obj: [String: String] = ["username": username, "password": password]
                    NSNotificationCenter.defaultCenter().postNotificationName(LoginSuccess, object: obj)
                    
                } else {
                    if let data = data {
                        let obj: [String: String] = [
                            "msg": String(data: data, encoding: NSUTF8StringEncoding) ?? ""
                        ]
                        NSNotificationCenter.defaultCenter().postNotificationName(LoginFailure, object: obj)
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName(LoginFailure, object: nil)
                    }
                }
        }
    }
    
    static let RegistrationSuccess = "RegistrationSuccess"
    static let RegistrationFailure = "RegistrationFailure"
    
    class func register(email: String, username: String, password: String) {
        
        Alamofire.request(.POST, "\(URL)/users", parameters: ["email": email, "username": username, "password": password], encoding: .JSON)
            .response { request, response, data, error in
                
                if response?.statusCode == 201 {
                    login(username, password: password)
                    NSNotificationCenter.defaultCenter().postNotificationName(RegistrationSuccess, object: nil)
                } else {
                    if let data = data {
                        let obj: [String: String] = [
                            "msg": String(data: data, encoding: NSUTF8StringEncoding) ?? ""
                        ]
                        NSNotificationCenter.defaultCenter().postNotificationName(RegistrationFailure, object: obj)
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName(RegistrationFailure, object: nil)
                    }
                }
        }
    }
    
    class func forgotPassword(email: String) {
        
    }
}


// MARK: User Info
extension NetworkingManager {
    static let UserInfoSuccess = "UserInfoSuccess"
    static let UserInfoFailure = "UserInfoFailure"
    
    class func getUserInfo(id: String = "") {
        Alamofire.request(.GET, "\(URL)/users", parameters: ["id": id], encoding: .URL, headers: headers)
            .response { request, response, data, error in
                
                if response?.statusCode == 200 {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserInfoSuccess, object: nil)
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserInfoFailure, object: nil)
                }
        }
    }
    
    static let UserProfileSuccess = "UserProfileSuccess"
    static let UserProfileFailure = "UserProfileFailure"
    
    class func getUserProfile(userId: String = "", finishBlock: (User) -> Void, errorBlock: (NSError?) -> Void) {
        Alamofire.request(.GET, "\(URL)/users/\(userId)", parameters: [:], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, respnose, json, error) in
                print("user profile json : \(json)")
                if (error == nil) {
                    finishBlock(User.userFromJson(json))
                } else {
                    errorBlock(error as? NSError ?? nil)
                }
        }
    }
}

// MARK: Followers & Followings
extension NetworkingManager {
    //    static let GetFollowersSuccess = "GetFollowersSuccess"
    //    static let GetFollowersFailure = "GetFollowersFailure"
    //
    //    class func getFollowers(id: String = "") {
    //        Alamofire.request(.GET, "\(URL)/followers", parameters: ["id": id], encoding: .URL, headers: headers)
    //            .response { request, response, data, error in
    //
    //                if response?.statusCode == 200 {
    //                    NSNotificationCenter.defaultCenter().postNotificationName(GetFollowersSuccess, object: nil)
    //                } else {
    //                    NSNotificationCenter.defaultCenter().postNotificationName(GetFollowersFailure, object: nil)
    //                }
    //        }
    //    }
}


// MARK: Feed
extension NetworkingManager {
    static let FeedSuccess = "FeedSuccess"
    static let FeedFailure = "FeedFailure"
    
    class func getFeed(since: String = "") {
        
        
        Alamofire.request(.GET, "\(URL)/feed", parameters: ["since": since], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                
                print("json : \(json)")
                if error == nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(FeedSuccess, object: FeedItem.feedsFromJson(json))
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(FeedFailure, object: nil)
                }
        }
    }
}


// MARK: Inbox
extension NetworkingManager {
    static let InboxSuccess = "InboxSuccess"
    static let InboxFailure = "InboxFailure"
    
    class func getInbox(since: String = "") {
        
        Alamofire.request(.GET, "\(URL)/inbox", parameters: ["since": since], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                
                print("json : \(json)")
                if error == nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(InboxSuccess, object: Inbox.inboxesFromJson(json))
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(InboxFailure, object: nil)
                }
        }
    }
    
    enum InboxType: String {
        case reject = "rejects"
        case accept = "accepts"
    }
    
    class func rejectOrAcceptInbox(challengeId: String, type: InboxType) {
        
        Alamofire.request(.POST, "\(URL)/\(type.rawValue)", parameters: ["challengeId": challengeId], encoding: .JSON, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                
                print("json : \(json)")
        }
    }
}


// MARK: Likes
extension NetworkingManager {
    class func likeAction(actionId: String) {
        Alamofire.request(.POST, "\(URL)/likes", parameters: ["actionId": actionId], encoding: .JSON, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("json : \(json)")
        }
    }
    
    class func dislikeAction(actionId: String) {
        Alamofire.request(.DELETE, "\(URL)/likes", parameters: ["actionId": actionId], encoding: .JSON, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("json : \(json)")
        }
    }
}


// MARK: Accepts
extension NetworkingManager {
    class func acceptChallenge(challengeId: String) {
        Alamofire.request(.POST, "\(URL)/accepts", parameters: ["challengeId": challengeId], encoding: .JSON, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("json : \(json)")
        }
    }
    
    class func declineChallenge(challengeId: String) {
        Alamofire.request(.DELETE, "\(URL)/accepts", parameters: ["challengeId": challengeId], encoding: .JSON, headers: headers).responseSwiftyJSON { (request, response, json, error) in
            print("json : \(json)")
        }
    }
}

extension Request {
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, JSON, ErrorType?) -> Void) -> Self {
        return responseJSON { response in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var responseJSON: JSON = JSON.null
                if (response.result.isSuccess) {
                    responseJSON = SwiftyJSON.JSON(response.result.value!)
                }
                dispatch_async(queue ?? dispatch_get_main_queue(), {
                    completionHandler(self.request!, self.response, responseJSON, response.result.error)
                })
            })
        }
    }
}

// MARK: Challenge

extension NetworkingManager {
    static let GetChallengesSuccess = "GetChallengesSuccess"
    static let GetChallengesFailure = "GetChallengesFailure"
    
    class func getChallenges(since: String = "") {
        print("headers : \(headers)")
        Alamofire.request(.GET, "\(URL)/explore/challenges", parameters: ["since" : since], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                if (error == nil) {
                    print("json : \(json)")
                    NSNotificationCenter.defaultCenter().postNotificationName(GetChallengesSuccess, object: Challenge.challengesFromJson(json))
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(GetChallengesFailure, object: error as? NSError ?? nil)
                }
        }
    }
}

extension NetworkingManager {
    static let GetReportsSuccess = "GetReportsSuccess"
    static let GetReportsFailure = "GetReportsFailure"
    
    class func getReports(since: String = "") {
        Alamofire.request(.GET, "\(URL)/explore/reports", parameters: ["since" : since], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                if error == nil {
                    print("json : \(json)")
                    NSNotificationCenter.defaultCenter().postNotificationName(GetReportsSuccess, object: Report.reportsFromJson(json))
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(GetReportsFailure, object: error as? NSError ?? nil)
                }
        }
    }
}
 
*/


extension NetworkingManager {
    static let GetUsersSuccess = "GetUsersSuccess"
    static let GetUsersFailure = "GetUsersFailure"
    
    class func getUsers(since: String = "") {
        let parameters: Parameters = ["since" : since]
        Alamofire.request("\(URL)/explore/users", parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                if response.error == nil {
                    let json = JSON(data: response.data!)
                    print("json : \(json)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: GetUsersSuccess), object: User.usersFromJson(json))
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: GetUsersFailure), object: response.error as NSError?)
                }
        }
    }
}

/*

extension NetworkingManager {
    static let ProfilePublicationsSuccess = "ProfilePublicationsSuccess"
    static let ProfilePublicationsFailure = "ProfilePublicationsFailure"
    
    class func getProfilePublications(userId: String = "", finishBlock: ([Publication]) -> Void, errorBlock: (NSError?) -> Void) {
        print("headers: \(headers)")
        let request = Alamofire.request(.GET, "\(URL)/users/feed/\(userId)", parameters: [:], encoding: .URL, headers: headers)
        
        request.responseSwiftyJSON { (request, response, json, error) in
            print("json : \(json)")
            if error == nil {
                finishBlock(Publication.publicationsFromJson(json))
            } else {
                errorBlock(error as? NSError ?? nil)
            }
        }
    }
    
    static let ProfileActivesSuccess = "ProfileActivesSuccess"
    static let ProfileActivesFailure = "ProfileActivesFailure"
    
    class func getProfileActives(userId: String = "", finishBlock: ([Active] -> Void), errorBlock: (NSError?) -> Void) {
        Alamofire.request(.GET, "\(URL)/users/active/\(userId)", parameters: [:], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("json : \(json)")
                if error == nil {
                    finishBlock(Active.activesFromJson(json))
                } else {
                    errorBlock(error as? NSError ?? nil)
                }
        }
    }
    
    static let ProfileReportsSuccess = "ProfileReportsSuccess"
    static let ProfileReportsFailure = "ProfileReportsFailure"
    
    class func getProfileReports(userId: String = "", finishBlock: ([ProfileReport]) -> Void, errorBlock: (NSError?) -> Void) {
        Alamofire.request(.GET, "\(URL)/users/performed/\(userId)", parameters: [:], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("json : \(json)")
                if error == nil {
                    finishBlock(ProfileReport.profileReportsFromJson(json))
                } else {
                    errorBlock(error as? NSError ?? nil)
                }
        }
    }
}


extension NetworkingManager {
    
    static let ReportSendSuccess = "ReportSendSuccess"
    static let ReportSendFailure = "ReportSendFailure"
    
    class func sendReport(id: String, comment: String, images: [UIImage]) {
        
        var params = [String : String]()
        
        params[JSONColumns.comment] = comment
        params[JSONColumns.acceptId] = id
        
        var imagesData = [NSData]()
        for image in images {
            imagesData.append(UIImagePNGRepresentation(image)!)
        }
        
        
        Alamofire.upload(
            .POST,
            "\(URL)/reports",
            headers:  ["Authorization" : headers["Authorization"]!],
            multipartFormData: { multipartFormData in
                
                for (idx, image) in imagesData.enumerate() {
                    multipartFormData.appendBodyPart(data: image, name: "images", fileName: "\(id)\(idx).png", mimeType: "image/png")
                }
                
                for (key, value) in params {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
        }, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseSwiftyJSON(completionHandler: { (request, response, json, error) in
                    if error != nil && json[JSONColumns.id] != JSON.null {
                        NSNotificationCenter.defaultCenter().postNotificationName(ReportSendSuccess, object: nil)
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName(ReportSendFailure, object: error as? NSError ?? nil)
                    }
                })
                print(upload)
            case .Failure(let encodingError):
                print(encodingError)
                NSNotificationCenter.defaultCenter().postNotificationName(ReportSendFailure, object: encodingError as NSError?)
            }
        }
        )
    }
}


extension NetworkingManager {
    
    static let FollowersUsersSuccess = "FollowersUsersSuccess"
    static let FollowersUsersFailure = "FollowersUsersFailure"
    
    class func followersUsers(userId: String = "") {
        Alamofire.request(.GET, "\(URL)/followers/\(userId)", parameters: [:], encoding: .URL, headers: headers).responseSwiftyJSON { (request, response, json, error) in
            
            print("json : \(json)")
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName(FollowersUsersSuccess, object: User.followersFromJson(json))
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(FollowersUsersFailure, object: error as? NSError ?? nil)
            }
        }
    }
    
    static let FollowingUsersSuccess = "FollowingUsersSuccess"
    static let FollowingUsersFailure = "FollowingUsersFailure"
    
    class func followingUsers(userId: String = "") {
        Alamofire.request(.GET, "\(URL)/followed/\(userId)", parameters: [:], encoding: .URL, headers: headers).responseSwiftyJSON { (request, response, json, error) in
            
            print("json : \(json)")
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName(FollowingUsersSuccess, object: User.followersFromJson(json))
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(FollowingUsersFailure, object: error as? NSError ?? nil)
            }
        }
    }
    
}


extension NetworkingManager {
    
    class func followUser(userId: String) {
        Alamofire.request(.POST, "\(URL)/followings", parameters: ["followedId" : userId], encoding: .JSON, headers: headers).response { (request, response, data, error) in
            if (data != nil) {
                print("data : \(String(data: data!, encoding: NSUTF8StringEncoding))")
            }
            print("error : \(error)")
        }
    }
    
    class func unfollowUser(userId: String) {
        Alamofire.request(.DELETE, "\(URL)/followings", parameters: ["followedId" : userId], encoding: .JSON, headers: headers).response { (request, response, data, error) in
            if (data != nil) {
                print("data : \(String(data: data!, encoding: NSUTF8StringEncoding))")
            }
            print("error : \(error)")
        }
    }
}


extension NetworkingManager {
    
    static let FBLoginSuccess = "FBLoginSuccess"
    static let FBLoginFailure = "FBLoginFailure"
    
    class func loginFB(FBToken: String) {
        Alamofire.request(.POST, "\(URL)/auth/facebook", parameters: [JSONColumns.access_token : FBToken], encoding: .URLEncodedInURL, headers: headers)
            .response { (request, response, data, error) in
                if response?.statusCode == 200,
                    let data = data {
                    
                    let token = String(data: data, encoding: NSUTF8StringEncoding) ?? ""
                    headers["Authorization"] = "JWT \(token)"
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(FBLoginSuccess, object: nil)
                    
                } else {
                    if let data = data {
                        let obj: [String: String] = [
                            "msg": String(data: data, encoding: NSUTF8StringEncoding) ?? ""
                        ]
                        print("facebbok login error :\(obj)")
                        NSNotificationCenter.defaultCenter().postNotificationName(FBLoginFailure, object: obj)
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName(FBLoginFailure, object: nil)
                    }
                }
        }
    }
}

extension NetworkingManager {
    static let GetFollowersSuccess = "getFollowersSuccess"
    static let GetFollowersFailure = "getFollowersFailure"
    
    class func getFollowers(userId: String = "") {
        Alamofire.request(.GET, "\(URL)/followers/\(userId)", parameters: [:], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("json : \(json)")
                if response?.statusCode == 200 {
                    NSNotificationCenter.defaultCenter().postNotificationName(GetFollowersSuccess, object: User.usersFromJson(json))
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(GetFollowersFailure, object: error as? NSError)
                }
        }
    }
    
    static let GetFollowedUsersSuccess = "GetFollowedSuccess"
    static let GetFollowedUsersFailure = "GetFollowedFailure"
    
    class func getFollowed(userId: String = "") {
        Alamofire.request(.GET, "\(URL)/followed/\(userId)", parameters: [:], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("json : \(json)")
                if response?.statusCode == 200 {
                    NSNotificationCenter.defaultCenter().postNotificationName(GetFollowedUsersSuccess, object: User.usersFromJson(json))
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(GetFollowedUsersFailure, object: error as? NSError)
                }
        }
    }
}



extension NetworkingManager {
    class func getDetailedChallenge(challengeId: String, finishBlock: (Challenge) -> Void, errorBlock: (NSError?) -> Void) {
        Alamofire.request(.GET, "\(URL)/challenges/\(challengeId)", parameters: [:], encoding: .URL, headers: headers).responseSwiftyJSON { (request, response, json, error) in
            if response?.statusCode == 200 {
                print("detailed challenge json : \(json)")
                finishBlock(Challenge.detailedChallengeFromJson(json))
            } else {
                errorBlock(error as? NSError ?? nil)
            }
        }
    }
    
    class func likeAction(actionId: String, finishBlock: () -> Void, errorBlock: (NSError?) -> Void) {
        Alamofire.request(.POST, "\(URL)/likes", parameters: [JSONColumns.actionId : actionId], encoding: .JSON, headers: headers).response { (request, response, data, error) in
            print(String(data: data!, encoding: NSUTF8StringEncoding))
            if response?.statusCode == 201 {
                finishBlock()
            } else {
                errorBlock(error)
            }
        }
    }
    
    class func dislikeAction(actionId: String, finishBlock: () -> Void, errorBlock: (NSError?) -> Void) {
        Alamofire.request(.DELETE, "\(URL)/likes", parameters: [JSONColumns.actionId : actionId], encoding: .JSON, headers: headers).response { (request, response, data, error) in
            print(String(data: data!, encoding: NSUTF8StringEncoding))
            if response?.statusCode == 200 {
                finishBlock()
            } else {
                errorBlock(error)
            }
        }
    }
    
    
    class func acceptChallenge(challengeId: String, finishBlock: () -> Void, errorBlock: (NSError?) -> Void) {
        Alamofire.request(.POST, "\(URL)/accepts", parameters: [JSONColumns.challengeId : challengeId], encoding: .JSON, headers: headers).response { (request, response, data, error) in
            print(String(data: data!, encoding: NSUTF8StringEncoding))
            print(response?.statusCode)
            if response?.statusCode == 201 {
                finishBlock()
            } else {
                errorBlock(error)
            }
        }
    }
    
    class func getDetailedReport(reportId: String, finishBlock: (Report) -> Void, errorBlock: (NSError?) -> Void) {
        Alamofire.request(.GET, "\(URL)/reports/\(reportId)", parameters: [:], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("detailed report: \(json)")
                if response?.statusCode == 200 {
                    finishBlock(Report.createOrGetReportFromJson(json))
                } else {
                    errorBlock(error as? NSError ?? nil)
                }
        }
    }
    
    class func getDetailedAccept(acceptId: String, finishBlock: (Accept) -> Void, errorBlock: (NSError?) -> Void) {
        Alamofire.request(.GET, "\(URL)/accepts/\(acceptId)", parameters: [:], encoding: .URL, headers: headers)
            .responseSwiftyJSON { (request, response, json, error) in
                print("detailed accept: \(json)")
                if response?.statusCode == 200 {
                    finishBlock(Accept.getAcceptFromJson(json))
                } else {
                    errorBlock(error as? NSError ?? nil)
                }
        }
    }
}
*/
