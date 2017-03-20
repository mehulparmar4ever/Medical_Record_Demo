//
//  UserListVC.swift
//  CoreDataDemo
//
//  Created by Mehul Parmar on 29/06/16.
//  Copyright © 2016 openxcell. All rights reserved.
//

import UIKit
import CoreData

class StudentListVC: UIViewController {

    @IBOutlet weak var tableStudentList: UITableView!

    var arrStudentList = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFreshData() {
        self.arrStudentList.removeAll()
        self.arrStudentList = Student.mr_findAll() as! [Student]
        self.tableStudentList.reloadData()
        
        //Search 1
//        arrAlbums = [[Albums MR_findAllSortedBy:@"albumCreatedDate" ascending:NO] mutableCopy];

//        //Search 2
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"sondId = %@",_objSong.sondId];
//        NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_rootSavingContext];
//        objSongTemp = [Song MR_findFirstWithPredicate:pred inContext:defaultContext];
        
    }
    
    func search() {
//        let entityDescription =
//            NSEntityDescription.entityForName("User",
//                                              inManagedObjectContext: managedObjectContext)
//        
//        let request = NSFetchRequest()
//        request.entity = entityDescription
//        
//        let pred = NSPredicate(format: "(name = %@)", "search text")
//        request.predicate = pred
//        
//        do {
//            let objects = try managedObjectContext.executeFetchRequest(request)
//            
//            if objects.count > 0 {
//                arrUserList =  objects as! [User]
//                self.tableUserList.reloadData()
//            }
//            
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
    }
}

extension StudentListVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrStudentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let studentObj = self.arrStudentList[indexPath.row] as Student
        if studentObj.name != nil {
            cell.textLabel?.text = "Name : \(studentObj.name!)"
        }
        
        if studentObj.rollnumber != nil {
            cell.detailTextLabel?.text = "Roll Number : \(studentObj.rollnumber!)"
        }
        
        return cell
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objSubjectListVC = mainStoryboard.instantiateViewController(withIdentifier: "SubjectListVC") as? SubjectListVC
        objSubjectListVC!.selectedStudent = self.arrStudentList[indexPath.row]
        self.navigationController?.pushViewController(objSubjectListVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "DELETE"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            let objStudentTemp = self.arrStudentList[indexPath.row] as Student
            objStudentTemp.mr_deleteEntity()
            
            // Save Managed Object Context
            NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: { (contextDidSave, error) in
            })
            
            tableView.beginUpdates()
            self.arrStudentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "EDIT"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let objAddSubjectVC = mainStoryboard.instantiateViewController(withIdentifier: "AddStudentVC") as? AddStudentVC
            objAddSubjectVC!.selectedStudent = self.arrStudentList[indexPath.row]
            self.navigationController?.pushViewController(objAddSubjectVC!, animated: true)
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
