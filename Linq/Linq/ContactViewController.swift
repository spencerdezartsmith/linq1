//
//  ContactViewController.swift
//  Linq
//
//  Created by Apprentice on 8/15/16.
//  Copyright © 2016 Linq Team. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactTitleLabel: UILabel!
    @IBOutlet weak var contactBioLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.14, green:0.66, blue:0.88, alpha:1.0)
        getRequest()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRequest() {
        // Setup the session to make REST GET call.
        let railsGetUsers: String = "https://enigmatic-river-69888.herokuapp.com/users"
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
                    
                    for user in users {
                        //session is hard coded
                        var sessionId = 1
                        var userId = user["id"] as! Int
                        if sessionId == userId {
                            let firstName = user["first_name"] as! String
                            let lastName = user["last_name"] as! String
                            let fullName = firstName + " " + lastName
                            let title = "NY Photographer"
                            let bio = "Have Camera, Will Travel. Capturing life one click at a time."
                            let phone = "631-928-5048"
                            let email = user["email"] as! String
                            
                            self.performSelectorOnMainThread(#selector(ContactViewController.updateContactNameLabel(_:)), withObject: fullName, waitUntilDone: false)
                            self.performSelectorOnMainThread(#selector(ContactViewController.updateContactTitleLabel(_:)), withObject: title, waitUntilDone: false)
                            self.performSelectorOnMainThread(#selector(ContactViewController.updateContactBioLabel(_:)), withObject: bio, waitUntilDone: false)
                            self.performSelectorOnMainThread(#selector(ContactViewController.updateContactEmailLabel(_:)), withObject: email, waitUntilDone: false)
                            self.performSelectorOnMainThread(#selector(ContactViewController.updateContactPhoneLabel(_:)), withObject: phone, waitUntilDone: false)
                        }
                    }
                }
                
            } catch {
                print("bad things happened")
            }
            
        }).resume()
        
    }
    
    func updateContactNameLabel(text: String) {
        self.contactNameLabel.text = text
    }
    
    func updateContactTitleLabel(text: String) {
        self.contactTitleLabel.text = text
    }
    
    func updateContactBioLabel(text: String) {
        self.contactBioLabel.text = "'" + text + "'"
    }
    
    func updateContactEmailLabel(text: String) {
        self.contactEmailLabel.text = text
    }
    func updateContactPhoneLabel(text: String) {
        self.contactPhoneLabel.text = text
    }


}
