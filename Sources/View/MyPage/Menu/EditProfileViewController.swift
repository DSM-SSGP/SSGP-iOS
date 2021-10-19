//
//  EditProfileViewController.swift
//  SSGP
//
//  Created by 장서영 on 2021/10/14.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class EditProfileViewController: UIViewController {

    private let currentPWLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = R.color.noticeTitle()
        $0.text = "현재 PW"
    }

    private let currentPWTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.isSecureTextEntry = true
    }

    private let newPWLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = R.color.noticeTitle()
        $0.text = "변경할 PW"
    }

    private let newPWTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.isSecureTextEntry = true
        $0.borderStyle = .none
    }

    private let confirmPWLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = R.color.noticeTitle()
        $0.text = "변경할 PW 확인"
    }

    private let confirmPWTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.isSecureTextEntry = true
        $0.borderStyle = .none
    }

    private let doneButton = UIButton().then {
        $0.backgroundColor = R.color.accentColor()
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20)
        $0.layer.cornerRadius = 15
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        view.backgroundColor = R.color.myPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        setLargeTitleNavigationBar(title: "내 정보 수정")
    }

    override func viewDidLayoutSubviews() {
        makeUnderLine()
    }

    private func setupSubView() {
        [currentPWLabel, currentPWTextField, newPWLabel,
         newPWTextField, confirmPWLabel, confirmPWTextField, doneButton]
            .forEach({self.view.addSubview($0)})

        currentPWLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.leading.equalToSuperview().offset(30)
        }

        currentPWTextField.snp.makeConstraints {
            $0.top.equalTo(currentPWLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }

        newPWLabel.snp.makeConstraints {
            $0.top.equalTo(currentPWTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(30)
        }

        newPWTextField.snp.makeConstraints {
            $0.top.equalTo(newPWLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }

        confirmPWLabel.snp.makeConstraints {
            $0.top.equalTo(newPWTextField.snp.bottom).offset(15)
            $0.leading.equalTo(30)
        }

        confirmPWTextField.snp.makeConstraints {
            $0.top.equalTo(confirmPWLabel.snp.bottom).offset(10)
            $0.leading.equalTo(30)
            $0.trailing.equalTo(-30)
        }

        doneButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
    }

    private func makeUnderLine() {
        currentPWTextField.underLine()
        newPWTextField.underLine()
        confirmPWTextField.underLine()
    }
}
