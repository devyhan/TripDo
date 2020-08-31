//
//  SettingHeaderView.swift
//  TripDo
//
//  Created by 요한 on 2020/08/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit

class SettingHeaderView: UICollectionReusableView {
  static let identifier = "SettingHeaderView"
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUI()
  }
  
  // MARK: - Layout
  
  private func setUI() {
    // UI Code
    
    self.backgroundColor = .magenta
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
