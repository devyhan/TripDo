//
//  Task+CoreDataProperties.swift
//  
//
//  Created by 요한 on 2020/08/14.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskId: Int64
    @NSManaged public var post: String?
    @NSManaged public var address: String?
    @NSManaged public var userInfo: UserInfo?

}
