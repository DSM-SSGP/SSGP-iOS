//
//  NavigationViewController.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/21.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setBackButon() {
        self.navigationBar.tintColor = .label
        self.navigationBar.topItem?.title = ""
    }
}
