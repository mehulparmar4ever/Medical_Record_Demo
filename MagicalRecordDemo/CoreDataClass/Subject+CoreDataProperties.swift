//
//  Subject+CoreDataProperties.swift
//  
//
//  Created by Mehul Parmar on 30/06/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Subject {

    @NSManaged var bookPrice: NSNumber?
    @NSManaged var subjectName: String?
    @NSManaged var subjectToStudent: NSManagedObject?

}
