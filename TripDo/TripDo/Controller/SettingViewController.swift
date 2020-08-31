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
  fileprivate let layout: UICollectionViewFlowLayout = {
    let fl = UICollectionViewFlowLayout()
    fl.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
    
    return fl
  }()

  fileprivate lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.identifier)
    
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
    let totalTrip = userInfo.count
    // 여행 총 개수
    let totalTask = task.count
    // 완료한 여행
    let finishTask = taskCheck.count
    // 사용자 평균 여행 완료율
    let userFinishPercent = Double(taskCheck.count) / Double(task.count)  * 100
    
    print("지금까지 만든 여행 템플릿 \(totalTrip)개")
    print("지도에 찍힌 핀의 개수 \(totalTask)개")
    print("완료한 핀 개수 \(finishTask)개")
    print("사용자의 여행 완주율 \(userFinishPercent)%")
  }
}

// MARK: - UICollectionViewDataSource

extension SettingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCollectionViewCell.identifier, for: indexPath)
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    layout.sectionInset
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    8
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    8
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width / 2.15
    let height = CGFloat(150)
    
    return CGSize(width: width, height: height)
  }
}
