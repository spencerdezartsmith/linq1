import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signinBackgroundView: UIView!
    @IBOutlet weak var signupBackgroundView: UIView!
    @IBOutlet weak var signinEmailTextField: UITextField!
    @IBOutlet weak var signinPasswordTextField: UITextField!
    @IBOutlet weak var signupNameTextField: UITextField!
    @IBOutlet weak var signupEmailTextField: UITextField!
    @IBOutlet weak var signupPasswordTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var passwordRevealBtn: UIButton!
    
    let httpHelper = HTTPHelper()
    
    
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.activityIndicatorView.layer.cornerRadius = 10
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
       
    }
    
    
    @IBAction func saveButtonClick(sender: AnyObject) {
        let defaults = `NSUserDefaults`.standardUserDefaults()
        defaults.setObject(userEmail.text, forKey: "userEmail")
        defaults.synchronize()
        
        print("userEmail=\(userEmail)")
    }
    
    @IBAction func clearButton(sender: AnyObject) {
        if(userEmail.text == ""){
            loadDefaults()
            clearButton.setTitle("Clear", forState: .Normal)
        }
        else {
            userEmail.text = ""
            clearButton.setTitle("Load", forState: .Normal)
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func loadDefaults() {
        let defaults = `NSUserDefaults`.standardUserDefaults()
        userEmail.text = defaults.objectForKey("userEmail") as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordRevealBtnTapped(sender: AnyObject) {
        self.passwordRevealBtn.selected = !self.passwordRevealBtn.selected
        
        if self.passwordRevealBtn.selected {
            self.signupPasswordTextField.secureTextEntry = false
        } else {
            self.signupPasswordTextField.secureTextEntry = true
        }
    }
    
    func displaSigninView () {
        self.signinEmailTextField.text = nil
        self.signinPasswordTextField.text = nil
        
        if self.signupNameTextField.isFirstResponder() {
            self.signupNameTextField.resignFirstResponder()
        }
        
        if self.signupEmailTextField.isFirstResponder() {
            self.signupEmailTextField.resignFirstResponder()
        }
        
        if self.signupPasswordTextField.isFirstResponder() {
            self.signupPasswordTextField.resignFirstResponder()
        }
        
        if self.signinBackgroundView.frame.origin.x != 0 {
            UIView.animateWithDuration(0.8, animations: { () -> Void in
                self.signupBackgroundView.frame = CGRectMake(320, 134, 320, 284)
                self.signinBackgroundView.alpha = 0.3
                
                self.signinBackgroundView.frame = CGRectMake(0, 134, 320, 284)
                self.signinBackgroundView.alpha = 1.0
                }, completion: nil)
        }
    }
    
    func displaySignupView () {
        self.signupNameTextField.text = nil
        self.signupEmailTextField.text = nil
        self.signupPasswordTextField.text = nil
        
        if self.signinEmailTextField.isFirstResponder() {
            self.signinEmailTextField.resignFirstResponder()
        }
        
        if self.signinPasswordTextField.isFirstResponder() {
            self.signinPasswordTextField.resignFirstResponder()
        }
        
        if self.signupBackgroundView.frame.origin.x != 0 {
            UIView.animateWithDuration(0.8, animations: { () -> Void in
                self.signinBackgroundView.frame = CGRectMake(-320, 134, 320, 284)
                self.signinBackgroundView.alpha = 0.3;
                
                self.signupBackgroundView.frame = CGRectMake(0, 134, 320, 284)
                self.signupBackgroundView.alpha = 1.0
                
                }, completion: nil)
        }
    }
    
    func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
        // hide activityIndicator view and display alert message
        self.activityIndicatorView.hidden = true
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }
    
    @IBAction func createAccountBtnTapped(sender: AnyObject) {
        self.displaySignupView()
    }
    
    @IBAction func cancelBtnTapped(sender: AnyObject) {
        self.displaSigninView()
    }
    
    
    @IBAction func signupBtnTapped(sender: AnyObject) {
        // Code to hide the keyboards for text fields
        if self.signupNameTextField.isFirstResponder() {
            self.signupNameTextField.resignFirstResponder()
        }
        
        if self.signupEmailTextField.isFirstResponder() {
            self.signupEmailTextField.resignFirstResponder()
        }
        
        if self.signupPasswordTextField.isFirstResponder() {
            self.signupPasswordTextField.resignFirstResponder()
        }
        
        // start activity indicator
        self.activityIndicatorView.hidden = false
        
        // validate presence of all required parameters
        if self.signupNameTextField.text != "" && self.signupEmailTextField.text != "" && self.signupPasswordTextField.text != "" {
            makeSignUpRequest(self.signupNameTextField.text!, userEmail: self.signupEmailTextField.text!, userPassword: self.signupPasswordTextField.text!)
        } else {
            self.displayAlertMessage("Parameters Required", alertDescription: "Some of the required parameters are missing")
        }
    }
    
    
    
    @IBAction func signinBtnTapped(sender: AnyObject) {
        // resign the keyboard for text fields
        if self.signinEmailTextField.isFirstResponder() {
            self.signinEmailTextField.resignFirstResponder()
        }
        
        if self.signinPasswordTextField.isFirstResponder() {
            self.signinPasswordTextField.resignFirstResponder()
        }
        
        // display activity indicator
        self.activityIndicatorView.hidden = false
        
        // validate presense of required parameters
        if self.signinEmailTextField.text != "" &&
            self.signinPasswordTextField.text != "" {
            makeSignInRequest(self.signinEmailTextField.text!, userPassword: self.signinPasswordTextField.text!)
        } else {
            self.displayAlertMessage("Parameters Required",
                                     alertDescription: "Some of the required parameters are missing")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
          appDelegate.window?.rootViewController = tabBarController
    }
    
    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
        
    }
    
    func saveApiTokenInKeychain(tokenDict:NSDictionary) {
        // Store API AuthToken and AuthToken expiry date in KeyChain
        tokenDict.enumerateKeysAndObjectsUsingBlock({ (dictKey, dictObj, stopBool) -> Void in
            print(dictKey)
            print(dictObj)
            
            
            let myKey = dictKey as! String
            let myObj = dictObj as! String
            
            
            if myKey == "api_authtoken" {
                KeychainAccess.setPassword(myObj, account: "Auth_Token", service: "KeyChainService")
            }
            
            if myKey == "authtoken_expiry" {
                KeychainAccess.setPassword(myObj, account: "Auth_Token_Expiry", service: "KeyChainService")
            }
        })
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makeSignUpRequest(userName:String, userEmail:String, userPassword:String) {
        // 1. Create HTTP request and set request header
        let httpRequest = httpHelper.buildRequest("signup", method: "POST",
                                                  authType: HTTPRequestAuthType.HTTPBasicAuth)
        
        // 2. Password is encrypted with the API key
        let encrypted_password = AESCrypt.encrypt(userPassword, password: HTTPHelper.API_AUTH_PASSWORD)
        
        // 3. Send the request Body
        httpRequest.HTTPBody = "{\"full_name\":\"\(userName)\",\"email\":\"\(userEmail)\",\"password\":\"\(encrypted_password)\"}".dataUsingEncoding(NSUTF8StringEncoding)
        
        // 4. Send the request
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                self.displayAlertMessage("Error", alertDescription: errorMessage as String)
                
                return
            }
            
            self.displaSigninView()
            self.displayAlertMessage("Success", alertDescription: "Account has been created")
        })
    }
    
    func makeSignInRequest(userEmail:String, userPassword:String) {
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest("signin", method: "POST",
                                                  authType: HTTPRequestAuthType.HTTPBasicAuth)
        let encrypted_password = AESCrypt.encrypt(userPassword, password: HTTPHelper.API_AUTH_PASSWORD)
        
        httpRequest.HTTPBody = "{\"email\":\"\(self.signinEmailTextField.text!)\",\"password\":\"\(encrypted_password)\"}".dataUsingEncoding(NSUTF8StringEncoding);
        
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                self.displayAlertMessage("Error", alertDescription: errorMessage as String)
                
                return
            }
            
            // hide activity indicator and update userLoggedInFlag
            self.activityIndicatorView.hidden = true
            self.updateUserLoggedInFlag()
            
            do {
                
                let responseDict = try NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                //var stopBool : Bool
                
                // save API AuthToken and ExpiryDate in Keychain
                self.saveApiTokenInKeychain(responseDict)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        })
    }
}