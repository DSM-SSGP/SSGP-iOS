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

class StoreMainViewController: UIViewController, UIScrollViewDelegate {

    let disposeBag = DisposeBag()

    let provider = MoyaProvider<SSGPAPI>()

    let productModel = [ProductList]()

    let tableView = UITableView().then {
        $0.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        $0.backgroundColor = R.color.background()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
