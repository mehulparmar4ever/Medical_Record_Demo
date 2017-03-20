//
//  DeviceListVC.swift
//  CoreDataDemo
//
//  Created by Mehul Parmar on 29/06/16.
//  Copyright © 2016 openxcell. All rights reserved.
//

import UIKit
import CoreData

class SubjectListVC: UIViewController {
    
    var selectedStudent : Student?
    @IBOutlet weak var tableDeviceList: UITableView!

    var arrSubjectList = [Subject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFreshData()
    }

    func getFreshData() {
        self.arrSubjectList = ((selectedStudent?.studentTOSubject!.allObjects) as? [Subject])!
        self.tableDeviceList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let objAddSubjectVC = segue.destination as? AddSubjectVC {
            objAddSubjectVC.arrselectedStudent.append(selectedStudent!)
        }
    }
}

extension SubjectListVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSubjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let objSubject = self.arrSubjectList[indexPath.row] as Subject
        if objSubject.subjectName != nil {
            cell.textLabel?.text = "Name : \(objSubject.subjectName!)"
        }
        
        if objSubject.bookPrice != nil {
            cell.detailTextLabel?.text = "Roll Number : \(objSubject.bookPrice!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "DELETE"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            let objSubjectTemp = self.arrSubjectList[indexPath.row] as Subject
            objSubjectTemp.mr_deleteEntity()
            
            // Save Managed Object Context
            NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: { (contextDidSave, error) in
                if contextDidSave {
                    print("Deleted Succesfully")
                }
                else {
                    print("Error - \(error.debugDescription)")
                }
            })
            
            tableView.beginUpdates()
            
            self.arrSubjectList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "EDIT"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let objAddSubjectVC = mainStoryboard.instantiateViewController(withIdentifier: "AddSubjectVC") as! AddSubjectVC
            objAddSubjectVC.arrselectedStudent.append(self.selectedStudent!)
            objAddSubjectVC.arrselectedSubject.append(self.arrSubjectList[indexPath.row])
            self.navigationController?.pushViewController(objAddSubjectVC, animated: true)
        }
        
        edit.backgroundColor = UIColor.black
        return [delete,edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
}

