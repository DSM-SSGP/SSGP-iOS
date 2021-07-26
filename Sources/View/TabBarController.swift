//
//  TabBarController.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // Delegate methods
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController)
    -> Bool {
        return true
    }
}
