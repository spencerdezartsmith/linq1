//
//  ContactTableViewController.swift
//  Linq
//
//  Created by Apprentice on 8/15/16.
//  Copyright © 2016 Linq Team. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    

    var contactNames: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.14, green:0.66, blue:0.88, alpha:1.0)
        getRequest()
        if let contacts = NSUserDefaults.standardUserDefaults().objectForKey("contacts"){
            print("We did it:\(contacts)")
        }
        print("&&&&")
        print("contacts")
        print("*****")
        print(NSUserDefaults.standardUserDefaults().objectForKey("contacts")!)

        self.refreshControl?.addTarget(self, action: #selector(ContactTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        getRequest()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return contactNames.count
        return (NSUserDefaults.standardUserDefaults().objectForKey("contacts")!).count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath)
        //let contactName = contactNames[indexPath.row]
        let contactName = (NSUserDefaults.standardUserDefaults().objectForKey("contacts")!) as! NSArray
        let array = contactName[indexPath.row]
//        if let nameLabel = self.view.viewWithTag(88) as? UILabel {
//            nameLabel.text = contactName
//        }
        if let nameLabel = self.view.viewWithTag(88) as? UILabel {
            nameLabel.text = array as! String
        }

        return cell
    }
    
    //MARK: - REST calls
    // This makes the GET call to httpbin.org. It simply gets the IP address and displays it on the screen.
    func getRequest() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let userIdParam = 2
        let railsGetUsers: String = "https://enigmatic-river-69888.herokuapp.com/users/\(userIdParam)/contacts"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: railsGetUsers)!
        print(session)
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in

            do {
                if let allUsers = NSMutableString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    
                    // Parse the JSON to get the IP
                    var contacts = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray

                    for contact in contacts {
                        var id = contact["id"] as! NSInteger
                        
                            print("current contacts")
                            print(contact)
                            var name = contact["first_name"] as! String
                            var email = contact["email"] as! String
                        
                            self.contactNames.append(name)
                        
                            
                    }
                    NSUserDefaults.standardUserDefaults().setObject(self.contactNames, forKey: "contacts")
                    NSUserDefaults.standardUserDefaults().synchronize()

                }

                
            } catch {
                print("bad things happened")
            }
        }).resume()

        
    }




}
