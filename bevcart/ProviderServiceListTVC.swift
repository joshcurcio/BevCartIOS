//
//  ProviderServiceListTVC.swift
//  bevcart
//
//  Created by Curcio, Joshua M on 4/27/16.
//  Copyright © 2016 CurcioDoverStudio. All rights reserved.
//

import UIKit
import Firebase

class ProviderServiceListTVC: UITableViewController {
    
    var pending = [Order]()
    var incomplete = [Order]()
    var completed = [Order]()
    var all = [Order]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let ref = Core.fireBaseRef.childByAppendingPath("service_requests")
        ref.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            let dictionary = snapshot.value as! NSDictionary
            for key in dictionary
            {
                let datum = key.value as! NSDictionary
                let req = Order()
                req.key = key.key as! String
                req.beer = datum["beer"] as! Int
                req.burger = datum["burger"] as! Int
                req.chips = datum["chips"] as! Int
                req.completed = datum["completed"] as! Bool
                req.hole = datum["hole"] as! Int
                req.hot_dog = datum["hot_dog"] as! Int
                req.price = datum["price"] as! Int
                req.provider = datum["provider"] as! String
                req.user = datum["user"] as! String
                
                if(req.provider == "n/a")
                {
                    self.pending.append(req)
                }
                else if(req.provider == Core.fireBaseRef.authData.uid)
                {
                    if(req.completed.boolValue)
                    {
                        self.completed.append(req)
                    }
                    else
                    {
                        self.incomplete.append(req)
                    }
                }
                self.all.append(req)
                self.tableView.reloadData()
            }
        }
        
        ref.observeEventType(.ChildChanged) { (snapshot: FDataSnapshot!) in
            let datum = snapshot.value as! NSDictionary
            for req in self.all
            {
                if(req.key == snapshot.key)
                {
                    req.beer = datum["beer"] as! Int
                    req.burger = datum["burger"] as! Int
                    req.chips = datum["chips"] as! Int
                    req.completed = datum["completed"] as! Bool
                    req.hole = datum["hole"] as! Int
                    req.hot_dog = datum["hot_dog"] as! Int
                    req.price = datum["price"] as! Int
                    req.provider = datum["provider"] as! String
                    req.user = datum["user"] as! String
                    
                    var pos = self.pending.indexOf(req)
                    if(pos != nil)
                    {
                        self.pending.removeAtIndex(pos!)
                    }
                    else
                    {
                        pos = self.incomplete.indexOf(req)
                        if(pos != nil)
                        {
                            self.incomplete.removeAtIndex(pos!)
                        }
                        else
                        {
                            pos = self.completed.indexOf(req)
                            if(pos != nil)
                            {
                                self.completed.removeAtIndex(pos!)
                            }
                        }
                    }
                    
                    //re-add based on new data
                    if(req.provider == "n/a")
                    {
                        self.pending.append(req)
                    }
                    else if(req.provider == Core.fireBaseRef.authData.uid)
                    {
                        if(req.completed.boolValue)
                        {
                            self.completed.append(req)
                        }
                        else
                        {
                            self.incomplete.append(req)
                        }
                    }
                    
                    self.tableView.reloadData()
                    break
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return [pending, incomplete, completed][section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return ["Pending","Incomplete","Complete"][section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let req = [pending, incomplete, completed][indexPath.section][indexPath.row]
        cell.textLabel?.text = "\(req.beer) - \(req.burger)"
        cell.detailTextLabel?.text = "Cost: $\(req.price/100)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let req = [pending, incomplete, completed][indexPath.section][indexPath.row]
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ProviderServiceDetailVC") as! ProviderServiceDetailVC
        vc.req = req
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
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
