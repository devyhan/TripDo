//
//  CalenderCollectionViewCell.swift
//  TripDo
//
//  Created by 요한 on 2020/08/04.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class CalenderCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "CalenderCollectionViewCell"
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 4
        self.layer.borderColor = Common.pinColor.cgColor
        self.layer.shadowOpacity = 0
      } else {
        backgroundColor = UIColor.clear
        self.layer.borderWidth = 0
        self.layer.shadowOpacity = 0
      }
    }
  }
  
  var getCalenderNumber: String? {
    didSet {
      calenderDateLabel.text = getCalenderNumber
    }
  }
  
  let calenderDateLabel: UILabel = {
    let l = UILabel()
    l.textAlignment = .center
    l.textColor = Common.subColor
    
    return l
  }()
  
  let cycleView: UIView = {
    let v = UIView()
    
    return v
  }()
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.selectedBackgroundView?.backgroundColor = .red
    
    
    setUI()
  }
  
  // MARK: - Layout
  
  private func setUI() {
    // UI Code
    
    [cycleView, calenderDateLabel].forEach {
      self.addSubview($0)
    }
    
    calenderDateLabel.snp.makeConstraints {
      $0.centerX.centerY.equalTo(self)
    }
    
    cycleView.snp.makeConstraints {
      $0.width.equalTo(self.frame.width)
      $0.height.equalTo(self.frame.height)
    }
  }
  
  func DrawCircle() {
    cycleView.layer.backgroundColor = Common.mainColor.cgColor
    cycleView.layer.cornerRadius = self.frame.width / 2
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
