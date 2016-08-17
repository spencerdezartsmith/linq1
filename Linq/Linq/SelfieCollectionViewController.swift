//
//  SelfieCollectionViewController.swift
//  Linq
//
//  Created by spencerdezartsmith on 8/16/16.
//  Copyright © 2016 Linq Team. All rights reserved.
//

import UIKit

let reuseIdentifier = "SelfieCollectionViewCell"

class SelfieCollectionViewController: UICollectionViewController {
    
    var shouldFetchNewData = true
    var dataArray = [SelfieImage]()
    let httpHelper = HTTPHelper()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("userLoggedIn") == nil {
            if let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
                self.navigationController?.presentViewController(loginController, animated: true, completion: nil)
            }
        } else {
            // check if API token has expired
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let userTokenExpiryDate : String? = KeychainAccess.passwordForAccount("Auth_Token_Expiry", service: "KeyChainService")
            let dateFromString : NSDate? = dateFormatter.dateFromString(userTokenExpiryDate!)
            let now = NSDate()
            
            let comparision = now.compare(dateFromString!)
            
            // check if should fetch new data
            if shouldFetchNewData {
                shouldFetchNewData = false
                self.setNavigationItems()
                loadSelfieData()
            }
            
            // logout and ask user to sign in again if token is expired
            if comparision != NSComparisonResult.OrderedAscending {
                self.logoutBtnTapped()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationItems() {
        var logOutBtn = UIBarButtonItem(title: "logout", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logoutBtnTapped"))
        self.navigationItem.leftBarButtonItem = logOutBtn
        
        var navCameraBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: Selector("cameraBtnTapped"))
        self.navigationItem.rightBarButtonItem = navCameraBtn
    }
    
    
    // 1. Clears the NSUserDefaults flag
    func clearLoggedinFlagInUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("userLoggedIn")
        defaults.synchronize()
    }
    
    // 2. Removes the data array
    func clearDataArrayAndReloadCollectionView() {
        self.dataArray.removeAll(keepCapacity: true)
        self.collectionView?.reloadData()
    }
    
    // 3. Clears API Auth token from Keychain
    func clearAPITokensFromKeyChain () {
        // clear API Auth Token
        if let userToken = KeychainAccess.passwordForAccount("Auth_Token", service: "KeyChainService") {
            KeychainAccess.deletePasswordForAccount(userToken, account: "Auth_Token", service: "KeyChainService")
        }
        
        // clear API Auth Expiry
        if let userTokenExpiryDate = KeychainAccess.passwordForAccount("Auth_Token_Expiry",
                                                                       service: "KeyChainService") {
            KeychainAccess.deletePasswordForAccount(userTokenExpiryDate, account: "Auth_Token_Expiry",
                                                    service: "KeyChainService")
        }
    }
    
    func logoutBtnTapped() {
        clearLoggedinFlagInUserDefaults()
        clearDataArrayAndReloadCollectionView()
        clearAPITokensFromKeyChain()
        
        // Set flag to display Sign In view
        shouldFetchNewData = true
        self.viewDidAppear(true)
    }
    
    func cameraBtnTapped() {
        displayCameraControl()
    }
    
    func loadSelfieData () {
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest("get_photos", method: "GET",
                                                  authType: HTTPRequestAuthType.HTTPTokenAuth)
        
        // Send HTTP request to load existing selfie
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                let errorAlert = UIAlertView(title:"Error", message:errorMessage as String, delegate:nil, cancelButtonTitle:"OK")
                errorAlert.show()
                
                return
            }
            
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                if let selfies = jsonData as? [[String: AnyObject]] {
                    for imageDataDict in selfies {
                        let selfieImgObj = SelfieImage()
                        
                        if let title = imageDataDict["title"] as? String {
                            selfieImgObj.imageTitle = title
                        }
                        if let random_id = imageDataDict["random_id"] as? String {
                            selfieImgObj.imageId = random_id
                        }
                        if let image_url = imageDataDict["image_url"] as? String {
                            selfieImgObj.imageThumbnailURL = image_url
                        }
                        self.dataArray.append(selfieImgObj)
                    }
                    
                    self.collectionView?.reloadData()
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        })
    }
    
    
    // This is in the base SelfieCollectionViewController class implementation
    func removeObject<T:Equatable>(inout arr:Array<T>, object:T) -> T? {
        if let indexOfObject = arr.indexOf(object) {
            return arr.removeAtIndex(indexOfObject)
        }
        return nil
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,forIndexPath: indexPath) as! SelfieCollectionViewCell
        
        // Configure the cell
        let rowIndex = self.dataArray.count - (indexPath.row + 1)
        let selfieRowObj = self.dataArray[rowIndex] as SelfieImage
        
        cell.backgroundColor = UIColor.blackColor()
        cell.selfieTitle.text = selfieRowObj.imageTitle
        
        let imgURL: NSURL = NSURL(string: selfieRowObj.imageThumbnailURL)!
        
        // Download an NSData representation of the image at the URL
        
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error == nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.selfieImgView.image = image
                    })
                }
            } else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
        })
        
        task.resume()
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // fetch the Selfie Image Object
        let rowIndex = self.dataArray.count - (indexPath.row + 1)
        let selfieRowObj = self.dataArray[rowIndex] as SelfieImage
        
        pushDetailsViewControllerWithSelfieObject(selfieRowObj)
    }
}

// Camera Extension

extension SelfieCollectionViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func displayCameraControl() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            
            if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front) {
                imagePickerController.cameraDevice = UIImagePickerControllerCameraDevice.Front
            } else {
                imagePickerController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            }
        } else {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // dismiss the image picker controller window
        self.dismissViewControllerAnimated(true, completion: nil)
        
        var image:UIImage
        
        // fetch the selected image
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        } else {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        presentComposeViewControllerWithImage(image)
    }
}

// Compose Selfie Extension

extension SelfieCollectionViewController : SelfieComposeDelegate {
    func presentComposeViewControllerWithImage(image:UIImage!) {
        // instantiate compose view controller to capture a caption
        if let composeVC: ComposeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ComposeViewController") as? ComposeViewController {
            composeVC.composeDelegate = self
            composeVC.thumbImg = image
            
            // set the navigation controller of compose view controlle
            let composeNavVC = UINavigationController(rootViewController: composeVC)
            
            // present compose view controller
            self.navigationController?.presentViewController(composeNavVC, animated: true, completion: nil)
        }
    }
    
    func reloadCollectionViewWithSelfie(selfieImgObject: SelfieImage) {
        self.dataArray.append(selfieImgObject)
        self.collectionView?.reloadData()
    }
}

// Selfie Details Extension

extension SelfieCollectionViewController : SelfieEditDelegate {
    
    func pushDetailsViewControllerWithSelfieObject(selfieRowObj:SelfieImage!) {
        // instantiate detail view controller
        if let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController {
            detailVC.editDelegate = self
            detailVC.selfieCustomObj = selfieRowObj
            
            // push detail view controller to the navigation stack
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // This is in edit selfie extension
    func deleteSelfieObjectFromList(selfieImgObject: SelfieImage) {
        if self.dataArray.contains(selfieImgObject) {
            removeObject(&self.dataArray, object: selfieImgObject)
            self.collectionView?.reloadData()
        }
    }
}
