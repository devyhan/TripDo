//
//  SettingHeaderView.swift
//  TripDo
//
//  Created by 요한 on 2020/08/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class SettingHeaderView: UICollectionReusableView {
  static let identifier = "SettingHeaderView"
  
  fileprivate let titleLabel: UILabel = {
    let l = UILabel()
    l.text = "여행 기록"
    l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    l.textColor = Common.subColor
    
    return l
  }()
  
  fileprivate let subTitleLable: UILabel = {
    let l = UILabel()
    l.text = "나의 여행 기록 현황 및 정보"
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    l.textColor = Common.subColor
    
    return l
  }()
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUI()
  }
  
  // MARK: - Layout
  
  private func setUI() {
    // UI Code
    self.backgroundColor = .clear
    [titleLabel, subTitleLable].forEach {
      self.addSubview($0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(self).offset(20)
      $0.centerY.equalTo(self)
    }
    
    subTitleLable.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.equalTo(self).offset(20)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
