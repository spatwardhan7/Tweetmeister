//
//  User.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/25/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = "UserDidLogout"

    var name : String?
    var screenName : String?
    var profileUrl : URL?
    var tagline : String?
    var dictionary : NSDictionary?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string : profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    
    // _ hidden by convention
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil  {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData{
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try!  JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey : "currentUserData")
            } else {
                defaults.set(nil, forKey : "currentUserData")
                
            }
            defaults.synchronize()
        }
    }
}
