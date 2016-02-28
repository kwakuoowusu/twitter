//
//  TweetCell.swift
//  twitter
//
//  Created by Kwaku Owusu on 2/26/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit
import AFNetworking
import TimeAgoInWords

class TweetCell: UITableViewCell {

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
    
    var id: Int?
    var tweet: Tweet!{
        didSet{
            
            if (tweet.liked){
                let image = UIImage(named: "like-action-on") as UIImage!
                likeButton.setImage(image, forState: .Normal)
            }
            if(tweet.retweeted){
                let image = UIImage(named: "retweet-action-on") as UIImage!
                retweetButton.setImage(image, forState: .Normal)
            }
            self.userRetweetLabel.text = ""
            self.tweetLabel.text = tweet.text
            tweetLabel.sizeToFit()

            self.profileName.text = tweet.profileName
            self.profileName.sizeToFit()

            self.userName.text = tweet.screenName
            self.retweetLabel.text = tweet.retweetCount.description
            retweetLabel.sizeToFit()

            self.likeLabel.text = tweet.favoritesCount.description
            likeLabel.sizeToFit()

            let profileImageString = tweet.profileImageUrl
            
            if (profileImageString != nil){
                
                profileImageView.setImageWithURL(NSURL(string:profileImageString!)!)
                
                self.profileImageView.layer.cornerRadius = 3
                self.profileImageView.clipsToBounds = true

            }
            let timeStamp = tweet.timeStamp
            if let timeStamp = timeStamp{
                
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
                timeStampLabel.text = timeAgo
                
            }
            self.timeStampLabel.sizeToFit()

            
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        profileName.preferredMaxLayoutWidth = profileName.frame.size.width
        retweetLabel.preferredMaxLayoutWidth = retweetLabel.frame.size.width
        likeLabel.preferredMaxLayoutWidth = likeLabel.frame.size.width
        timeStampLabel.preferredMaxLayoutWidth = timeStampLabel.frame.size.width

        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        profileName.preferredMaxLayoutWidth = profileName.frame.size.width
        retweetLabel.preferredMaxLayoutWidth = retweetLabel.frame.size.width
        likeLabel.preferredMaxLayoutWidth = likeLabel.frame.size.width
        timeStampLabel.preferredMaxLayoutWidth = timeStampLabel.frame.size.width
        
    }

   
    @IBAction func onRetweetPressed(sender: AnyObject) {
        
        if (!tweet.retweeted){
            let button = sender as! UIButton
            
            
            let image = UIImage(named: "retweet-action-on") as UIImage!
            TwitterClient.sharedInstance.retweet(["id": tweet.tweetId!], success: { (tweets, error) -> () in
            
                if tweets != nil{
                    self.tweet.retweeted = true
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
        
        if (!tweet.liked){
            let button = sender as! UIButton
            
            let image = UIImage(named: "like-action-on") as UIImage!
            
            TwitterClient.sharedInstance.like(["id":tweet.tweetId!], success: { (liked, error) -> () in
                
                print(liked)
                if (liked){
                    self.tweet.liked = true
                    button.setImage(image, forState: .Normal)
                    
                    self.tweet.favoritesCount+=1
                    self.likeLabel.text = self.tweet.favoritesCount.description
                }
                
                }, failure: { (error: NSError) -> () in
                    print(error.description)
            })
            
        }
       
        
        
        
        
    }
   

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
