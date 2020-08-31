//
//  SettingCollectionViewCell.swift
//  TripDo
//
//  Created by 요한 on 2020/08/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class SettingCollectionViewCell: UICollectionViewCell {
  static let identifier = "SettingCollectionViewCell"
  
  fileprivate let titleLabel: UILabel = {
    let l =  UILabel()
    l.text = "여행 템플릿"
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    l.textColor = Common.subColor
    
    return l
  }()
  
  fileprivate let valueLabel: UILabel = {
    let l = UILabel()
    l.text = "14"
    l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    l.textColor = Common.edgeColor
    
    return l
  }()
  
  fileprivate let unitLabel: UILabel = {
    let l = UILabel()
    l.text = "개"
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    l.textColor = Common.subColor
    l.alpha = 0.7
    
    return l
  }()
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUI()
  }
  
  // MARK: - Layout
  
  fileprivate func setUI() {
    // UI Code
    self.layer.cornerRadius = 14
    self.backgroundColor = Common.mainColor
    Common.shadowMaker(view: self)

    [titleLabel, valueLabel, unitLabel].forEach {
      self.addSubview($0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.leading.equalTo(20)
    }
    
    valueLabel.snp.makeConstraints {
      $0.centerY.centerX.equalTo(self)
    }
    
    unitLabel.snp.makeConstraints {
      $0.leading.equalTo(valueLabel.snp.trailing).offset(5)
      $0.centerY.equalTo(self).offset(10)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
