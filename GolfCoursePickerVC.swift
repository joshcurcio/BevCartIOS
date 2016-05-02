//
//  GolfCoursePickerVC.swift
//  
//
//  Created by csc313 on 4/30/16.
//
//

import UIKit
import Firebase

class GolfCoursePickerVC: UIViewController , UIPickerViewDelegate {

    
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var golfCoursePicker: UIPickerView!
    
    var golfCourses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.golfCoursePicker.delegate = self
        
        let ref = Core.fireBaseRef.childByAppendingPath("courses")
        ref.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            let dictionary = snapshot.value as! NSDictionary
            for key in dictionary
            {
                let newCourse = Course()
                
                let datum = key.value as! NSDictionary
                newCourse.course_name = datum["course_name"] as! String
                newCourse.drinkList = datum["drinks"] as! NSDictionary
                newCourse.foodList = datum["food"] as! NSDictionary
                newCourse.key = key.key as! String
                
                self.golfCourses.append(newCourse)
                self.golfCoursePicker.reloadAllComponents()
                Core.selectedGolfCourse = self.golfCourses[0]
            }
            
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return golfCourses.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(golfCourses[row].course_name)
        return golfCourses[row].course_name + " - " + golfCourses[row].key
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return Core.selectedGolfCourse = golfCourses[row]
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
