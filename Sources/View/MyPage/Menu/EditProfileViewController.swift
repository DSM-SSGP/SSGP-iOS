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
import Loaf
import KeychainSwift

class EditProfileViewController: UIViewController {
    
    let disposedBag = DisposeBag()
    let viewModel = MyPageViewModel()
    let keyChain = KeychainSwift()
    
    private let confirmButtonIsTapped = PublishSubject<String>()

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
        bind()
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
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
    }

    private func bind() {
        let input = MyPageViewModel.Input(
            confirmButtonIsTapped: self.confirmButtonIsTapped.asDriver(onErrorJustReturn: ""))

        let output = viewModel.transform(input)

        self.doneButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                if currentPWTextField.text == self.keyChain.get("PASSWORD") {
                    if newPWTextField.text == confirmPWTextField.text {
                        self.confirmButtonIsTapped.onNext((
                            self.confirmPWTextField.text ?? ""
                        ))
                    } else {
                        Loaf(
                            "변경할 비밀번호 확인에 실패하였습니다.",
                             state: .error,
                             location: .bottom,
                             sender: self
                        ).show()
                    }
                } else {
                    Loaf(
                        "현재 비밀번호를 확인해 주세요.",
                         state: .error,
                         location: .bottom,
                         sender: self
                    ).show()
                }
            }).disposed(by: disposedBag)

        output.changePasswordResult
            .subscribe(onNext: { [weak self] isSuccess in
            if isSuccess {
                Loaf("비밀번호 변경이 완료되었습니다.",
                     state: .success,
                     location: .bottom,
                     sender: self!
                ).show()
                self?.navigationController?.popViewController(animated: true)
            } else {
                Loaf("비밀번호 변경에 실패하였습니다.",
                     state: .error,
                     location: .bottom,
                     sender: self!
                ).show()
            }
        })
    }
}
