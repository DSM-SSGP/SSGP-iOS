//
//  LoginViewController.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/15.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Lottie
import AuthenticationServices
import TextFieldEffects
import RxKeyboard
import Loaf

class LoginViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    private let loginButtonIsTapped = PublishSubject<(id: String, pwd: String)>()

    private let welcomeLabel = UILabel().then {
        $0.text = "로그인 하여\n싸가편을 시작하세요!"
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.numberOfLines = 0
        // 부분 text custom
        let attributedStr = NSMutableAttributedString(string: $0.text!)
        attributedStr.addAttribute(
            .foregroundColor,
            value: R.color.accentColor()!,
            range: ($0.text! as NSString).range(of: "싸가편")
        )
        attributedStr.addAttribute(
            .font,
            value: UIFont.boldSystemFont(ofSize: 30),
            range: ($0.text! as NSString).range(of: "싸가편")
        )
        $0.attributedText = attributedStr
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = R.image.loginPageImage()
    }
    private let pulseAnimationView = AnimationView(name: "pulse").then {
        $0.loopMode = .loop
        $0.animationSpeed = 0.75
        $0.backgroundBehavior = .pauseAndRestore
        $0.play()
    }
    private let iconImageView = UIImageView().then {
        $0.image = R.image.storeIcon()
        $0.contentMode = .scaleAspectFit
    }
    private let loginContentView = UIView().then {
        $0.backgroundColor = R.color.background()
        $0.layer.cornerRadius = 20
    }
    private let idTextField = HoshiTextField().then {
        $0.placeholder = "ID"
        $0.font = .systemFont(ofSize: 17)
        $0.placeholderColor = R.color.noticeTitle()!
        $0.borderInactiveColor = R.color.noticeTitle()
        $0.borderActiveColor = R.color.accentColor()
        $0.keyboardType = .asciiCapable
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    private let pwTextField = HoshiTextField().then {
        $0.placeholder = "PW"
        $0.font = .systemFont(ofSize: 17)
        $0.placeholderColor = R.color.noticeTitle()!
        $0.borderInactiveColor = R.color.noticeTitle()
        $0.borderActiveColor = R.color.accentColor()
        $0.isSecureTextEntry = true
        $0.keyboardType = .asciiCapable
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    private let loginButton = UIButton(type: .system).then {
        $0.backgroundColor = R.color.accentColor()
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20)
        $0.layer.cornerRadius = 15
    }
    private let joinButton = UIButton(type: .system).then {
        $0.titleLabel?.font = .systemFont(ofSize: 12)
        $0.titleLabel?.lineBreakMode = .byWordWrapping
        $0.titleLabel?.textAlignment = .center
        $0.setTitle("아직 회원이 아니시라면?\n회원가입", for: .normal)
        $0.setTitleColor(R.color.noticeTitle(), for: .normal)
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
        setKeyboardAction()
        bind()
    }

    // MARK: - private method
    private func setupSubview() {
        self.view.addSubview(imageView)
        self.imageView.addSubview(pulseAnimationView)
        self.pulseAnimationView.addSubview(iconImageView)
        self.view.addSubview(loginContentView)
        self.loginContentView.addSubview(welcomeLabel)
        self.loginContentView.addSubview(idTextField)
        self.loginContentView.addSubview(pwTextField)
        self.loginContentView.addSubview(joinButton)
        self.loginContentView.addSubview(loginButton)

        imageView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(160)
        }
        loginContentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(140)
            $0.bottom.equalToSuperview().offset(20)
        }
        pulseAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(150)
        }
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(10)
            $0.height.width.equalTo(80)
        }
        welcomeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(30)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(60)
        }
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(60)
        }
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pwTextField.snp.bottom).offset(25)
        }
        loginButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }

    private func setKeyboardAction() {
        self.view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardHeight in
                self.loginContentView.snp.updateConstraints {
                    if keyboardHeight == 0.0 {
                        $0.top.equalToSuperview().offset(140)
                    } else {
                        $0.top.equalToSuperview().offset(0)
                    }
                }
                self.welcomeLabel.snp.updateConstraints {
                    if keyboardHeight == 0.0 {
                        $0.top.equalToSuperview().offset(30)
                    } else {
                        $0.top.equalToSuperview().offset(60)
                    }
                }
                self.loginButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-keyboardHeight-40)
                }
            })
            .disposed(by: disposeBag)
    }

    private func bind() {
        let input = LoginViewModel.Input(
            loginButtonIsTapped: self.loginButtonIsTapped.asDriver(
                onErrorJustReturn: ("", "")
            )
        )
        let output = viewModel.transform(input)

        self.loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.loginButtonIsTapped.onNext((
                    id: self?.idTextField.text ?? "",
                    pwd: self?.pwTextField.text ?? ""
                ))
            })
            .disposed(by: disposeBag)

        output.loginResult.subscribe(onNext: { [weak self] isSuccess in
            if isSuccess {
                Loaf(
                    "로그인 성공",
                    state: .success,
                    location: .top,
                    sender: self!
                ).show()
            } else {
                Loaf(
                    "아이디 혹은 비밀번호가 틀렸습니다.",
                    state: .error,
                    location: .top,
                    sender: self!
                ).show()
            }
        }).disposed(by: disposeBag)
    }
}
