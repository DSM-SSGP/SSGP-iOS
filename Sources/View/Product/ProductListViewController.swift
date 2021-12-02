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
import RxCocoa
import Then

class ProductListViewController: TabmanViewController {
    let disposeBag = DisposeBag()

    let viewModel = ProductListViewModel()

    private let getPopularLists = PublishSubject<Void>()
    private let getRecommendLists = PublishSubject<Void>()
    private let getLowPriceLists = PublishSubject<Void>()

    private let searchProduct = PublishSubject<String>()

    var items = [String]()

    lazy var button = UIDropDownButton().then {
        $0.setAction().subscribe(onNext: {
            switch $0 {
            case .popularity:
                self.getPopularLists.onNext(())
                self.searchBar.text = ""
            case .suggestion:
                self.getRecommendLists.onNext(())
                self.searchBar.text = ""
            case .lowestPrice:
                self.getLowPriceLists.onNext(())
                self.searchBar.text = ""
            }
        })
        .disposed(by: disposeBag)
    }

    lazy var barButtonItem = UIBarButtonItem(customView: button)

    let searchBar = UISearchBar().then {
        $0.placeholder = "검색"
    }

    private var viewControllers = [StoreMainViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setViewControllers()
        view.backgroundColor = R.color.background()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        bind()
    }

    private func setNavigationBar() {
        navigationItem.title = "제품"
        navigationItem.rightBarButtonItem = barButtonItem
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

    private func search() {
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: {
                self.searchBar.resignFirstResponder()
                self.searchProduct.onNext(self.searchBar.text ?? "")
                print(self.searchBar.text ?? "")
            }).disposed(by: disposeBag)

        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [unowned self] _ in
                if searchBar.text == "" {
                    searchProduct.onNext("")
                }
            }).disposed(by: disposeBag)
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
            return item
        case 1:
            let item = TMBarItem(title: "GS25")
            return item
        case 2:
            let item = TMBarItem(title: "CU")
            return item
        case 3:
            let item = TMBarItem(title: "MINI\nSTOP")
            return item
        case 4:
            let item = TMBarItem(title: "SEVEN\nELEVEN")
            return item
        case 5:
            let item = TMBarItem(title: "EMART")
            return item
        default:
            let item = TMBarItem(title: "")
            return item
        }
    }
    private func bind() {
        let input = ProductListViewModel.Input.init(
            getPopularLists: self.getPopularLists.asDriver(onErrorJustReturn: ()),
            getRecommendLists: self.getRecommendLists.asDriver(onErrorJustReturn: ()),
            getLowPriceLists: self.getLowPriceLists.asDriver(onErrorJustReturn: ()),
            searchProductIsTapped: self.searchProduct.asDriver(onErrorJustReturn: "")
        )

        let output = viewModel.transform(input)

        output.getLists
            .subscribe(onNext: {
            self.viewControllers[0].getLists.onNext($0)
        }).disposed(by: disposeBag)

        output.gs25Lists
            .subscribe(onNext: {
            self.viewControllers[1].getLists.onNext($0)
        }).disposed(by: disposeBag)

        output.cuLists
            .subscribe(onNext: {
            self.viewControllers[2].getLists.onNext($0)
        }).disposed(by: disposeBag)

        output.miniStopLists
            .subscribe(onNext: {
            self.viewControllers[3].getLists.onNext($0)
        }).disposed(by: disposeBag)

        output.sevenElevenLists
            .subscribe(onNext: {
            self.viewControllers[4].getLists.onNext($0)
        }).disposed(by: disposeBag)

        output.emart24Lists
            .subscribe(onNext: {
            self.viewControllers[5].getLists.onNext($0)
        }).disposed(by: disposeBag)

        self.getPopularLists.onNext(())

        search()
    }
}
