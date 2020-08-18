//
//  CoreDataManager.swift
//  TripDo
//
//  Created by 요한 on 2020/07/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
  static let coreDataShared: CoreDataManager = CoreDataManager()
  
  let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
  lazy var context = appDelegate?.persistentContainer.viewContext
  
  let userModelName: String = "UserInfo"
  let taskModelName: String = "Task"
  
  func getUsers(ascending: Bool = false) -> [UserInfo] {
    var models: [UserInfo] = [UserInfo]()
    
    if let context = context {
      let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: ascending)
      let fetchRequest: NSFetchRequest<NSManagedObject>
        = NSFetchRequest<NSManagedObject>(entityName: userModelName)
      fetchRequest.sortDescriptors = [idSort]
      
      do {
        if let fetchResult: [UserInfo] = try context.fetch(fetchRequest) as? [UserInfo] {
          models = fetchResult
        }
      } catch let error as NSError {
        print("Could not fetch GetUsers😇: \(error), \(error.userInfo)")
      }
    }
    return models
  }
  
  func getTasks(ascending: Bool = false) -> [Task] {
    var models: [Task] = [Task]()
    
    if let context = context {
      let idSort: NSSortDescriptor = NSSortDescriptor(key: "taskId", ascending: ascending)
      let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: taskModelName)
      fetchRequest.sortDescriptors = [idSort]
      
      do {
        if let fetchResult: [Task] = try context.fetch(fetchRequest) as? [Task] {
          models = fetchResult
        }
      } catch let error as NSError {
        print("Could not fetch GetTasks😇: \(error), \(error.userInfo)")
      }
    }
    return models
  }
  
  func saveUser(id: Int64, name: String,
                age: Int64, startDate: String, endDate: String, task: NSSet, date: Date, onSuccess: @escaping ((Bool) -> Void)) {
    if let context = context,
      let entity: NSEntityDescription
      = NSEntityDescription.entity(forEntityName: userModelName, in: context) {
      
      if let user: UserInfo = NSManagedObject(entity: entity, insertInto: context) as? UserInfo {
        user.id = id
        user.name = name
        user.age = age
        user.startDate = startDate
        user.endDate = endDate
        user.task = task
        
        contextSave { success in
          onSuccess(success)
        }
      }
    }
  }
  
  func saveTask(taskId: Int64, taskCellId: Int64, address: String, post: String, check: Bool, date: Date, onSuccess: @escaping ((Bool) -> Void)) {
    if let context = context,
      let entity: NSEntityDescription
      = NSEntityDescription.entity(forEntityName: taskModelName, in: context) {
      
      if let task: Task = NSManagedObject(entity: entity, insertInto: context) as? Task {
        task.taskId = taskId
        task.taskCellId = taskCellId
        task.address = address
        task.post = post
        task.check = check
        
        contextSave { success in
          onSuccess(success)
        }
      }
    }
  }
  
  func deleteUser(id: Int64, onSuccess: @escaping ((Bool) -> Void)) {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = userFilteredRequest(id: id)
    
    do {
      if let results: [UserInfo] = try context?.fetch(fetchRequest) as? [UserInfo] {
        if results.count != 0 {
          context?.delete(results[0])
        }
      }
    } catch let error as NSError {
      print("Could not fatch🥺: \(error), \(error.userInfo)")
      onSuccess(false)
    }
    
    contextSave { success in
      onSuccess(success)
    }
  }
  
  func deleteTask(taskId: Int64, onSuccess: @escaping ((Bool) -> Void)) {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = taskFilteredRequest(taskId: taskId)
    
    do {
      if let results: [Task] = try context?.fetch(fetchRequest) as? [Task] {
        if results.count != 0 {
          context?.delete(results[0])
        }
      }
    } catch let error as NSError {
      print("Could not fatch🥺: \(error), \(error.userInfo)")
      onSuccess(false)
    }
    
    contextSave { success in
      onSuccess(success)
    }
  }
  
  func updateTask(taskId: Int64, taskCellId: Int64, address: String, post: String, check: Bool, onSuccess: @escaping ((Bool) -> Void)) {

    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = taskCellFilteredRequest(taskCellId: taskCellId)
    print(fetchRequest.predicate!)
    do {
      if let results: [Task] = try context?.fetch(fetchRequest) as? [Task] {
        if results.count != 0 {
          let task = results[0] as NSManagedObject
          task.setValue(address, forKey: "address")
          task.setValue(post, forKey: "post")
          task.setValue(check, forKey: "check")
          print("print task ========= \n ", task)
          contextSave { success in
            onSuccess(success)
          }
        }
      }
    } catch let error as NSError {
      print("Could not fatch🥺: \(error), \(error.userInfo)")
      onSuccess(false)
    }
  }
}

extension CoreDataManager {
  fileprivate func userFilteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult>
      = NSFetchRequest<NSFetchRequestResult>(entityName: userModelName)
    fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
    return fetchRequest
  }
  
  fileprivate func taskFilteredRequest(taskId: Int64) -> NSFetchRequest<NSFetchRequestResult> {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult>
      = NSFetchRequest<NSFetchRequestResult>(entityName: taskModelName)
    fetchRequest.predicate = NSPredicate(format: "taskId = %@", NSNumber(value: taskId))
    return fetchRequest
  }
  
  fileprivate func taskCellFilteredRequest(taskCellId: Int64) -> NSFetchRequest<NSFetchRequestResult> {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult>
      = NSFetchRequest<NSFetchRequestResult>(entityName: taskModelName)
    fetchRequest.predicate = NSPredicate(format: "taskCellId = %@", NSNumber(value: taskCellId))
    return fetchRequest
  }
  
  fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
    do {
      try context?.save()
      onSuccess(true)
    } catch let error as NSError {
      print("Could not save🥶: \(error), \(error.userInfo)")
      onSuccess(false)
    }
  }
}
