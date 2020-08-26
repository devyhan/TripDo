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

  var taskString: String? {
    didSet {
      moreLabel.text = taskString
    }
  }
  
  var closeButtonAction: (() -> ())?
  
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
