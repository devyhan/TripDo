//
//  UserInfo+CoreDataProperties.swift
//  
//
//  Created by 요한 on 2020/08/14.
//
//

import Foundation
import CoreData


extension UserInfo {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
    return NSFetchRequest<UserInfo>(entityName: "UserInfo")
  }
  
  @NSManaged public var age: Int64
  @NSManaged public var endDate: String?
  @NSManaged public var id: Int64
  @NSManaged public var name: String?
  @NSManaged public var startDate: String?
  @NSManaged public var task: NSSet?
  
}

// MARK: Generated accessors for task
extension UserInfo {
  
  @objc(addTaskObject:)
  @NSManaged public func addToTask(_ value: Task)
  
  @objc(removeTaskObject:)
  @NSManaged public func removeFromTask(_ value: Task)
  
  @objc(addTask:)
  @NSManaged public func addToTask(_ values: NSSet)
  
  @objc(removeTask:)
  @NSManaged public func removeFromTask(_ values: NSSet)
  
}
