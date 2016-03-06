//
//  TweetsViewController.swift
//  twitter
//
//  Created by Kwaku Owusu on 2/25/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    var maxId: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.maxId = self.tweets[self.tweets.count-1].tweetId as! Int
            self.tableView.reloadData()

            }) { (error:NSError) -> () in
                print(error.localizedDescription)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
            }) { (error:NSError) -> () in
                print(error.localizedDescription)

        }
    }
    

    @IBAction func onLogoutButton(sender: AnyObject) {
        User.currentUser = nil
        TwitterClient.sharedInstance.logout()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
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
        
        TwitterClient.sharedInstance.getOlderTweets(self.maxId, success: { (success: [Tweet]) -> () in
            
            for tweet in success{
                self.tweets.append(tweet)
            }
            
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.description)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                let detailController = segue.destinationViewController as! DetailViewController
                
                let tweet = tweets[indexPath.row]
                
                detailController.tweet = tweet
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        
        if segue.identifier == "replyFromTweetView" {
            let button = sender as! UIButton
            let content = button.superview! as UIView
            let cell = content.superview as! UITableViewCell
            
            if let indexPath = tableView.indexPathForCell(cell) {
                let replyController = segue.destinationViewController as! ReplyViewController
                
                let tweet = tweets[indexPath.row]
                
                let screenName = tweet.screenName!
                replyController.screenNameReply = screenName
                
                replyController.id = tweet.tweetId as Int!
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
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
