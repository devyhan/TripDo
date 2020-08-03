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
  let transition = ButtonTransitionAnimation()
  
  var userId: [Int64]?
  
  var userName: [String]?
  
  fileprivate let mkMapView: MKMapView = {
    let mkMV = MKMapView()
    
    return mkMV
  }()
  
  fileprivate lazy var mainCollectionView: UICollectionView = {
    let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    cv.backgroundColor = .white
    
    return cv
  }()
  
  fileprivate let floatingButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.mainColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.plus.rawValue), for: .normal)
    b.tintColor = .white
    b.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    
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
}

// MARK: - UI

extension ViewController {
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    view.backgroundColor = .white
    
    floatingButton.frame = CGRect(
      x: view.center.x - 30,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    floatingButton.layer.cornerRadius = floatingButton.bounds.width / 2
    
    // Layout
    
    view.bringSubviewToFront(floatingButton)
    [mainCollectionView, floatingButton].forEach {
      view.addSubview($0)
    }
    
    // Constraint
    
    mainCollectionView.snp.makeConstraints {
      $0.top.trailing.leading.bottom.equalTo(guid)
    }
    
    setNavigation()
    setCollectionView()
  }
  
  fileprivate func setNavigation() {
    navigationItem.title = "Title"
    
    let navBar = self.navigationController?.navigationBar
    navBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navBar?.shadowImage = UIImage()
    navBar?.isTranslucent = true
    navBar?.backgroundColor = UIColor.clear
  }
  
  fileprivate func setCollectionView() {
    mainCollectionView.dataSource = self
    mainCollectionView.delegate = self
    
    layout.sectionInset = .init(top: 15, left: 0, bottom: 15, right: 0)
    layout.minimumLineSpacing = 15
    layout.itemSize = CGSize(width: view.frame.width - 30, height: view.frame.height - 700)
  }
}

// MARK: - Action

extension ViewController {
  @objc fileprivate func floatingButtonDidTap() {
    print("floatingButtonDidTap")
    saveUserInfo(id: 1, name: "안준영", age: 66)
    //    deleteUserInfo(id: 1)
    getUserInfo()
    mainCollectionView.reloadData()
    
    //    let secondVC = WriteViewController()
    //    secondVC.modalPresentationStyle = .custom
    //    secondVC.transitioningDelegate = self
    
    //    animationController(forPresented: secondVC, presenting: self, source: secondVC)
    //    present(secondVC, animated: true, completion: nil)
  }
}


// MARK: - CoreData

extension ViewController {
  fileprivate func getUserInfo() {
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    userId = userInfo.map { $0.id }
    userName = userInfo.map { $0.name ?? "nil" }
    
    print("getUserId :", userId as Any)
    print("getUserInfo :", userName as Any)
  }
  
  fileprivate func saveUserInfo(id: Int64, name: String, age: Int64) {
    CoreDataManager.coreDataShared.saveUser(
      id: id,
      name: name,
      age: age,
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
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
      self.floatingButton.alpha = 0
    }, completion: nil)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if (!decelerate) {
      floatingButtonAnimation()
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    floatingButtonAnimation()
  }
  
  func floatingButtonAnimation() {
    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
      self.floatingButton.alpha = 1
    }, completion: nil)
  }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ViewController: UIViewControllerTransitioningDelegate {
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = floatingButton.center
    transition.circleColor = floatingButton.backgroundColor!
    
    return transition
  }
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint = floatingButton.center
    transition.circleColor = floatingButton.backgroundColor!
    
    return transition
  }
}
