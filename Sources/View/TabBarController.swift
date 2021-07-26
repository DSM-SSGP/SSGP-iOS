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
        setCustomTabBar()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let mapViewController = UINavigationController().then {
            let rootViewController = MapViewController()
            $0.setViewControllers([rootViewController], animated: true)
            $0.title = "지도"
            $0.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBarMapIcon(), selectedImage: nil)
        }
        let productListViewController = UINavigationController().then {
            let rootViewController = ProductListViewController()
            $0.setViewControllers([rootViewController], animated: true)
            $0.title = "제품"
            $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        }
        let myPageViewController = UINavigationController().then {
            let rootViewController = MyPageViewController()
            $0.setViewControllers([rootViewController], animated: true)
            $0.title = "마이페이지"
            $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.fill"), selectedImage: nil)
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
    }
}
