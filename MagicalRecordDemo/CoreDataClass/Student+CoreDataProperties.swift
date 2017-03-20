//
//  Student+CoreDataProperties.swift
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

extension Student {

    @NSManaged var name: String?
    @NSManaged var rollnumber: NSNumber?
    @NSManaged var studentTOSubject: NSSet?

}
