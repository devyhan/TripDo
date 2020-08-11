//
//  LocationViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/11.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

protocol PostAddressDelegate: class {
  func postString(_ data: String)
}

class LocationViewController: UIViewController {
  
  fileprivate let mapView: MKMapView = {
    let mv = MKMapView()
    mv.isScrollEnabled = false
    mv.isPitchEnabled = false
    mv.isZoomEnabled = false
    
    return mv
  }()
  
  fileprivate let floatingSearchButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.subColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.search.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    b.tag = 1
    Common.shadowMaker(view: b)
    
    return b
  }()
  
  fileprivate let floatingCloseButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.subColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.cancle.rawValue), for: .normal)
    b.tintColor = Common.mainColor
    b.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    b.tag = 2
    Common.shadowMaker(view: b)
    
    return b
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUI()
  }
  
  fileprivate func setUI() {
    floatingSearchButton.frame = CGRect(
      x: view.bounds.minX + 40,
      y: view.bounds.height - 180,
      width: view.frame.width - 80,
      height: 60
    )
    floatingSearchButton.layer.cornerRadius = floatingSearchButton.bounds.height / 2
    
    floatingCloseButton.frame = CGRect(
      x: view.bounds.maxX - 50,
      y: view.bounds.minY + 20,
      width: 30,
      height: 30
    )
    floatingCloseButton.layer.cornerRadius = floatingCloseButton.bounds.width / 2
    
    [mapView, floatingSearchButton, floatingCloseButton].forEach {
      view.addSubview($0)
    }
    mapView.snp.makeConstraints {
      $0.top.trailing.bottom.leading.equalTo(view)
    }
  }
  
  @objc fileprivate func floatingButtonDidTap(_ sender: UIButton) {
    print("floatingButtonDidTap")

    switch sender {
    case floatingSearchButton:
      let vc = PostAddressViewController()
      vc.delegate = self
      present(UINavigationController(rootViewController: vc), animated: true)
    default:
      dismiss(animated: true)
    }
    
  }
}

extension LocationViewController: PostAddressDelegate {
  func postString(_ data: String) {
    print("delegate Data:", data)
  }
}
