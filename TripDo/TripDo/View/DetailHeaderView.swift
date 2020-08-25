//
//  DetailHeaderView.swift
//  TripDo
//
//  Created by 요한 on 2020/08/10.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class DetailHeaderView: UICollectionReusableView {
  
  static let identifire = "DetailHeaderView"
  let semaphore = DispatchSemaphore(value: 0)
  
  var didInputAddress = false
  var getTitle: String? {
    didSet {
      titleLabel.text = getTitle
    }
  }
  
  var getDate: String? {
    didSet {
      dateLabel.text = getDate
    }
  }
  
  var getPost: [String]? {
    didSet {
      //      print("🥇", getPost)
      getPost!.forEach {
        if $0 != "" && self.mapView.annotations.count <= self.getPost!.count - 1{
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
  var getTaskTitle: [String]?
  var getAddress: [String]?
  //  var locationArray: [CLLocationCoordinate2D] = []
  
  fileprivate lazy var mapView: MKMapView = {
    let mv = MKMapView()
    mv.isRotateEnabled = false
    
    return mv
  }()
  
  fileprivate let titleLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    l.textColor = Common.mainColor
    
    return l
  }()
  
  fileprivate let dateLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    l.textColor = Common.mainColor
    
    return l
  }()
  
  fileprivate let imageView: UIImageView = {
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
    let sv = UIStackView(arrangedSubviews: [imageView, errorLabel])
    sv.axis = .vertical
    sv.spacing = 30
    
    return sv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    mapView.delegate = self
    setUI()
  }
  
  // MARK: - UI
  
  fileprivate func setUI() {
    self.addSubview(mapView)
    [dateLabel, titleLabel].forEach {
      self.addSubview($0)
    }
    
    mapView.snp.makeConstraints {
      $0.top.trailing.leading.equalTo(self)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.bottom).offset(20)
      $0.trailing.equalTo(self).offset(-20)
      $0.leading.equalTo(self).offset(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom)
      $0.trailing.equalTo(self).offset(-20)
      $0.bottom.equalTo(self)
      $0.leading.equalTo(self).offset(20)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - MKMapViewDelegate

extension DetailHeaderView: MKMapViewDelegate {
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

extension DetailHeaderView {
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
