//
//  ComposeViewController.swift
//  Linq
//
//  Created by spencerdezartsmith on 8/16/16.
//  Copyright © 2016 Linq Team. All rights reserved.
//


import UIKit

protocol SelfieComposeDelegate {
    func reloadCollectionViewWithSelfie(selfieImgObject: SelfieImage)
}

class ComposeViewController: UIViewController {
    @IBOutlet weak var thumbImgView: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var thumbImg : UIImage!
    var composeDelegate:SelfieComposeDelegate! = nil
    let httpHelper = HTTPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setNavigationItems() {
        self.title = "Compose"
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelBtnTapped"))
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        let postBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("postBtnTapped"))
        self.navigationItem.rightBarButtonItem = postBarButtonItem
    }
    
    func cancelBtnTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
        // hide activityIndicator view and display alert message
        self.activityIndicatorView.hidden = true
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }
    
    func postBtnTapped() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
