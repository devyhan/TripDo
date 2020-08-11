//
//  Common.swift
//  TripDo
//
//  Created by 요한 on 2020/08/01.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit

struct Common {
  
  // UserDefault Key
  
  enum UserDefaultKey: String {
    case name = "NameViewController"
    case startDate = "StartDateViewController"
  }
  
  // App MainColor
  
  static let mainColor: UIColor = UIColor(
    red: 36 / 255,
    green: 81 / 255,
    blue: 81 / 255,
    alpha: 1
  )
  
  static let subColor: UIColor = UIColor(
    red: 231 / 255,
    green: 224 / 255,
    blue: 213 / 255,
    alpha: 1
  )
  
  static let edgeColor: UIColor = UIColor(
    red: 226 / 255,
    green: 174 / 255,
    blue: 078 / 255,
    alpha: 1
  )
  
  static let pinColor: UIColor = UIColor(
    red: 113 / 255,
    green: 56 / 255,
    blue: 56 / 255,
    alpha: 1
  )
  
  enum NavigationTitle: String {
    case map = "Map"
    case home = "Home"
    case navBarTitle = "CafeSpot"
  }
  
  enum SFSymbolKey: String {
    case rightNavigation = "ellipsis"
    case plus = "plus"
    case cancle = "multiply"
    case next = "chevron.right"
    case back = "chevron.left"
    case uncheck = "circle"
    case check = "largecircle.fill.circle"
    case search = "magnifyingglass"
    case reload = "arrow.counterclockwise"
  }
  
  static func shadowMaker(view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    view.layer.shadowRadius = 5
    view.layer.shadowOpacity = 0.5
    view.layer.masksToBounds = false
  }
  
}
