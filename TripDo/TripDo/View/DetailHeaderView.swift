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
  
  fileprivate let mapView: MKMapView = {
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
    
    setUI()
  }
  
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
