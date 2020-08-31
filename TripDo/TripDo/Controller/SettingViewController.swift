//
//  SettingViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/08.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
  
  // 여행 템플릿 수
  var totalTrip: String?
  // 여행 총 개수
  var totalTask: String?
  // 완료한 여행
  var finishTask: String?
  // 사용자 평균 여행 완료율
  var userFinishPercent: String?
  
  fileprivate let layout: UICollectionViewFlowLayout = {
    let fl = UICollectionViewFlowLayout()
    fl.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    
    return fl
  }()

  fileprivate lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.identifier)
    cv.register(SettingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingHeaderView.identifier)
    cv.backgroundColor = .clear
    
    return cv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = Common.mainColor
    setUI()
    getData()
  }
  
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    setNavigation()
    collectionView.dataSource = self
    collectionView.delegate = self
    
    [collectionView].forEach {
      view.addSubview($0)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.trailing.leading.bottom.equalTo(guid)
    }
  }
  
  fileprivate func setNavigation() {
    let navController = self.navigationController?.navigationBar
    navigationItem.title = "Trip Do"
    
    navController?.tintColor = Common.subColor
    navController?.topItem?.title = ""
    navController?.titleTextAttributes = [.foregroundColor: Common.subColor]
  }
}

// MARK: - CoreData

extension SettingViewController {
  fileprivate func getData() {
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    
    // check true task
    let taskCheck = task.filter {
      $0.check == true
    }
    
    // 여행 템플릿 수
    totalTrip = "\(userInfo.count)"
    // 여행 총 개수
    totalTask = "\(task.count)"
    // 완료한 여행
    finishTask = "\(taskCheck.count)"
    // 사용자 평균 여행 완료율
    userFinishPercent = "\(Double(taskCheck.count) / Double(task.count)  * 100)"
  }
}

// MARK: - UICollectionViewDataSource

extension SettingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCollectionViewCell.identifier, for: indexPath) as! SettingCollectionViewCell
    switch indexPath.row {
    case 0:
      cell.titleString = "만든 여행 템플릿"
      cell.valueString = totalTrip
      cell.unitString = "개"
    case 1:
      cell.titleString = "지도에 찍은 핀의 개수"
      cell.valueString = totalTask
      cell.unitString = "개"
    case 2:
      cell.titleString = "완료된 핀의 개수"
      cell.valueString = finishTask
      cell.unitString = "개"
    default:
      cell.titleString = "여행의 완주율"
      cell.valueString = userFinishPercent
      cell.unitString = "%"
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    layout.sectionInset
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    16
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width / 2.3
    let height = CGFloat(150)
    
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingHeaderView.identifier, for: indexPath)
    
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    return .init(width: view.frame.width, height: view.frame.height / 8)
  }
}
