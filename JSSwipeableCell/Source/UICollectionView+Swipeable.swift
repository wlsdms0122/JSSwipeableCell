//
//  UICollectionView+Swipeable.swift
//  timer
//
//  Created by JSilver on 2020/04/15.
//  Copyright © 2020 Jeong Jin Eun. All rights reserved.
//

import UIKit

public extension UICollectionView {
    var swipeCells: [JSSwipeableCollectionViewCell] {
        visibleCells.compactMap { $0 as? JSSwipeableCollectionViewCell }
            .filter { $0.direction != nil }
    }
}
