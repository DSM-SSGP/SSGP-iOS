//
//  StoreMainViewController.swift
//  SSGP
//
//  Created by 장서영 on 2021/11/18.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Moya

class StoreMainViewController: UIViewController {

    let disposeBag = DisposeBag()

    let productModel = [ProductResponse]()

    var getLists = PublishSubject<[ProductResponse]>()

    let tableView = UITableView().then {
        $0.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        $0.backgroundColor = R.color.background()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()
    }

    private func setUpSubViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(375)
            $0.bottom.equalToSuperview()
        }
    }

    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        getList()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getList() {
        getLists.asObservable()
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: "productCell",
                    cellType: ProductTableViewCell.self)) { _, element, cell in
                        cell.bind(
                            title: element.name,
                            price: element.price,
                            likeCount: element.like_count,
                            store: element.brands)
        }.disposed(by: disposeBag)
    }
}
