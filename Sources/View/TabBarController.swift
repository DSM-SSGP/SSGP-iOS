//
//  TabBarController.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCustomTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let mapViewController = UINavigationController().then {
            let rootViewController = MapViewController()
            $0.setViewControllers([rootViewController], animated: true)
            $0.tabBarItem.setTabBarItem(title: "지도", image: R.image.tabBarMapIcon()!)
        }
        let productListViewController = UINavigationController().then {
            let rootViewController = ProductListViewController()
            $0.setViewControllers([rootViewController], animated: true)
            $0.tabBarItem.setTabBarItem(title: "제품", image: R.image.tabBarMenuIcon()!)
        }
        let myPageViewController = UINavigationController().then {
            let rootViewController = MyPageViewController()
            $0.setViewControllers([rootViewController], animated: true)
            $0.tabBarItem.setTabBarItem(title: "마이페이지", image: R.image.tabBarPersonIcon()!)
        }

        let controllers = [mapViewController, productListViewController, myPageViewController]
        self.viewControllers = controllers
    }

    // Delegate methods
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController)
    -> Bool {
        return true
    }

    func setCustomTabBar() {
        // set color
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = R.color.background()

        // set tab bar items
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = R.color.tabbarIcon()

        // set corner radius
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = R.color.tabbarIcon()?.cgColor

        // set size
        let height = self.view.frame.size.height / 9
        self.tabBar.frame.size.height = height
        self.tabBar.frame.size.width += 2
        self.tabBar.frame.origin.y = self.view.frame.height - height + 1
        self.tabBar.frame.origin.x -= 1
    }
}
