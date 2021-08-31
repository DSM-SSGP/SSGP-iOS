//
//  NotificationViewController.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/21.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NotificationViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = NotificationViewModel()
    let disposeBag = DisposeBag()

    lazy private var notificationTableView = UITableView().then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.rowHeight = 90
        $0.separatorStyle = .none
        $0.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotificationTableViewCell")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.background()
        setupSubview()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }

    // MARK: - private method

    private func bind() {
        // demo data
        Observable<[Int]>.just([0, 0, 0, 0, 0])
            .bind(to: notificationTableView.rx.items(
                    cellIdentifier: "NotificationTableViewCell",
                    cellType: NotificationTableViewCell.self)
            ) { _, _, cell in
                cell.bind()
            }.disposed(by: disposeBag)
    }

    private func setupSubview() {
        self.view.addSubview(notificationTableView)

        notificationTableView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }

    private func setNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setBackButon()
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationItem.title = "알림"
    }

}

extension NotificationViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ProductTableViewCell {
            cell.disposeCell()
        }
    }
}
