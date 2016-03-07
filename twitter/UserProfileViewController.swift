//
//  UserProfileViewController.swift
//  twitter
//
//  Created by Kwaku Owusu on 3/6/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var totalTweetLabel: UILabel!
    @IBOutlet weak var totalFollowersLabel: UILabel!
    @IBOutlet weak var totalFollowingLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var maxID = 0
    var profileName: String!
    var screenName: String!
    var profileImageUrl: String!
    var backgroundImageUrl: String!
    var totalTweets = 0
    var followerCount = 0
    var followingCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.setImageWithURL(NSURL(string:self.profileImageUrl)!)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true

        self.backgroundImageView.setImageWithURL(NSURL(string:self.backgroundImageUrl)!)
        self.totalTweetLabel.text = "\(totalTweets)"
        self.totalTweetLabel.sizeToFit()
        self.totalFollowersLabel.text = "\(followerCount)"
        self.totalFollowersLabel.sizeToFit()
        self.totalFollowingLabel.text = "\(followingCount)"
        self.totalFollowingLabel.sizeToFit()
        
        self.userNameLabel.text = self.profileName
        self.userNameLabel.sizeToFit()
        
        
        TwitterClient.sharedInstance.userTimeline(screenName, success: { (tweets: [Tweet]) -> () in
            
            self.tweets = tweets
            self.maxID = self.tweets[self.tweets.count-1].tweetId as! Int
            self.tableView.reloadData()

            }) { (error: NSError) -> () in
                print(error.description)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.selectionStyle = .None
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil{
            return  tweets.count
        } else {
            return 0
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        
        TwitterClient.sharedInstance.userTimeline(screenName, success: { (tweets: [Tweet]) -> () in
            
            self.tweets = tweets
            self.maxID = self.tweets[self.tweets.count-1].tweetId as! Int
            self.tableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.description)
        }
    }
    
    var isMoreDataLoading = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func loadMoreData(){
        
       
        TwitterClient.sharedInstance.getOlderUserTweets(self.screenName, id: "\(self.maxID)", success: { (success: [Tweet]) -> () in
            
            for tweet in success{
                self.tweets.append(tweet)
            }
            
            self.isMoreDataLoading = false
            self.maxID = self.tweets[self.tweets.count-1].tweetId as! Int

            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.description)
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
