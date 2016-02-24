//
//  TwitterClient.swift
//  twitter
//
//  Created by Kwaku Owusu on 2/24/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string:"https://api.twitter.com")!, consumerKey: "V8WOqOnQcW5QtzbJsI5GftJM6", consumerSecret: "FJxoGYcI842ruIEBzBGoiYaVGAS0TsDHIZDXnunSXzliSPBsO3")
    
    
    func currentAccount(){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            print("description \(user.tagline)")
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error\(error.description)")
        })
    }
    
    //8:45
    func homeTimeLine(success: (success: [Tweet] -> (), failure: (NSError)->())){
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    failure(error)
        })
    }
}
