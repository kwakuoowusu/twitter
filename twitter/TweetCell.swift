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
    
    var tweet: Tweet!{
        didSet{
            
            
        
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
    @IBAction func onRetweetPressed(sender: AnyObject) {
        print("hello")
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

   
   

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
