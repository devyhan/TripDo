//
//  UserInfo+CoreDataProperties.swift
//  TripDo
//
//  Created by 요한 on 2020/08/01.
//  Copyright © 2020 요한. All rights reserved.
//
//

import Foundation
import CoreData


extension UserInfo {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
    return NSFetchRequest<UserInfo>(entityName: "UserInfo")
  }
  
  @NSManaged public var id: Int64
  @NSManaged public var age: Int64
  @NSManaged public var name: String?
  @NSManaged public var startDate: String?
  @NSManaged public var endDate: String?
  
}
