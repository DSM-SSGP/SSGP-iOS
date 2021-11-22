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
import Then

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
        view.backgroundColor = R.color.background()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }

    private func setNavigationBar() {
        navigationItem.title = "제품"
        navigationItem.rightBarButtonItem = barButtonItem
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        navigationItem.titleView = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isTranslucent = true
    }

    private func setViewControllers() {
        let storeMainVC = StoreMainViewController(index: 0)
        let GS25VC = StoreMainViewController(index: 1)
        let CUVC = StoreMainViewController(index: 2)
        let miniStopVC = StoreMainViewController(index: 3)
        let sevenElevenVC = StoreMainViewController(index: 4)
        let emartVC = StoreMainViewController(index: 5)

        [storeMainVC, GS25VC, CUVC, miniStopVC, sevenElevenVC, emartVC].forEach({ viewControllers.append($0) })

        self.dataSource = self

        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.backgroundView.style = .clear
        bar.layout.contentMode = .fit
        bar.layout.alignment = .centerDistributed
        bar.indicator.overscrollBehavior = .bounce
        bar.buttons.customize { (button) in
            button.font = .systemFont(ofSize: 12)
        }
        
        addBar(bar, dataSource: self, at: .top)
    }
}

extension ProductListViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            let item = TMBarItem(title: "전체")
            item.image = R.image.cU()
            return item
        case 1:
            let item = TMBarItem(title: "GS25")
            item.image = R.image.gs25()
            return item
        case 2:
            let item = TMBarItem(title: "CU")
            item.image = R.image.cU()
            return item
        case 3:
            let item = TMBarItem(title: "MINI\nSTOP")
            item.image = R.image.ministoP()
            return item
        case 4:
            let item = TMBarItem(title: "SEVEN\nELEVEN")
            item.image = R.image.seveneleveN()
            return item
        case 5:
            let item = TMBarItem(title: "EMART")
            item.image = R.image.emart24()
            return item
        default:
            let item = TMBarItem(title: "")
            return item
        }
    }
}
