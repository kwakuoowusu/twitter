//
//  ComposeViewController.swift
//  twitter
//
//  Created by Kwaku Owusu on 3/6/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var composeView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var screenName: String!
    var userName: String!
    var profileImageUrl: NSURL!
    var count = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            
            self.profileImageUrl = user.profileUrl
            self.profileImageView.setImageWithURL(self.profileImageUrl)
            self.screenNameLabel.text = "@\(user.screenname!)"
            self.userNameLabel.text  = user.name as String!
            
            }) { (error: NSError) -> () in
                print(error.description)
        }
    

        self.screenNameLabel.text = self.screenName
        self.characterCountLabel.text = "\(self.count)"
        
        self.composeView.delegate = self
        self.composeView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        
        self.count = 140 - composeView.text!.characters.count
        
        self.characterCountLabel.text = "\(count)"
        
        
        
    }

    @IBAction func onPost(sender: AnyObject) {
        let percentAddr = self.composeView.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)

        TwitterClient.sharedInstance.tweet(percentAddr!) { (tweet, error) -> () in
            if(tweet != nil){
                self.navigationController?.popViewControllerAnimated(true)
                
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
