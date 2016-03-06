//
//  ReplyViewController.swift
//  twitter
//
//  Created by Kwaku Owusu on 3/6/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var replyField: UITextView!
    
    @IBOutlet weak var characterLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var profileUrl: NSURL!
    var replied = false
    var screenNameReply: String!
    var count = 140
    var id = 0
    
    let alertController = UIAlertController!()
    
    override func viewDidLoad() {
        
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            
                self.profileUrl = user.profileUrl
                self.profileImageView.setImageWithURL(self.profileUrl)
                self.screenNameLabel.text = "@\(user.screenname!)"
                self.userNameLabel.text  = user.name as String!
                
            }) { (error: NSError) -> () in
                print(error.description)
        }
        super.viewDidLoad()
        self.replyField.delegate = self

        self.replyField.text = screenNameReply!
        self.replyField.becomeFirstResponder()
        
        self.characterLabel.text = "\(count - self.replyField.text.characters.count)"
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetButtonPressed(sender: AnyObject) {
        if (!replied){
        let percentAddr = self.replyField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        
        TwitterClient.sharedInstance.reply(["tweet": percentAddr!, "id": self.id]) { (tweet, error) -> () in
            print("Tweeted")
            
           

            }
        }
    }
    func textViewDidChange(textView: UITextView) {
      
            self.count = 140 - replyField.text!.characters.count
            
            self.characterLabel.text = "\(count)"
        
            print(count)
    

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
