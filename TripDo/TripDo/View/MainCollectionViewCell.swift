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
  
  fileprivate let mkMapView: MKMapView = {
    let mkMV = MKMapView()
    mkMV.clipsToBounds = true
    mkMV.layer.cornerRadius = 30
    mkMV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    mkMV.isScrollEnabled = false
    mkMV.isPitchEnabled = false
    mkMV.isZoomEnabled = false
    
    return mkMV
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
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = Common.subColor
    self.layer.cornerRadius = 30
    
    Common.shadowMaker(view: self)
    
    setUI()
  }
  
  // MARK: - Layout
  
  private func setUI() {
  
    [mkMapView, tripNameLabel, tripStartDateLabel].forEach {
      self.addSubview($0)
    }
    
    mkMapView.snp.makeConstraints {
      $0.top.trailing.leading.equalTo(self)
      $0.height.equalTo(self.frame.height / 1.3)
    }
    
    tripStartDateLabel.snp.makeConstraints {
      $0.top.equalTo(mkMapView.snp.bottom).offset(20)
      $0.trailing.equalTo(self)
      $0.leading.equalTo(self).offset(20)
    }
    
    tripNameLabel.snp.makeConstraints {
      $0.top.equalTo(tripStartDateLabel.snp.bottom)
      $0.trailing.equalTo(self)
      $0.leading.equalTo(self).offset(20)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
