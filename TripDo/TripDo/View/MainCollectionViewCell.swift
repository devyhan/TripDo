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
  
  fileprivate let mkMapView: MKMapView = {
    let mkMV = MKMapView()
    mkMV.clipsToBounds = true
    mkMV.layer.cornerRadius = 30
    mkMV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    
    return mkMV
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
    // UI Code
    [mkMapView].forEach {
      self.addSubview($0)
    }
    
    mkMapView.snp.makeConstraints {
      $0.top.trailing.leading.equalTo(self)
      $0.height.equalTo(self.frame.height / 1.3)
    }
    
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
