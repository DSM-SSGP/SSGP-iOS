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

class LoginViewController: UIViewController {
    // MARK: - Properties
    let disposeBag = DisposeBag()

    private let welcomeLabel = UILabel().then {
        $0.text = "애플 아이디로\n싸가편을 시작하세요!"
        $0.font = UIFont.systemFont(ofSize: 25)
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
            value: UIFont.boldSystemFont(ofSize: 25),
            range: ($0.text! as NSString).range(of: "싸가편")
        )
        $0.attributedText = attributedStr
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
        bind()
    }

    // MARK: - private method
    private func setupSubview() {
        self.view.addSubview(welcomeLabel)

        welcomeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(90)
        }
    }

    private func bind() {
    }
}
