//
//  User.swift
//  twitter
//
//  Created by Kwaku Owusu on 2/23/16.
//  Copyright © 2016 kwaku owusu. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    init(dictionary:NSDictionary){
        /*
        //let user = response as! NSDictionary
        print ("user: \(user)")
        print("name: \(user["name"])")
        print("screenname: \(user["screen_name"])")
        print("profile url: \(user["profile_image_url_https"])")
        print("description \(user["description"])")
        */
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
       
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
            
        }
        tagline = dictionary["description"] as? String
    }
}
