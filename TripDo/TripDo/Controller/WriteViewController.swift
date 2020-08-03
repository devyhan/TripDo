//
//  WriteViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/01.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class WriteViewController: UIViewController {
  
  fileprivate let dismissButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = .white
    b.setImage(UIImage(systemName: Common.SFSymbolKey.multiply.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
    
    return b
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUI()
  }
  
}

// MARK: - UI

extension WriteViewController {
  fileprivate func setUI() {
    view.backgroundColor = Common.mainColor
    
    dismissButton.frame = CGRect(
      x: view.bounds.width - view.frame.width / 2 - 30,
      y: view.bounds.height - 90,
      width: 60,
      height: 60
    )
    dismissButton.layer.cornerRadius = dismissButton.bounds.width / 2
    
    // Layout
    
    [dismissButton].forEach {
      view.addSubview($0)
    }
    
  }
}

// MARK: - Action

extension WriteViewController {
  @objc fileprivate func dismissButtonDidTap() {
    print("dismissButtonDidTap")
    
    self.dismiss(animated: true)
  }
}
