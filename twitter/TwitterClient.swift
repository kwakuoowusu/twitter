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
    
    var loginSucess: (() -> ())?
    
    var loginFailure: ((NSError) -> ())?
    
    func login(success: ()-> (), failure: (NSError) -> ()){
        
        loginSucess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"mytwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            let url = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            })  { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }

    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                    User.currentUser = user
                    self.loginSucess?()

                }, failure: { (error:NSError) -> () in
                        self.loginFailure?(error)
            })
            
            
            }) { (error: NSError!) -> Void in
                print("\(error.description)")
                self.loginFailure?(error)
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let dictionaries  = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            })
    }
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }

    func retweet(dictionary: NSDictionary?, success: (tweets:Tweet?, error: NSError?)->(), failure: (NSError)-> ()){
        POST("1.1/statuses/retweet/\(dictionary!["id"] as! Int).json", parameters: dictionary, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("success")
                let tweet = Tweet.returnAsDictionary(response as! NSDictionary)
                success(tweets:tweet, error: nil)
            
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            
                print(error.description)
                
        }
    }
  
    func like(dictionary: NSDictionary?, success: (liked: Bool, error: NSError?)->(), failure: (NSError)-> ()){
    POST("1.1/favorites/create.json", parameters: dictionary, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) -> Void in
        
        success(liked: true, error: nil)
        
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.description)
    }
    }
    /*
    func favorite(params: NSDictionary?, completion: (retweeted: Bool, error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            
            completion(retweeted: true, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(retweeted: false, error: NSError?), error: error)
        }
    }
*/

}
