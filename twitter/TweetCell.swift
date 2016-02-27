//
//  TweetCell.swift
//  twitter
//
//  Created by Kwaku Owusu on 2/26/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit
import AFNetworking
class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userRetweetLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var tweet: Tweet!{
        didSet{
            
            self.tweetLabel.text = tweet.text
            tweetLabel.sizeToFit()
            
            self.profileName.text = tweet.profileName
            self.profileName.sizeToFit()
            
            let profileImageString = tweet.profileImageUrl
            
            if (profileImageString != nil){
                print (profileImageString!)
                
                profileImageView.setImageWithURL(NSURL(string:profileImageString!)!)
                
                self.profileImageView.layer.cornerRadius = 3
                self.profileImageView.clipsToBounds = true

            }
            self.timeStampLabel.text = tweet.timeStamp?.description
            self.timeStampLabel.sizeToFit()
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
