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
  @NSManaged public var taskCellId: Int64
  @NSManaged public var check: Bool
  @NSManaged public var date: String?
  @NSManaged public var title: String?
  @NSManaged public var post: String?
  @NSManaged public var address: String?
  @NSManaged public var latitude: Double
  @NSManaged public var longitude: Double
  @NSManaged public var userInfo: UserInfo?
  
}
