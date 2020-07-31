//
//  CoreDataManager.swift
//  TripDo
//
//  Created by 요한 on 2020/07/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit

class CoreDataManager {
  static let shard: CoreDataManager = CoreDataManager()

  let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
  lazy var context = appDelegate?.persistentContainer.viewContext
  
  let modeName: String = "UserInfo"
}
