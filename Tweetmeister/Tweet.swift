//
//  Tweet.swift
//  Tweetmeister
//
//  Created by Patwardhan, Saurabh on 10/25/16.
//  Copyright © 2016 Saurabh Patwardhan. All rights reserved.
//

import UIKit
import SwiftyJSON


// should get : user profile picture, username, tweet text, and timestamp. I

class Tweet: NSObject {
    
    var name : String
    var username: String
    var text : String?
    var profileImageUrl : URL?
    var timestamp : Date?
    var retweetCount : Int = 0
    var retweeted : Int? = 0
    var favoritesCount : Int = 0
    var favorited : Int? = 0
    var verified : Bool?
    var id : Int64 = 0
    
    var tweetJSON : JSON
    
    init(dictionary: NSDictionary) {
        self.tweetJSON = JSON(dictionary)
        self.name = tweetJSON["user"]["name"].string!
        self.username = "@" + tweetJSON["user"]["screen_name"].string!
        text = tweetJSON["text"].string?.replacingOccurrences(of: "&amp;", with: "&")
        retweetCount = (tweetJSON["retweet_count"].int) ?? 0
        favoritesCount = (tweetJSON["favorite_count"].int) ?? 0
        favorited = tweetJSON["favorited"].int
        id = (tweetJSON["id"].int64)!
        retweeted = tweetJSON["retweeted"].int
        
        verified = tweetJSON["user"]["verified"].bool
        
        if let retweeted = retweeted{
            if(retweeted == 1){
                print("--- Retweeted  by user")
            }
        }
        
        if let profileUrlString = tweetJSON["user"]["profile_image_url_https"].string{
            profileImageUrl = URL(string : profileUrlString)
        }
        
        let timestampString = tweetJSON["created_at"].string

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        
        print("-- tweet : name : \(name)")
        print("-- tweet : username : \(username)")
        print("-- tweet : verified : \(verified)")
        print("-- tweet : retweet count : \(retweetCount)")
        print("-- tweet : fav count : \(favoritesCount)")
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
