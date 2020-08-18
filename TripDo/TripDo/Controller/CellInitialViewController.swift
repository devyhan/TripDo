//
//  CellInitialViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/17.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class CellInitialViewController: UIViewController {
  
  var cellIndexPath: Int?
  var viewIndexPath: Int? {
    didSet {
      preViewLabel.text = "\(viewIndexPath! + 1)일차"
    }
  }
  
  var cellBool: Bool? {
    didSet {
      segCon.selectedSegmentIndex = Int(truncating: NSNumber(value: cellBool!))
    }
  }
  
  let array: [String] = ["미완료", "완료"]
  
  fileprivate let preViewLabel: UILabel = {
    let l = UILabel()
    l.textColor = Common.mainColor
    l.font = UIFont.preferredFont(forTextStyle: .title1)
    
    return l
  }()
  
  fileprivate let preView: UIView = {
    let v = UIView()
    v.backgroundColor = Common.subColor
    
    return v
  }()
  
  lazy var segCon: UISegmentedControl = {
    let sc: UISegmentedControl = UISegmentedControl(items: array)
    sc.backgroundColor = Common.mainColor.withAlphaComponent(0.7)
    sc.selectedSegmentTintColor = Common.subColor
    sc.addTarget(self, action: #selector(segconChanged(segcon:)), for: UIControl.Event.valueChanged)
    
    return sc
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = Common.subColor
    setUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    print("address:", task.map { $0.address })
    print("post:", task.map { $0.post })
    print("check:", task.map { $0.check })
    print("taskCellId:", task.map { $0.taskCellId })
  }
  
  // MARK: - UI
  
  fileprivate func setUI() {
    segCon.frame = CGRect(
      x: view.center.x - 60,
      y: view.bounds.height - 160,
      width: view.frame.width / 3.5,
      height: 30
    )
    
    [preViewLabel, preView, segCon].forEach {
      view.addSubview($0)
    }
    
    preViewLabel.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.trailing.equalTo(view)
      $0.leading.equalTo(20)
    }
    
    preView.snp.makeConstraints {
      $0.top.equalTo(preViewLabel.snp.bottom)
      $0.trailing.equalTo(view)
      $0.leading.equalTo(view)
      $0.height.equalTo(view.frame.height / 3)
    }
  }
  
  // MARK: - Action
  
  @objc func segconChanged(segcon: UISegmentedControl) {
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    switch segcon.selectedSegmentIndex {
    case 0:
      print("true")
      CoreDataManager.coreDataShared.updateTask(
        taskId: task[cellIndexPath!].taskId,
        taskCellId: task[viewIndexPath!].taskCellId,
        address: "",
        post: task[viewIndexPath!].post ?? "",
        check: true) { (onSuccess) in
          print("Task Update =", onSuccess)
          print("check: ", task[self.viewIndexPath!].check)
          print("taskId: ", task[self.cellIndexPath!].taskId)
      }
    default:
      print("false")
      CoreDataManager.coreDataShared.updateTask(
        taskId: task[cellIndexPath!].taskId,
        taskCellId: task[viewIndexPath!].taskCellId,
        address: "dlasdfasdfasdf",
        post: task[viewIndexPath!].post ?? "",
        check: false) { (onSuccess) in
          print("Task Update =", onSuccess)
          print("check: ", task[self.viewIndexPath!].check)
          print("taskId: ", task.map { $0.taskId } )
      }
    }
  }
}
