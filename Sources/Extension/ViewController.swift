//
//  ViewController.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit

extension UIViewController {
    func navigateToNotificationViewController() {
        let viewController = NotificationViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func goLoginViewController() {
        let viewController = LoginViewController().then {
            $0.view.backgroundColor = R.color.background()
            $0.modalPresentationStyle = .fullScreen
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    func setNavigationBar(title: String) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setBackButon()
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationItem.title = title
    }
}
