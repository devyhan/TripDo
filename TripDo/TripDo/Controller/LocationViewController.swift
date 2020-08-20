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
  
  var cellIndexPath: Int?
  var taskIndexPath: Int?
  var addressString: String?
  var postString = ""
  
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
  
  fileprivate let tripNameTextField: UITextField = {
    let tf = UITextField()
    tf.layer.cornerRadius = 14
    tf.backgroundColor = Common.mainColor
    Common.shadowMaker(view: tf)
    
    tf.attributedPlaceholder = NSAttributedString(string: "ex) 첫번째 행선지", attributes: [NSAttributedString.Key.foregroundColor: Common.subColor.withAlphaComponent(0.5)])
    tf.textColor = Common.subColor
    tf.tintColor = Common.edgeColor
    tf.font = UIFont.preferredFont(forTextStyle: .title2)
    tf.addLeftPadding()
    
    tf.isHidden = true
    
    return tf
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboard()
    setUI()
  }
  
  // MARK: - UI
  
  fileprivate func setUI() {
    mapView.delegate = self
    tripNameTextField.delegate = self
    
    tripNameTextField.frame = CGRect(
      x: view.bounds.minX + 40,
      y: view.bounds.minY + 150,
      width: view.frame.width - 80,
      height: 70
    )
    
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
      x: view.bounds.maxX - 70,
      y: view.bounds.minY + 70,
      width: 30,
      height: 30
    )
    floatingCloseButton.layer.cornerRadius = floatingCloseButton.bounds.width / 2
    
    [mapView, floatingCheckButton, floatingSearchButton, floatingCloseButton, tripNameTextField].forEach {
      view.addSubview($0)
    }
    mapView.snp.makeConstraints {
      $0.top.trailing.bottom.leading.equalTo(view)
    }
  }
  
  // MARK: - Action
  
  @objc fileprivate func floatingButtonDidTap(_ sender: UIButton) {
    switch sender {
    case floatingSearchButton:
      let vc = PostAddressViewController()
      vc.delegate = self
      present(UINavigationController(rootViewController: vc), animated: true)
    case floatingCheckButton:
      guard let name = tripNameTextField.text else { return }
      
      print("floatingCheckButton")
      let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
      let task: [Task] = CoreDataManager.coreDataShared.getTasks()
      CoreDataManager.coreDataShared.updateTask(
        taskId: userInfo[cellIndexPath!].id,
        taskCellId: task[taskIndexPath!].taskCellId,
        title: name,
        address: addressString ?? "",
        post: postString,
        check: false) { (onSuccess) in
          print("updateTask =", onSuccess)
      }
      dismiss(animated: true)
    default:
      dismiss(animated: true)
    }
  }
}

// MARK: - PostAddressDelegate

extension LocationViewController: PostAddressDelegate {
  func addressString(_ data: String) {
    print("address:", data)
    addressString = data
  }
  
  func postString(_ data: String) {
    postString = data
    
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
  }
}

// MARK: - MKMapViewDelegate

extension LocationViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let center = mapView.centerCoordinate
    if postString != "" {
      addAnnotation(at: center, with: postString)
      addSquareOverlay(at: center)
      tripNameTextField.isHidden = false
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: addressString)
    annotationView.glyphTintColor = Common.subColor
    annotationView.markerTintColor = Common.mainColor
    
    return annotationView
  }
  
  func addAnnotation(at center: CLLocationCoordinate2D, with title: String) {
    let pin = MKPointAnnotation()

    mapView.addAnnotation(pin)
    pin.title = addressString
    pin.subtitle = title
    pin.coordinate = center
  }
  
  func addSquareOverlay(at center: CLLocationCoordinate2D) {
    // 44000m = 44km
    let circle = MKCircle(center: center, radius: 880)
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

// MARK: - UITextFieldDelegate

extension LocationViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return false }
    print("End:", text.count)
    switch text.count {
    case 0:
      floatingCheckButton.isEnabled = false
      floatingCheckButton.alpha = 0.5
    default:
      floatingCheckButton.isEnabled = true
      floatingCheckButton.alpha = 1
    }
    
    return true
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
