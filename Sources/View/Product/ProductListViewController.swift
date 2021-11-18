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
        setNavigationBar()
        setViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }

    private func setNavigationBar() {
        setLargeTitleNavigationBar(title: "제품")
        self.navigationItem.rightBarButtonItem = barButtonItem
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
    }

    private func setViewControllers() {
        let storeMainVC = StoreMainViewController()
        let GS25VC = GS25ViewController()
        let CUVC = CUViewController()
        let miniStopVC = MiniStopViewController()
        let sevenElevenVC = SevenElevenViewController()
        let emartVC = EmartViewController()

        [storeMainVC, GS25VC, CUVC, miniStopVC, sevenElevenVC, emartVC].forEach({ viewControllers.append($0) })

        self.dataSource = self

        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.backgroundView.style = .clear
        bar.indicator.overscrollBehavior = .bounce
        addBar(bar, dataSource: self, at: .top)
    }
}

extension ProductListViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            let item = TMBarItem(title: "")
            item.title = "전체"
            return item
        case 1:
            let item = TMBarItem(title: "")
            item.title = "GS25"
            return item
        case 2:
            let item = TMBarItem(title: "")
            item.title = "CU"
            return item
        case 3:
            let item = TMBarItem(title: "")
            item.title = "MiniStop"
            return item
        case 4:
            let item = TMBarItem(title: "")
            item.title = "7"
            return item
        case 5:
            let item = TMBarItem(title: "")
            item.title = "Emart"
            return item
        default:
            let item = TMBarItem(title: "")
            return item
        }
    }
}
