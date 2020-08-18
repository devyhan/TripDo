//
//  DeatilHeaderLayout.swift
//  TripDo
//
//  Created by 요한 on 2020/08/10.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit

class DetailHeaderLayout: UICollectionViewFlowLayout {
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let layoutAttributes = super.layoutAttributesForElements(in: rect)
    
    layoutAttributes?.forEach({
      if $0.representedElementKind == UICollectionView.elementKindSectionHeader && $0.indexPath.section == 0 {
        guard let collectionView = collectionView else { return }
        let contentOffsetY = collectionView.contentOffset.y
        if contentOffsetY > 0 {
          return
        }
        
        let width = collectionView.frame.width
        let height = $0.frame.height
        // header
        $0.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
      }
    })
    return layoutAttributes
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
