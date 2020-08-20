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
  
  let array: [String] = ["완료", "미완료"]
  
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
//    sc.selectedSegmentIndex = 1
    sc.addTarget(self, action: #selector(segconChanged(segcon:)), for: UIControl.Event.valueChanged)
    
    return sc
  }()
  
  fileprivate let floatingButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.subColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.cancle.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    Common.shadowMaker(view: b)
    
    return b
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
    let guid = view.safeAreaLayoutGuide
    
    segCon.frame = CGRect(
      x: view.center.x - 60,
      y: view.bounds.height - 160,
      width: view.frame.width / 3.5,
      height: 30
    )
    
    floatingButton.frame = CGRect(
      x: view.bounds.maxX - 100,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    floatingButton.layer.cornerRadius = floatingButton.bounds.width / 2
    
    [preViewLabel, preView, segCon, floatingButton].forEach {
      view.addSubview($0)
    }
    
    preViewLabel.snp.makeConstraints {
      $0.top.equalTo(guid).offset(20)
      $0.trailing.equalTo(guid)
      $0.leading.equalTo(guid).offset(20)
    }
    
    preView.snp.makeConstraints {
      $0.top.equalTo(preViewLabel.snp.bottom)
      $0.trailing.equalTo(guid)
      $0.leading.equalTo(guid)
      $0.height.equalTo(view.frame.height / 3)
    }
  }
  
  // MARK: - Action
  
  @objc func segconChanged(segcon: UISegmentedControl) {
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    
    switch segcon.selectedSegmentIndex {
    case 0:
      print("true")
      CoreDataManager.coreDataShared.updateTask(
        taskId: userInfo[cellIndexPath!].id,
        taskCellId: task[viewIndexPath!].taskCellId,
        address: task[viewIndexPath!].address ?? "",
        post: task[viewIndexPath!].post ?? "",
        check: true) { (onSuccess) in
          print("check: ", task[self.viewIndexPath!].check)
          print("task[viewIndexPath!].taskCellId,", task[self.viewIndexPath!].taskCellId)
      }
    default:
      print("false")
      CoreDataManager.coreDataShared.updateTask(
        taskId: userInfo[cellIndexPath!].id,
        taskCellId: task[viewIndexPath!].taskCellId,
        address: task[viewIndexPath!].address ?? "",
        post: task[viewIndexPath!].post ?? "",
        check: false) { (onSuccess) in
          print("check: ", task[self.viewIndexPath!].check)
          print("task[viewIndexPath!].taskCellId,", task[self.viewIndexPath!].taskCellId)
      }
    }
  }
  
  @objc fileprivate func floatingButtonDidTap() {
    print("floatingButtonDidTap")
    
    dismiss(animated: false)
  }
}
