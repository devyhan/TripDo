//
//  MainCollectionViewCell.swift
//  TripDo
//
//  Created by 요한 on 2020/08/01.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MainCollectionViewCell: UICollectionViewCell {

  static let identifier = "MainCollectionViewCell"
  
  var closeButtonAction: (() -> ())?
  var getTaskTitle: [String]?
  var getAddress: [String]?
  var taskString: String? {
    didSet {
      moreLabel.text = taskString
    }
  }

  var getTripNameString: String? {
    didSet {
      tripNameLabel.text = getTripNameString
    }
  }
  
  var getTripStartDateString: String? {
    didSet {
      tripStartDateLabel.text = getTripStartDateString
    }
  }
  
  var getPost: [String]? {
    didSet {
      getPost!.forEach {
        if $0 != "" && self.mapView.annotations.isEmpty == true {
          findLocationByAddress(address: $0) {_ in
            print("❤️", self.mapView.annotations.count <= self.getPost!.count)
            let annotations = self.mapView.annotations
            self.mapView.showAnnotations(annotations, animated: false)
            //              self.addPolylineOverlay(at: self.locationArray)
          }
        }
      }
    }
  }
  
  fileprivate let mapView: MKMapView = {
    let mv = MKMapView()
    mv.clipsToBounds = true
    mv.layer.cornerRadius = 30
    mv.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    mv.isScrollEnabled = false
    mv.isPitchEnabled = false
    mv.isZoomEnabled = false
    mv.isRotateEnabled = false
    
    return mv
  }()
  
  fileprivate let tripStartDateLabel: UILabel = {
    let l = UILabel()
    l.textColor = Common.mainColor
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    
    return l
  }()
  
  fileprivate let tripNameLabel: UILabel = {
    let l = UILabel()
    l.textColor = Common.mainColor
    l.font = UIFont.preferredFont(forTextStyle: .title1)
    
    return l
  }()
  
  fileprivate let moreLabel: UILabel = {
    let l = UILabel()
    l.text = "more"
    l.textAlignment = .center
    l.textColor = Common.mainColor
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    l.alpha = 0.6
    
    return l
  }()
  
  fileprivate let imageView: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(systemName: Common.SFSymbolKey.more.rawValue)
    iv.tintColor = Common.mainColor
    iv.contentMode = .scaleAspectFit
    iv.alpha = 0.3
    
    return iv
  }()
  
  lazy var taskDeleteButton: UIButton = {
    let b = UIButton()
    b.setImage(UIImage(systemName: Common.SFSymbolKey.cancle.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(btnCloseTapped), for: .touchUpInside)
    
    return b
  }()

  fileprivate let networkImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(systemName: Common.SFSymbolKey.disableNetWork.rawValue)
    iv.tintColor = Common.mainColor
    iv.contentMode = .scaleAspectFit
    iv.alpha = 0.7
    
    return iv
  }()
  
  fileprivate let errorLabel: UILabel = {
    let l = UILabel()
    l.text = "네트워크 연결상태를 확인해 주세요."
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    l.textColor = Common.mainColor
    l.textAlignment = .center
    
    return l
  }()
  fileprivate lazy var stackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [networkImageView, errorLabel])
    sv.axis = .vertical
    sv.spacing = 30
    
    return sv
  }()
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = Common.subColor
    self.layer.cornerRadius = 30
    print("🤩")
    
    Common.shadowMaker(view: self)
    
    setUI()
  }
  
  // MARK: - Layout
  
  private func setUI() {
    mapView.delegate = self
    
    [mapView, tripNameLabel, tripStartDateLabel, moreLabel, imageView].forEach {
      self.addSubview($0)
    }
    
    mapView.addSubview(taskDeleteButton)
    
    taskDeleteButton.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.top).offset(20)
      $0.trailing.equalTo(mapView.snp.trailing).offset(-20)
    }
    
    mapView.snp.makeConstraints {
      $0.top.trailing.leading.equalTo(self)
      $0.height.equalTo(self.frame.height / 1.35)
    }
    
    tripStartDateLabel.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.bottom).offset(20)
      $0.trailing.equalTo(self)
      $0.leading.equalTo(self).offset(20)
    }
    
    tripNameLabel.snp.makeConstraints {
      $0.top.equalTo(tripStartDateLabel.snp.bottom)
      $0.trailing.equalTo(self)
      $0.leading.equalTo(self).offset(20)
    }
    
    moreLabel.snp.makeConstraints {
      $0.top.equalTo(tripNameLabel.snp.bottom).offset(20)
      $0.trailing.equalTo(self)
      $0.leading.equalTo(self)
    }
    
    imageView.snp.makeConstraints {
      $0.top.equalTo(moreLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(self)
      $0.bottom.equalTo(self).offset(-20)
    }
  }
  
  @objc fileprivate func btnCloseTapped(_ sender: UIButton) {
    switch sender {
    case taskDeleteButton:
      closeButtonAction?()
      print("closeButtonAction")
    default:
      print("moreButtonAction")
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - MKMapViewDelegate

extension MainCollectionViewCell: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "")
    annotationView.glyphTintColor = Common.subColor
    annotationView.markerTintColor = Common.mainColor
    annotationView.displayPriority = .required
    
    return annotationView
  }
  
  func addAnnotation(at center: CLLocationCoordinate2D, with title: Int, subTitle: String) {
    let pin = MKPointAnnotation()
    
    mapView.addAnnotation(pin)
    pin.title = "\(title + 1)일차, \(getTaskTitle![title])"
    pin.subtitle = subTitle
    pin.coordinate = center
  }
  
  //  func addPolylineOverlay(at points: [CLLocationCoordinate2D]) {
  //
  //    let polyline = MKPolyline(coordinates: points, count: points.count)
  //    mapView.addOverlay(polyline)
  //  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let polyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: polyline)
      renderer.lineWidth = 2
      renderer.strokeColor = Common.mainColor
      renderer.alpha = 0.8
      
      return renderer
    }
    return MKOverlayRenderer(overlay: overlay)
  }
  
  func findLocationByAddress(address: String, completion: @escaping((CLLocationCoordinate2D) -> Void)) {
    let geoCoder = CLGeocoder()
    print("😛", address)
    
    geoCoder.geocodeAddressString(address) { (placemarks, error) in
      
      if let error = error {
        self.setBlurEffect()
        return print(error.localizedDescription)
      }
      guard let placemark = placemarks?.first,
        let coordinate = placemark.location?.coordinate,
        let name = placemark.name
        else { return }
      
      if let days = self.getPost?.firstIndex(where: {
        $0 == name
      }) {
        self.addAnnotation(at: coordinate, with: days, subTitle: self.getAddress![days])
        //        self.locationArray.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        //        print("\(days)번째")
      }
      
      //      print("👊", self.locationArray)
      print("🙏", coordinate)
      completion(coordinate)
    }
  }
}

// MARK: - Blur effect view

extension MainCollectionViewCell {
  fileprivate func setBlurEffect() {
    let blurEffect = UIBlurEffect(style: .regular)
    let visualEffectView = UIVisualEffectView(effect: blurEffect)
    
    // addViews
    [visualEffectView, stackView].forEach {
      mapView.addSubview($0)
    }
    
    // addConstants
    visualEffectView.snp.makeConstraints {
      $0.top.trailing.bottom.leading.equalTo(mapView)
    }
    
    imageView.snp.makeConstraints {
      $0.height.equalTo(mapView.frame.width / 10)
    }
    
    stackView.snp.makeConstraints {
      $0.centerY.centerX.equalTo(mapView)
      $0.width.equalTo(mapView.frame.width)
    }
  }
}
