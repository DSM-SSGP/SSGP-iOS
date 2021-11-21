//
//  UIView.swift
//  SSGP
//
//  Created by 김수완 on 2021/10/27.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import RxViewController

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
