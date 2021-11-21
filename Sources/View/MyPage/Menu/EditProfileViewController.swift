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
import TextFieldEffects

class EditProfileViewController: UIViewController {

    private let currentPWTextField = HoshiTextField().then {
        $0.placeholder = "현재 PW"
        $0.font = .systemFont(ofSize: 16)
        $0.placeholderColor = R.color.noticeTitle()!
        $0.borderInactiveColor = R.color.noticeTitle()
        $0.borderActiveColor = R.color.accentColor()
        $0.isSecureTextEntry = true
        $0.keyboardType = .asciiCapable
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }

    private let newPWTextField = HoshiTextField().then {
        $0.placeholder = "변경할 PW"
        $0.font = .systemFont(ofSize: 16)
        $0.placeholderColor = R.color.noticeTitle()!
        $0.borderInactiveColor = R.color.noticeTitle()
        $0.borderActiveColor = R.color.accentColor()
        $0.isSecureTextEntry = true
        $0.keyboardType = .asciiCapable
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }

    private let confirmPWTextField = HoshiTextField().then {
        $0.placeholder = "변경할 PW 확인"
        $0.font = .systemFont(ofSize: 16)
        $0.placeholderColor = R.color.noticeTitle()!
        $0.borderInactiveColor = R.color.noticeTitle()
        $0.borderActiveColor = R.color.accentColor()
        $0.isSecureTextEntry = true
        $0.keyboardType = .asciiCapable
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
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
        view.backgroundColor = R.color.background()
    }

    override func viewWillAppear(_ animated: Bool) {
        setLargeTitleNavigationBar(title: "내 정보 수정")
        tabBarController?.tabBar.isHidden = true
    }

    private func setupSubView() {
        [currentPWTextField, newPWTextField, confirmPWTextField, doneButton]
            .forEach({self.view.addSubview($0)})

        currentPWTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(60)
        }

        newPWTextField.snp.makeConstraints {
            $0.top.equalTo(currentPWTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(60)
        }

        confirmPWTextField.snp.makeConstraints {
            $0.top.equalTo(newPWTextField.snp.bottom).offset(10)
            $0.leading.equalTo(30)
            $0.trailing.equalTo(-30)
            $0.height.equalTo(60)
        }

        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
    }
}
