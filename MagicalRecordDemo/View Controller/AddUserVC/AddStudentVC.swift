//
//  AddUserVC.swift
//  CoreDataDemo
//
//  Created by Mehul Parmar on 29/06/16.
//  Copyright © 2016 openxcell. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

class AddStudentVC: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtFavNum: UITextField!
    
    var selectedStudent : Student?

    @IBAction func btnSaveClicked(_ sender: AnyObject) {
        
        if isValidate() {
            if selectedStudent == nil {
                selectedStudent = Student.mr_createEntity()
            }
            
            selectedStudent?.name = txtName.text
            selectedStudent?.rollnumber = Int(txtFavNum.text!) as NSNumber?
            
            // Save Managed Object Context
            NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: { (contextDidSave, error) in
                if contextDidSave {
                    self.txtName.text = ""
                    self.txtFavNum.text = ""
                    
                    print("User Detail Saved")
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }
                else {
                    print("error - \(error?.localizedDescription)")
                }
            })
        }
        else {
            print("Please enter proper details")
        }
    }
    
    
    func isValidate() -> Bool {
        if txtName.text!.isEmpty {
            return false
        }
        else if txtFavNum.text!.isEmpty {
            return false
        }
        else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print("URL - \(NSPersistentStore.mr_url(forStoreName: MagicalRecord.defaultStoreName()))")
        
        if selectedStudent != nil {
            txtName.text = selectedStudent!.name!
            txtFavNum.text = String(describing: selectedStudent!.rollnumber!)
            
            self.title = "Edit User Detail"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
