//
//  LoginVC.swift
//  bevcart
//
//  Created by Curcio, Joshua M on 4/27/16.
//  Copyright © 2016 CurcioDoverStudio. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController
{
    
    @IBOutlet weak var resetPasswordEmailTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorTextView: UITextView!
    @IBOutlet weak var resetPasswordStackView: UIStackView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //make the storyboard available everywhere
        Core.storyboard = self.storyboard
        
        self.resetPasswordStackView.hidden = true
        self.errorTextView.text = ""
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if(Core.fireBaseRef.authData != nil)
        {
            self.postLoginSetup()
        }
    }
    
    func postLoginSetup()
    {
        let roleRef = Core.fireBaseRef.childByAppendingPath("role").childByAppendingPath(Core.fireBaseRef.authData.uid)
        let role = roleRef.queryOrderedByKey()
        role.observeEventType(.Value) { (snapshot: FDataSnapshot!) in
            if(snapshot.value as! String == "user")
            {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("UserVC") as! UserVC
                self.presentViewController(vc, animated: true, completion: nil)
            }
            else if(snapshot.value as! String == "provider")
            {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ProviderVC") as! ProviderVC
                self.presentViewController(vc, animated: true, completion: nil)
            }
            else if(snapshot.value as! String == "admin")
            {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AdminVC") as! AdminVC
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    func validateLoginForm() -> Bool
    {
        var errorMessage = ""
        if(usernameTF.text?.characters.count == 0)
        {
            errorMessage = "You must enter a username"
        }
        else if(passwordTF.text?.characters.count == 0)
        {
            errorMessage = "You must enter a password"
        }
        else
        {
            self.errorTextView.text = ""
            return true
        }
        self.errorTextView.text = errorMessage
        self.errorTextView.textColor = UIColor.redColor()
        return false
    }
    
    func validateResetPasswordForm() -> Bool
    {
        var errorMessage = ""
        if(resetPasswordEmailTF.text?.characters.count == 0)
        {
            errorMessage = "You must enter an email address to reset your password"
        }
        else if(!Core.isValidEmail(resetPasswordEmailTF.text!))
        {
            errorMessage = "You must enter a valid email address"
        }
        else
        {
            self.errorTextView.text = ""
            return true
        }
        self.errorTextView.text = errorMessage
        self.errorTextView.textColor = UIColor.redColor()
        return false
    }
    
    
    @IBAction func loginButtonPressed(sender: AnyObject)
    {
        if(validateLoginForm())
        {
            let ref = Core.fireBaseRef
            ref.authUser(self.usernameTF.text!, password: self.passwordTF.text!,
                         withCompletionBlock: { error, authData in
                            if error != nil
                            {
                                self.errorTextView.text = error.localizedDescription
                                self.errorTextView.textColor = UIColor.redColor()
                            }
                            else
                            {
                                
                                // We are now logged in
                                self.postLoginSetup()
                            }
            })
        }
    }
    
    @IBAction func resetPasswordSendButtonPressed(sender: AnyObject)
    {
        if(validateResetPasswordForm())
        {
            let ref = Core.fireBaseRef
            ref.resetPasswordForUser(self.resetPasswordEmailTF.text!, withCompletionBlock: { error in
                if error != nil
                {
                    self.errorTextView.text = error.localizedDescription
                    self.errorTextView.textColor = UIColor.redColor()
                }
                else
                {
                    // Password reset sent successfully
                    let alert = UIAlertController(title: "Success", message: "Check your email for password reset instructions", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default
                        , handler: { (action: UIAlertAction) in
                            self.errorTextView.text = ""
                            self.resetPasswordEmailTF.text = ""
                            self.resetPasswordStackView.hidden = true
                    })
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func resetPasswordCancelButtonPressed(sender: AnyObject)
    {
        self.resetPasswordStackView.hidden = true
        self.errorTextView.text = ""
    }
    
    @IBAction func forgetPasswordButtonPressed(sender: AnyObject)
    {
        self.resetPasswordStackView.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
