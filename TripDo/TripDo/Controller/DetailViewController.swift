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
  
  var userId: [Int64]?
  var userName: [String]?
  var userStartDate: [String]?
  var userEndDate: [String]?
  var cellIndexPath: Int?
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Common.subColor
    
    getUserInfo()
    setUI()
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
    guard let cellIndexPath = cellIndexPath else { return 0 }
    
    let format = DateFormatter()
    format.dateFormat = "yyyy-M-dd"
    
    guard let startTime = format.date(from: userStartDate![cellIndexPath]) else { return 0 }
    guard let endTime = format.date(from: userEndDate![cellIndexPath]) else { return 0 }
    
    let timeInterval = Double(endTime.timeIntervalSince(startTime))
    
    return Int(floor(timeInterval/86400) + 1)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCellView.identifier, for: indexPath) as! DetailCellView
    cell.countString = "\(indexPath.row + 1)일차"
    
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
    print("눌렀다")
    let locationVC = LocationViewController()
    locationVC.modalPresentationStyle = .fullScreen
    present(locationVC, animated: true)
  }
}

// MARK: - CoreData

extension DetailViewController {
  fileprivate func getUserInfo() {
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    userId = userInfo.map { $0.id }
    userName = userInfo.map { $0.name ?? "nil" }
    userStartDate = userInfo.map { $0.startDate ?? "nil" }
    userEndDate = userInfo.map { $0.endDate ?? "nil" }
    
    print("getUserId :", userId as Any)
    print("getUserInfo :", userName as Any)
    print("getUserStartDate :", userStartDate as Any)
    print("getUserEndDate :", userEndDate as Any)
  }
}
