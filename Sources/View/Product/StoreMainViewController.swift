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

    let viewModel = ProductListViewModel()

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
        switch index {
        case 0:
            viewModel.output.getLists.asObservable()
                .bind(
                    to: tableView.rx.items(
                        cellIdentifier: "ProductTableViewCell",
                        cellType: ProductTableViewCell.self)) { _, element, cell in
                            print("asdfasdfasdf")
                            cell.bind(
                                title: element.name,
                                price: element.price,
                                likeCount: element.like_count,
                                store: element.brands)
            }.disposed(by: disposeBag)
        case 1:
            viewModel.output.gs25Lists.asObservable()
                .bind(
                    to: tableView.rx.items(
                        cellIdentifier: "ProductTableViewCell",
                        cellType: ProductTableViewCell.self)) { _, element, cell in
                            cell.bind(
                                title: element.name,
                                price: element.price,
                                likeCount: element.like_count,
                                store: element.brands)
            }.disposed(by: disposeBag)

        case 2:
            viewModel.output.cuLists.asObservable()
                .bind(
                    to: tableView.rx.items(
                        cellIdentifier: "ProductTableViewCell",
                        cellType: ProductTableViewCell.self)) { _, element, cell in
                            cell.bind(
                                title: element.name,
                                price: element.price,
                                likeCount: element.like_count,
                                store: element.brands)
            }.disposed(by: disposeBag)

        case 3:
            viewModel.output.miniStopLists.asObservable()
                .bind(
                    to: tableView.rx.items(
                        cellIdentifier: "ProductTableViewCell",
                        cellType: ProductTableViewCell.self)) { _, element, cell in
                            cell.bind(
                                title: element.name,
                                price: element.price,
                                likeCount: element.like_count,
                                store: element.brands)
            }.disposed(by: disposeBag)

        case 4:
            viewModel.output.sevenElevenLists.asObservable()
                .bind(
                    to: tableView.rx.items(
                        cellIdentifier: "ProductTableViewCell",
                        cellType: ProductTableViewCell.self)) { _, element, cell in
                            cell.bind(
                                title: element.name,
                                price: element.price,
                                likeCount: element.like_count,
                                store: element.brands)
            }.disposed(by: disposeBag)

        case 5:
            viewModel.output.emart24Lists.asObservable()
                .bind(
                    to: tableView.rx.items(
                        cellIdentifier: "ProductTableViewCell",
                        cellType: ProductTableViewCell.self)) { _, element, cell in
                            cell.bind(
                                title: element.name,
                                price: element.price,
                                likeCount: element.like_count,
                                store: element.brands)
            }.disposed(by: disposeBag)

        default:
            break
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
