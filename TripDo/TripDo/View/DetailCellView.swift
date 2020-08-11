//
//  DetailCellView.swift
//  TripDo
//
//  Created by 요한 on 2020/08/10.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class DetailCellView: UICollectionViewCell {
  static let identifier = "DetailCellView"
  
  fileprivate let checkView: UIView = {
    let v = UIView()
    
    return v
  }()
  
  fileprivate let checkButton: UIButton = {
    let b = UIButton()
    b.setImage(UIImage(systemName: Common.SFSymbolKey.check.rawValue), for: .normal)
    b.addTarget(self, action: #selector(didTabButtons), for: .touchUpInside)
    b.tintColor = Common.mainColor
    
    return b
  }()
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    
    setUI()
  }
  
  // MARK: - Layout
  
  private func setUI() {
    [checkView].forEach {
      self.addSubview($0)
    }
    checkView.addSubview(checkButton)
    
    checkView.snp.makeConstraints {
      $0.top.bottom.leading.equalTo(self)
      $0.width.equalTo(self.frame.height)
    }
    
    checkButton.snp.makeConstraints {
      $0.centerX.equalTo(checkView)
      $0.centerY.equalTo(checkView)
      $0.width.equalTo(50)
      $0.height.equalTo(50)
    }
  }
  
  // MARK: - Action
  
  @objc fileprivate func didTabButtons() {
    print("didTabButton")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
