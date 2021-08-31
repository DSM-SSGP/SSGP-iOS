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
import Lottie
import AuthenticationServices

class LoginViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    private let welcomeLabel = UILabel().then {
        $0.text = "애플 아이디로\n싸가편을 시작하세요!"
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
    private let loginButton = ASAuthorizationAppleIDButton(type: .continue, style: .whiteOutline)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
        bind()
    }

    // MARK: - private method
    private func setupSubview() {
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(imageView)
        self.imageView.addSubview(pulseAnimationView)
        self.pulseAnimationView.addSubview(iconImageView)
        self.view.addSubview(loginButton)

        welcomeLabel.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(100)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalTo(self.loginButton.snp.top).offset(-30)
        }
        pulseAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(self.pulseAnimationView.snp.width)
        }
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(25)
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-50)
        }
        loginButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-50)
        }
    }

    private func bind() {
    }
}
