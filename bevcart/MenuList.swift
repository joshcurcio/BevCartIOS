//
//  MenuList.swift
//  bevcart
//
//  Created by csc313 on 4/30/16.
//  Copyright © 2016 CurcioDoverStudio. All rights reserved.
//

import UIKit
import Firebase
import Stripe

class MenuList: UITableViewController {
    
    var foodList = [FoodItem]()
    var drinkList = [FoodItem]()
    
    let paymentTextField = STPPaymentCardTextField()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let foodRef = Core.fireBaseRef.childByAppendingPath("courses").childByAppendingPath(Core.selectedGolfCourse.key).childByAppendingPath("food")
        let drinkRef = Core.fireBaseRef.childByAppendingPath("courses").childByAppendingPath(Core.selectedGolfCourse.key).childByAppendingPath("drinks")
        
        foodRef.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            let dictionary = snapshot.value as! NSDictionary
            for key in dictionary
            {
                let datum = key.value as! NSDictionary
                print(datum)
                let newFoodItem = FoodItem()
                newFoodItem.itemName = datum["item"] as! String
                newFoodItem.itemCost = datum["cost"] as! Int
                //newFoodItem.itemCost = datum.key as! Int
                self.foodList.append(newFoodItem)
                self.drinkList.append(newFoodItem)
            }
        }
        
        self.tableView.reloadData()
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return [foodList, drinkList][section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return ["Food","Drink"][section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let req = [foodList, drinkList][indexPath.section][indexPath.row]
        cell.textLabel?.text = "\(req.itemName)"
        
        return cell
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
