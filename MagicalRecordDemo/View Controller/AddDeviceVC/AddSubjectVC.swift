//
//  AddDeviceVC.swift
//  CoreDataDemo
//
//  Created by Mehul Parmar on 29/06/16.
//  Copyright © 2016 openxcell. All rights reserved.
//

import UIKit
import CoreData

class AddSubjectVC: UIViewController {

    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    
    var arrselectedStudent = [Student]()
    var arrselectedSubject = [Subject]()
    
    var managedObjectContext =
        (UIApplication.shared.delegate
            as! AppDelegate).managedObjectContext
    
    @IBAction func btnSaveClicked(_ sender: AnyObject) {
        
        if isValidate() {
            if arrselectedSubject.count > 0 {
                arrselectedSubject[0].subjectName = self.txtCompany.text
                arrselectedSubject[0].bookPrice = Int(txtPrice.text!) as NSNumber?
                arrselectedSubject[0].subjectToStudent = arrselectedStudent[0]
                
                // Save Managed Object Context
                NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: { (contextDidSave, error) in
                    if contextDidSave {
                        self.txtCompany.text = ""
                        self.txtPrice.text = ""
                        
                        print("User Detail Saved")
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        print("error - \(error?.localizedDescription)")
                    }
                })
            }
            else {
                arrselectedSubject[0] = Subject.mr_createEntity()!
                arrselectedSubject[0].subjectName = txtCompany.text
                arrselectedSubject[0].bookPrice = Int(txtPrice.text!) as NSNumber?
                arrselectedSubject[0].subjectToStudent = arrselectedStudent[0]
                
                // Save Managed Object Context
                NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: { (contextDidSave, error) in
                    if contextDidSave {
                        self.txtCompany.text = ""
                        self.txtPrice.text = ""
                        
                        print("User Detail Saved")
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        print("error - \(error?.localizedDescription)")
                    }
                })
            }
        }
        else {
            print("Please enter proper details")
        }
    }
    
    func isValidate() -> Bool {
        if txtPrice.text!.isEmpty {
            return false
        }
        else if txtCompany.text!.isEmpty {
            return false
        }
        else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if arrselectedSubject.count > 0 {
            txtPrice.text = String(describing: arrselectedSubject[0].bookPrice!)
            txtCompany.text = arrselectedSubject[0].subjectName
//            arrselectedSubject = selectedSubject.subjectToStudent
            self.title = "Edit Device Detail"
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
