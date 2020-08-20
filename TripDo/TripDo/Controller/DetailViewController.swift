//
//  CardViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/10.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
  
  var cellIndexPath: Int?
  
  var userId: [Int64]?
  var userName: [String]?
  var userStartDate: [String]?
  var userEndDate: [String]?
  var userTask: [Any]?
  
  var taskId: [Int64]?
  var taskPost: [String]?
  var taskAddress: [String]?
  var taskCheck: [Bool]?
  
  fileprivate let flowLayout: DetailHeaderLayout = {
    let fl = DetailHeaderLayout()
    fl.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    
    return fl
  }()
  
  fileprivate lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    cv.register(DetailCellView.self, forCellWithReuseIdentifier: DetailCellView.identifier)
    cv.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderView.identifire)
    cv.backgroundColor = Common.subColor
    
    return cv
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
    
    getUserInfo()
    setUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    print("DetailViewController - viewWillAppear")
    
    collectionView.reloadData()
    getUserInfo()
  }
  
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    
    floatingButton.frame = CGRect(
      x: view.bounds.maxX - 100,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    floatingButton.layer.cornerRadius = floatingButton.bounds.width / 2
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.contentInsetAdjustmentBehavior = .never
    
    [collectionView, floatingButton].forEach {
      view.addSubview($0)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(view)
      $0.trailing.bottom.leading.equalTo(guid)
    }
  }
  
  @objc fileprivate func floatingButtonDidTap() {
    print("floatingButtonDidTap")
    
    dismiss(animated: false)
  }
}

// MARK: - UICollectionViewDataSource

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    userTask = userInfo.map { $0.task ?? [] }
    let taskArray: [Int64] = task.map { $0.taskId }
    let count = taskArray.filter({
      $0 == userInfo[cellIndexPath!].id
    })
    
    return count.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCellView.identifier, for: indexPath) as! DetailCellView
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()

    let taskTemp = task.filter({
      $0.taskId == userInfo[cellIndexPath!].id
    })
    
    let checkTemp = taskTemp.map { $0.check }
    let titleTemp = taskTemp.map { $0.title }
    let addressTemp = taskTemp.map { $0.address }
    let dateTemp = taskTemp.map { $0.date }
    
    cell.countString = "\(indexPath.row + 1)일차"
    cell.dateString = dateTemp[indexPath.row]
    cell.titleString = titleTemp[indexPath.row]
    cell.addressString = addressTemp[indexPath.row]
    cell.checkButtonBool = checkTemp[indexPath.row]
    cell.checkButtonToggle = {
      switch checkTemp[indexPath.row] {
      case true:
        cell.checkButton.setImage(UIImage(systemName: Common.SFSymbolKey.check.rawValue), for: .normal)
        self.viewWillAppear(true)
        print("true")
        CoreDataManager.coreDataShared.updateTask(
          taskId: userInfo[self.cellIndexPath!].id,
          taskCellId: task[indexPath.row].taskCellId,
          title: "",
          address: task[indexPath.row].address ?? "",
          post: task[indexPath.row].post ?? "",
          check: false) { (onSuccess) in
            print("updateTask =", onSuccess)
        }
      default:
        cell.checkButton.setImage(UIImage(systemName: Common.SFSymbolKey.uncheck.rawValue), for: .normal)
        self.viewWillAppear(true)
        print("false")
        CoreDataManager.coreDataShared.updateTask(
          taskId: userInfo[self.cellIndexPath!].id,
          taskCellId: task[indexPath.row].taskCellId,
          title: "",
          address: task[indexPath.row].address ?? "",
          post: task[indexPath.row].post ?? "",
          check: true) { (onSuccess) in
            print("updateTask =", onSuccess)
        }
      }
    }
    print("Task cell Update log 👀")
    print("taskId =", taskTemp.map { $0.taskId } )
    print("cellId =", taskTemp.map { $0.taskCellId } )
    print("check =", taskTemp.map { $0.check } )
    print("date =", taskTemp.map { $0.date! } )
    print("title =", taskTemp.map { $0.title! } )
    print("address =", taskTemp.map { $0.address! } )
    print("post =", taskTemp.map { $0.post! } )
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: view.frame.width, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailHeaderView.identifire, for: indexPath) as! DetailHeaderView
    guard let cellIndexPath = cellIndexPath else { return header }
    header.getDate = "\(userStartDate![cellIndexPath]) ~ \(userEndDate![cellIndexPath])"
    header.getTitle = userName?[cellIndexPath]
    
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    return .init(width: view.frame.width, height: view.frame.height / 1.85)
  }
}

// MARK: - UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let locationVC = LocationViewController()
    locationVC.modalPresentationStyle = .fullScreen
    locationVC.taskIndexPath = indexPath.row
    locationVC.cellIndexPath = cellIndexPath
    present(locationVC, animated: true)
  }
}

// MARK: - CoreData

extension DetailViewController {
  fileprivate func getUserInfo() {
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    
    // get UserInfo
    userId = userInfo.map { $0.id }
    userName = userInfo.map { $0.name ?? "nil" }
    userStartDate = userInfo.map { $0.startDate ?? "nil" }
    userEndDate = userInfo.map { $0.endDate ?? "nil" }
    
    // get Task
    taskId = task.map { $0.taskId }
    taskAddress = task.map { $0.address ?? "nil" }
    taskPost = task.map { $0.post ?? "nil" }
    taskCheck = task.map { $0.check }
  }
}
