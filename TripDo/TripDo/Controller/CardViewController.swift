//
//  CardViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/10.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class CardViewController: UIViewController {
  
  fileprivate let mkMapView: MKMapView = {
    let mkMV = MKMapView()
    
    return mkMV
  }()
  
  fileprivate let tableView: UITableView = {
    let tv = UITableView()
    
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUI()
  }

  fileprivate func setUI() {
    
  }
}
