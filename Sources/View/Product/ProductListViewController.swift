//
//  ProductListViewController.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import Pageboy
import Tabman
import SnapKit
import DropDown
import RxSwift

class ProductListViewController: TabmanViewController {

    let disposeBag = DisposeBag()

    lazy var button = UIDropDownButton().then {
        $0.setAction().subscribe(onNext: {
            switch $0 {
            case .popularity: break
                // 인기순 정렬 코드
            case .suggestion: break
                // 추천순 정렬 코드
            case .lowestPrice: break
                // 최저가순 정렬 코드
            }
        })
        .disposed(by: disposeBag)
    }

    lazy var barButtonItem = UIBarButtonItem(customView: button)

    private var viewControllers: Array<UIViewController> = []

    private let viewModel = ProductListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }

    private func setNavigationBar() {
        setLargeTitleNavigationBar(title: "제품")
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
}
