//
//  UserNewServiceRequest.swift
//  bevcart
//
//  Created by Curcio, Joshua M on 4/27/16.
//  Copyright © 2016 CurcioDoverStudio. All rights reserved.
//

import UIKit
import Stripe
import Firebase

class UserNewServiceRequest: UITableView, STPPaymentCardTextFieldDelegate
{
    
    
    @IBOutlet weak var priceLabel: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    let paymentTextField = STPPaymentCardTextField()
    
    
    var foodList = [FoodItem]()
    var drinkList = [FoodItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
                
    }
    
    
    @IBAction func saveButtonPressed(sender : AnyObject)
    {
        //paymentTextField.frame = CGRectMake(0, 0, CGRectGetWidth(self.mainStack.frame), 44)
        //paymentTextField.delegate = self
        //self.mainStack.addArrangedSubview(paymentTextField)
        //view.addSubview(paymentTextField)
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField){
        // Toggle navigation, for example
        //saveButton.enabled = textField.valid
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

