//
//  ViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/07/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .cyan
    deleteUserInfo(id: 0)
//    saveUserInfo(id: 123, name: "요한", age: 123)
    getUserInfo()
  }
  
  fileprivate func getUserInfo() {
    let userInfo: [UserInfo] = CoreDataManager.shared.getUsers()
    let userId: [Int64] = userInfo.map { $0.id }
    let userName: [String] = userInfo.map { $0.name ?? "nil" }
    
    print("getUserId :", userId)
    print("getUserInfo :", userName)
  }
  
  fileprivate func saveUserInfo(id: Int64, name: String, age: Int64) {
    CoreDataManager.shared.saveUser(
      id: id,
      name: name,
      age: age,
      date: Date()) { (onSuccess) in
        print("saved =", onSuccess)
    }
  }
  
  fileprivate func deleteUserInfo(id: Int64) {
    CoreDataManager.shared.deleteUser(id: id) { (onSuccess) in
      print("delete =", onSuccess)
    }
  }
  
}
