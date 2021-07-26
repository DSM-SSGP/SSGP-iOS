//
//  UITabBarItem.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/27.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit

extension UITabBarItem {

    func setTabBarItem(title: String, image: UIImage) {
        self.title = title
        self.image = image
        self.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        self.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
            for: .normal
        )
    }

}
