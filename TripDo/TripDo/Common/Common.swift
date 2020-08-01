//
//  Common.swift
//  TripDo
//
//  Created by 요한 on 2020/08/01.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit

struct Common {
  
  // App MainColor
  
  static let mainColor: UIColor = UIColor(
    red: 254 / 255,
    green: 177 / 255,
    blue: 94 / 255,
    alpha: 1)
  
  enum NavigationTitle: String {
    case map = "Map"
    case home = "Home"
    case navBarTitle = "CafeSpot"
  }
  
  enum SFSymbolKey: String {
    case house = "house.fill"
    case plus = "plus"
  }
  
}
