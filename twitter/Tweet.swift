//
//  Tweet.swift
//  twitter
//
//  Created by Kwaku Owusu on 2/23/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileName: String?
    var profileImageUrl: String?
    init(dictionary: NSDictionary){
        let userInfo = dictionary["user"] as! NSDictionary
        profileName = userInfo["name"] as? String
        profileImageUrl = userInfo["profile_image_url_https"] as? String
        
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweetCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
    
        if let timeStampString = timeStampString{
            let formatter = NSDateFormatter()
            
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timeStamp = formatter.dateFromString(timeStampString)

        }

    }

    class func tweetsWithArray(dictionaries: [NSDictionary])-> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            
        }
        
        return tweets
    }
}
