//
//  MyPageViewController.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import KeychainSwift
import Loaf

class MyPageViewController: UIViewController {

    private let viewModel = MyPageViewModel()

    private let logOutButtonTapped = PublishSubject<Void>()

    private lazy var profileImageView = UIImageView().then {
        $0.image = R.image.profileImage()
    }
    private lazy var nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 40)
        $0.text = "ID"
    }
    private lazy var menuTableView = UITableView().then {
        $0.backgroundColor = R.color.myPage()
        $0.separatorStyle = .none
        $0.register(MyPageMenuTableViewCell.self, forCellReuseIdentifier: "myPageCell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.rowHeight = 50
        setSectionHeaderTopPadding()
        view.backgroundColor = R.color.myPage()
        setupSubview()
        setNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    func setSectionHeaderTopPadding() {
        if #available(iOS 15.0, *) {
            menuTableView.sectionHeaderTopPadding = 0
        }
    }

    private func setupSubview() {
        self.view.addSubview(profileImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(menuTableView)

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.width.equalTo(136)
            $0.height.equalTo(153)
            $0.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }

        menuTableView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(350)
        }
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 3
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = R.color.myPageSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myPageCell", for: indexPath)
                as? MyPageMenuTableViewCell else { return UITableViewCell() }

        switch indexPath {
        case [0, 0]:
            cell.menuImageView.image = UIImage(systemName: "flame")
            cell.menuImageView.tintColor = R.color.fire()
            cell.menuLabel.text = "표시한 제품"
        case [1, 0]:
            cell.menuImageView.image = UIImage(systemName: "bell.fill")
            cell.menuImageView.tintColor = R.color.myPageMenu()
            cell.menuLabel.text = "알림 켜기"
            cell.notificationSwitch.isHidden = false
            cell.selectButton.isHidden = true
        case [1, 1]:
            cell.menuImageView.image = UIImage(systemName: "square.and.pencil")
            cell.menuImageView.tintColor = R.color.myPageMenu()
            cell.menuLabel.text = "내 정보 수정"
        case [1, 2]:
            cell.menuImageView.image = UIImage(systemName: "square.and.arrow.up")
            cell.menuImageView.tintColor = R.color.myPageMenu()
            cell.menuLabel.text = "로그아웃"
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0, 0]:
            navigationController?.pushViewController(LikedProductViewController(), animated: true)
        case [1, 1]:
            navigationController?.pushViewController(EditProfileViewController(), animated: true)
        case [1, 2]:
            KeychainSwift().delete("ACCESS-TOKEN")
            Loaf(
                "로그아웃되었습니다.",
                state: .success,
                location: .bottom,
                presentingDirection: .vertical,
                dismissingDirection: .vertical,
                sender: self).show()
            
        default:
            break
        }
    }

    private func bindViewModel() {
        
    }
}
