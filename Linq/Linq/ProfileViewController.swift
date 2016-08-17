//
//  ProfileViewController.swift
//  Linq
//
//  Created by Apprentice on 8/16/16.
//  Copyright © 2016 Linq Team. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getRequest()
        self.view.backgroundColor = UIColor(red:0.14, green:0.66, blue:0.88, alpha:1.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRequest() {
        print("In Function")
        // Setup the session to make REST GET call.
        let railsGetUsers: String = "https://enigmatic-river-69888.herokuapp.com/api/users"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: railsGetUsers)!
        var currentUser: NSDictionary?
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if NSMutableString(data:data!, encoding: NSUTF8StringEncoding) != nil {
                    // Parse the JSON to get the IP
                    let users = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    //                    print(users)
                    print("$$$$$$$")
                    print(users)
                    for user in users {
                        
                        var sessionId = 2
                        var userId = user["user_id"] as! Int
                            print(userId)
                        if sessionId == userId {
                            //print(user)
                            let firstName = user["first_name"] as! String
                            let lastName = user["last_name"] as! String
                            let fullName = firstName + lastName
                            let title = "Member, Board of Directors - Envolve"
                            let bio = "Coffee Drinker, eReader Addict, Blogger, Philanthropist"
                            let phone = "631-974-7759"
                            let email = user["email"] as! String
                            //print("******")
                            //print(firstName)
                            
                            
                            self.performSelectorOnMainThread(#selector(ProfileViewController.updateUserNameLabel(_:)), withObject: fullName, waitUntilDone: false)
                            self.performSelectorOnMainThread(#selector(ProfileViewController.updateUserTitleLabel(_:)), withObject: title, waitUntilDone: false)
                            self.performSelectorOnMainThread(#selector(ProfileViewController.updateUserBioLabel(_:)), withObject: bio, waitUntilDone: false)
                            self.performSelectorOnMainThread(#selector(ProfileViewController.updateUserEmailLabel(_:)), withObject: email, waitUntilDone: false)
                            self.performSelectorOnMainThread(#selector(ProfileViewController.updateUserPhoneLabel(_:)), withObject: phone, waitUntilDone: false)
                        }
                    }
                }
                
            } catch {
                print("bad things happened")
            }
            
        }).resume()
        
    }
    
    func updateUserNameLabel(text: String) {
        self.userNameLabel.text = text
    }
    
    func updateUserTitleLabel(text: String) {
        self.userTitleLabel.text = text
    }
    
    func updateUserBioLabel(text: String) {
        self.userBioLabel.text = "'" + text + "'"
    }
    
    func updateUserEmailLabel(text: String) {
        self.userEmailLabel.text = text
    }
    func updateUserPhoneLabel(text: String) {
        self.userPhoneLabel.text = text
    }



}
