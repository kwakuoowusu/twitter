//
//  DetailViewController.swift
//  twitter
//
//  Created by Kwaku Owusu on 3/5/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit
import AFNetworking
import TimeAgoInWords
class DetailViewController: UIViewController {

    /*
@IBOutlet weak var profileImageView: UIImageView!

@IBOutlet weak var userRetweetLabel: UILabel!
@IBOutlet weak var profileName: UILabel!
@IBOutlet weak var userName: UILabel!
@IBOutlet weak var timeStampLabel: UILabel!

@IBOutlet weak var likeLabel: UILabel!
@IBOutlet weak var retweetLabel: UILabel!
@IBOutlet weak var tweetLabel: UILabel!

@IBOutlet weak var retweetButton: UIButton!

@IBOutlet weak var likeButton: UIButton!
*/
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userRetweetLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var tweet: Tweet!
    var retweeted: Bool!
    var liked: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userRetweetLabel.text = ""
        
        profileImageView.setImageWithURL(NSURL(string:tweet.profileImageUrl!)!)
        
        self.profileName.text = tweet.profileName!
        self.profileName.sizeToFit()
        
        self.userName.text = tweet.screenName!
        self.userName.sizeToFit()
        self.retweetLabel.text = "\(tweet.retweetCount)"
        self.retweetLabel.sizeToFit()
        self.likeLabel.text = "\(tweet.favoritesCount)"
        self.likeLabel.sizeToFit()
        
        self.descriptionLabel.text = tweet.text!
        self.descriptionLabel.sizeToFit()
    
        let timeStamp = tweet.timeStamp!
        
        let railsStrings = [
            "LessThan": "",
            "About": "",
            "Over": "",
            "Almost": "almost ",
            "Seconds": "s",
            "Minute": "m",
            "Minutes": "m",
            "Hour": "h",
            "Hours": "h",
            "Day": "d",
            "Days": "d",
            "Months": "m",
            "Years": "y",
        ]
        TimeAgoInWordsStrings.updateStrings(railsStrings)
        
        let timeAgo = timeStamp.timeAgoInWords()
        self.timeStampLabel.text = timeAgo
        
        
    }

    
    @IBAction func onRetweetPressed(sender: AnyObject) {
        
        self.retweeted = tweet.retweeted
        
        if (!self.retweeted){
            let button = sender as! UIButton
            
            
            let image = UIImage(named: "retweet-action-on") as UIImage!
            TwitterClient.sharedInstance.retweet(["id": tweet.tweetId!], success: { (tweets, error) -> () in
                
                if tweets != nil{
                    self.tweet.retweeted = true
                    self.retweeted = true
                    button.setImage(image, forState: .Normal)
                    self.tweet.retweetCount+=1
                    self.retweetLabel.text = self.tweet.retweetCount.description
                }
                
                }) { (error: NSError) -> () in
                    print(error.description)
            }
        }

    }
    
    @IBAction func onLikePressed(sender: AnyObject) {
        
        
        self.liked = tweet.liked
        
        if (!self.liked){
            let button = sender as! UIButton
            
            let image = UIImage(named: "like-action-on") as UIImage!
            
            TwitterClient.sharedInstance.like(["id":tweet.tweetId!], success: { (likeSuccess, error) -> () in
                
                if (likeSuccess){
                    self.tweet.liked = true
                    self.liked = true
                    button.setImage(image, forState: .Normal)
                    
                    self.tweet.favoritesCount+=1
                    self.likeLabel.text = self.tweet.favoritesCount.description
                    
                }
                
                }, failure: { (error: NSError) -> () in
                    print(error.description)
            })
            
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReplySegue" {
            let ReplyController = segue.destinationViewController as! ReplyViewController
            
            
            ReplyController.screenNameReply = self.userName.text!
            ReplyController.id = self.tweet.tweetId as Int!
            print("hello")
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
