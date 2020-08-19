//
//  LocationViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/11.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

protocol PostAddressDelegate: class {
  func postString(_ data: String)
  func addressString(_ data: String)
}

class LocationViewController: UIViewController {
  
  var lastAddress = ""
  var cellIndexPath: Int?
  
  fileprivate let mapView: MKMapView = {
    let mv = MKMapView()
    mv.isScrollEnabled = false
    mv.isPitchEnabled = false
    mv.isZoomEnabled = false
    
    return mv
  }()
  
  fileprivate let floatingCheckButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.mainColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.checkMark.rawValue), for: .normal)
    b.tintColor = Common.subColor
    b.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    b.alpha = 0.5
    b.isEnabled = false
    Common.shadowMaker(view: b)
    
    return b
  }()
  
  fileprivate let floatingSearchButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.subColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.search.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    Common.shadowMaker(view: b)
    
    return b
  }()
  
  fileprivate let floatingCloseButton: UIButton = {
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
    
    setUI()
  }
  
  fileprivate func setUI() {
    mapView.delegate = self
    
    floatingCheckButton.frame = CGRect(
      x: view.bounds.maxX - 100,
      y: view.bounds.height - 200,
      width: 60,
      height: 60
    )
    floatingCheckButton.layer.cornerRadius = floatingCheckButton.bounds.height / 2
    
    floatingSearchButton.frame = CGRect(
      x: view.bounds.maxX - 100,
      y: view.bounds.height - 120,
      width: 60,
      height: 60
    )
    floatingSearchButton.layer.cornerRadius = floatingSearchButton.bounds.height / 2
    
    floatingCloseButton.frame = CGRect(
      x: view.bounds.maxX - 50,
      y: view.bounds.minY + 50,
      width: 30,
      height: 30
    )
    floatingCloseButton.layer.cornerRadius = floatingCloseButton.bounds.width / 2
    
    [mapView, floatingCheckButton, floatingSearchButton, floatingCloseButton].forEach {
      view.addSubview($0)
    }
    mapView.snp.makeConstraints {
      $0.top.trailing.bottom.leading.equalTo(view)
    }
  }
  
  @objc fileprivate func floatingButtonDidTap(_ sender: UIButton) {
    
    switch sender {
    case floatingSearchButton:
      let vc = PostAddressViewController()
      vc.delegate = self
      present(UINavigationController(rootViewController: vc), animated: true)
    case floatingCheckButton:
      print("floatingCheckButton")
    default:
      dismiss(animated: true)
    }
  }
}

// MARK: - PostAddressDelegate

extension LocationViewController: PostAddressDelegate {
  func addressString(_ data: String) {
    print("address:", data)
  }
  
  func postString(_ data: String) {
    
    lastAddress = data
    
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(data) { (placemarks, error) in
      if let error = error {
        return print(error.localizedDescription)
      }
      guard let placemark = placemarks?.first,
        let coordinate = placemark.location?.coordinate
        else { return }
      
      let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
      let region = MKCoordinateRegion(center: coordinate, span: span)
      self.mapView.setRegion(region, animated: true)
    }
    floatingCheckButton.isEnabled = true
    floatingCheckButton.alpha = 1
  }
}

// MARK: - MKMapViewDelegate

extension LocationViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let center = mapView.centerCoordinate
    if lastAddress != "" {
      addAnnotation(at: center, with: lastAddress)
      addSquareOverlay(at: center)
    }
  }
  
  func addAnnotation(at center: CLLocationCoordinate2D, with title: String) {
    let pin = MKPointAnnotation()
    mapView.addAnnotation(pin)
//    pin.title = "\(mapView.annotations.count)번째 행선지"
    pin.subtitle = title
    pin.coordinate = center
  }
  
  func addSquareOverlay(at center: CLLocationCoordinate2D) {
    // 44000m = 44km
    let circle = MKCircle(center: center, radius: 440)
    mapView.addOverlay(circle)
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let circle = overlay as! MKCircle
    let renderer = MKCircleRenderer(circle: circle)
    renderer.strokeColor = Common.mainColor
    renderer.lineWidth = 3
    
    return renderer
  }
}

// MARK: - CoreData

extension LocationViewController {
  fileprivate func saveTask(taskId: Int64, taskCellId: Int64, check: Bool, date: String, title: String, post: String, address: String) {
    CoreDataManager.coreDataShared.saveTask(
      taskId: taskId,
      taskCellId: taskCellId,
      check: check,
      date: date,
      title: title,
      post: post,
      address: address) { (onSuccess) in
        print("savedTask =", onSuccess)
    }
  }
}
