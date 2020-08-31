//
//  SettingViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/08/08.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
  
  fileprivate let tableView: UITableView = {
    let tv = UITableView()
    
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = Common.mainColor
    setUI()
  }
  
  fileprivate func setUI() {
    setNavigation()
  }
  
  fileprivate func setNavigation() {
    let navController = self.navigationController?.navigationBar
    navigationItem.title = "Trip Do"
    
    navController?.tintColor = Common.subColor
    navController?.topItem?.title = ""
    navController?.titleTextAttributes = [.foregroundColor: Common.subColor]
  }
}
