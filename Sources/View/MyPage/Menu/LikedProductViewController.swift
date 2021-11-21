//
//  LikedProductViewController.swift
//  SSGP
//
//  Created by 장서영 on 2021/10/21.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LikedProductViewController: UIViewController {

    let disposeBag = DisposeBag()

    private let likedListTableView = UITableView().then {
        $0.backgroundColor = R.color.background()
        $0.separatorStyle = .none
        $0.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.background()
        setNavigationBar()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func bind() {
        let demoData = ["asdf"]
        let demoOb: Observable<[String]> = Observable.of(demoData)

        demoOb.bind(to: likedListTableView.rx
                        .items(cellIdentifier: "productCell", cellType: ProductTableViewCell.self)) {
            (_, _, cell: ProductTableViewCell) in
            cell.bind()
        }.disposed(by: disposeBag)

    }

    private func setNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setBackButon()
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

        let image = UIImage(systemName: "flame")
        let imageView = UIImageView().then {
            $0.image = image
            $0.tintColor = R.color.fire()
        }

        let textLabel = UILabel().then {
            $0.text  = "표시한 제품"
            $0.textAlignment = .center
        }

        let stackView = UIStackView().then {
            $0.axis  = NSLayoutConstraint.Axis.horizontal
            $0.distribution  = UIStackView.Distribution.equalSpacing
            $0.alignment = UIStackView.Alignment.center
            $0.spacing   = 4.0
            $0.addArrangedSubview(imageView)
            $0.addArrangedSubview(textLabel)
        }
        self.navigationItem.titleView = stackView
    }

    private func setupSubView() {
        self.view.addSubview(likedListTableView)

        likedListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
