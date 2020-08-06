//
//  ViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/07/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class ViewController: UIViewController {
  
  let locationManager = CLLocationManager()
  let layout = UICollectionViewFlowLayout()
  
  var userId: [Int64]?
  var userName: [String]?
  var userStartDate: [String]?
  var currentIndex: CGFloat = 0
  var isOneStepPaging = true
  
  fileprivate let mkMapView: MKMapView = {
    let mkMV = MKMapView()
    
    return mkMV
  }()
  
  fileprivate let titleLabel: UILabel = {
    let l = UILabel()
    let style = [NSAttributedString.Key.kern: 5, NSMutableAttributedString.Key.baselineOffset: -20]
    let attributeString = NSMutableAttributedString(string: "TripDo", attributes: style)
    l.attributedText = attributeString
    l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    l.textColor = Common.edgeColor
    
    return l
  }()
  
  fileprivate let subTitleLabel: UILabel = {
    let l = UILabel()
    l.text = "여행의 시작,\n여행의 일정관리와 기록까지."
    l.font = UIFont.preferredFont(forTextStyle: .title2)
    l.numberOfLines = .zero
    l.textColor = Common.subColor
    
    return l
  }()
  
  fileprivate lazy var stackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
    sv.axis = .vertical
    sv.spacing = 0
    
    return sv
  }()
  
  fileprivate lazy var mainCollectionView: UICollectionView = {
    let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    cv.backgroundColor = Common.mainColor
    cv.showsHorizontalScrollIndicator = false
    
    return cv
  }()
  
  fileprivate let testView: UIView = {
    let v = UIView()
    v.backgroundColor = .cyan
    v.isHidden = true
    
    return v
  }()
  
  fileprivate let floatingButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.mainColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.plus.rawValue), for: .normal)
    b.tintColor = Common.subColor
    b.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    Common.shadowMaker(view: b)
    
    return b
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    mainCollectionView.delegate = self
    
    //    deleteUserInfo(id: 0)
    //    saveUserInfo(id: 1, name: "devyhan", age: 123)
    getUserInfo()
    checkUserLocationAuth()
    
    setUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    print("viewWillApear")
    mainCollectionView.reloadData()
    getUserInfo()
  }
}

// MARK: - UI

extension ViewController {
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    view.backgroundColor = Common.mainColor
    
    floatingButton.frame = CGRect(
      x: view.bounds.maxX - 100,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    floatingButton.layer.cornerRadius = floatingButton.bounds.width / 2
    
    // Layout
    
    view.bringSubviewToFront(floatingButton)
    [testView, stackView, mainCollectionView, floatingButton].forEach {
      view.addSubview($0)
    }
    
    // Constraint
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(guid).offset(-70)
      $0.trailing.equalTo(guid).offset(-40)
      $0.bottom.equalTo(mainCollectionView.snp.top).offset(-20)
      $0.leading.equalTo(guid).offset(40)
      $0.height.equalTo(view.frame.height / 4.5)
    }
    
    testView.snp.makeConstraints {
      $0.top.equalTo(stackView.snp.bottom)
      $0.trailing.leading.bottom.equalTo(guid)
    }
    
    mainCollectionView.snp.makeConstraints {
      $0.top.equalTo(stackView.snp.bottom)
      $0.trailing.leading.bottom.equalTo(guid)
    }
    
    setNavigation()
    setCollectionView()
  }
  
  fileprivate func setNavigation() {
    let navBar = self.navigationController?.navigationBar
    navBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navBar?.shadowImage = UIImage()
    navBar?.isTranslucent = true
    navBar?.backgroundColor = UIColor.clear
  }
  
  fileprivate func setCollectionView() {
    mainCollectionView.dataSource = self
    mainCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    //    mainCollectionView.delegate = self
    //    mainCollectionView.isPagingEnabled = true
    
    layout.sectionInset = .init(top: 15, left: 40, bottom: 15, right: 40)
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    
  }
}

// MARK: - Action

extension ViewController {
  @objc fileprivate func floatingButtonDidTap() {
    print("floatingButtonDidTap")
    getUserInfo()
    
    let vc = WriteViewController()
    vc.modalPresentationStyle = .fullScreen
    navigationController?.pushViewController(vc, animated: true)
    mainCollectionView.reloadData()
  }
}


// MARK: - CoreData

extension ViewController {
  fileprivate func getUserInfo() {
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    userId = userInfo.map { $0.id }
    userName = userInfo.map { $0.name ?? "nil" }
    userStartDate = userInfo.map { $0.startDate ?? "nil" }
    
    print("getUserId :", userId as Any)
    print("getUserInfo :", userName as Any)
    print("getUserStartDate :", userStartDate as Any)
  }
  
  fileprivate func saveUserInfo(id: Int64, name: String, age: Int64, startDate: String) {
    CoreDataManager.coreDataShared.saveUser(
      id: id,
      name: name,
      age: age,
      startDate: startDate,
      date: Date()) { (onSuccess) in
        print("saved =", onSuccess)
    }
  }
  
  fileprivate func deleteUserInfo(id: Int64) {
    CoreDataManager.coreDataShared.deleteUser(id: id) { (onSuccess) in
      print("delete =", onSuccess)
    }
  }
  
  fileprivate func editUserInfo() {
    
  }
}

// MARK: - MapKit

extension ViewController {
  fileprivate func checkUserLocationAuth() {
    CoreLocationManager.coreLocationShared.checkAuthorizationStatus()
  }
  
  fileprivate func geocodeAddressString(_ addressString: String) {
    let geooder = CLGeocoder()
    geooder.geocodeAddressString(addressString) { (placeMark, error) in
      if error != nil {
        return print(error!.localizedDescription)
      }
      guard let place = placeMark?.first else { return }
      print(place)
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      print("Authorization")
    default:
      print("Unauthorized")
    }
  }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    userId?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
    
    cell.getTripNameString = userStartDate?[indexPath.row]
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
  {
    
    // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
    let layout = self.mainCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let cellWidthIncludingSpacing = view.frame.width - layout.sectionInset.left - layout.sectionInset.right + 15
    print("layout.minimumInteritemSpacing", layout.minimumInteritemSpacing)
    // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
    // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
    var offset = targetContentOffset.pointee
    
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
    var roundedIndex = round(index)
    
    // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
    // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
    // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      roundedIndex = floor(index)
    } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
      roundedIndex = ceil(index)
    } else {
      roundedIndex = round(index)
    }
    
    if isOneStepPaging {
      if currentIndex > roundedIndex {
        currentIndex -= 1
        roundedIndex = currentIndex
      } else if currentIndex < roundedIndex {
        currentIndex += 1
        roundedIndex = currentIndex
      }
    }
    
    // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
    offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
    targetContentOffset.pointee = offset
  }
}

// MARK: - MARK Title

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    layout.sectionInset
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    15
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right
    let height = collectionView.frame.height - layout.sectionInset.top - layout.sectionInset.bottom
    
    return CGSize(width: width, height: height)
  }
}
