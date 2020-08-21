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
  
  var compactPost: [String]?
  
  var getPost: [String]? {
    didSet {
      print("get Post Array :", getPost!.compactMap { print("CompactMap:", $0) })
      getPost?.compactMap {
        if $0 != nil {
          compactPost?.append($0)
          print("compactPost :", compactPost)
        }
      }
    }
  }
  
  let mapView: MKMapView = {
    let mv = MKMapView()
    mv.isScrollEnabled = false
    mv.isPitchEnabled = false
    mv.isZoomEnabled = false
    
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

extension DetailHeaderView: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let center = mapView.centerCoordinate
    addAnnotation(at: center, with: "qwe")
    addSquareOverlay(at: center)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "")
    annotationView.glyphTintColor = Common.subColor
    annotationView.markerTintColor = Common.mainColor
    
    return annotationView
  }
  
  func addAnnotation(at center: CLLocationCoordinate2D, with title: String) {
    let pin = MKPointAnnotation()
    mapView.addAnnotation(pin)
    pin.title = "\(mapView.annotations.count)번째 행선지"
    pin.subtitle = title
    pin.coordinate = center
  }
  
  func addSquareOverlay(at center: CLLocationCoordinate2D) {
    let squareSize = 0.005
    var point1 = center; point1.latitude += squareSize; point1.longitude -= squareSize
    var point2 = center; point2.latitude += squareSize; point2.longitude += squareSize
    var point3 = center; point3.latitude -= squareSize; point3.longitude += squareSize
    var point4 = center; point4.latitude -= squareSize; point4.longitude -= squareSize
    addPolylineOverlay(at: [point1, point2, point3, point4, point1])
  }
  
  func addPolylineOverlay(at points: [CLLocationCoordinate2D]) {
    let polyline = MKPolyline(coordinates: points, count: points.count)
    mapView.addOverlay(polyline)
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let polyline = overlay as! MKPolyline
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.lineWidth = 1
    renderer.strokeColor = .red
    renderer.alpha = 0.8
    
    return renderer
  }
}
