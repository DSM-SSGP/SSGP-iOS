//
//  UIDropDownButton.swift
//  SSGP
//
//  Created by 장서영 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import DropDown
import SnapKit
import Then
import RxSwift
import RxCocoa

// MARK: - UIDropDownButton
class UIDropDownButton: UIButton {
    // Properties
    private let disposeBag = DisposeBag()
    private lazy var dropDown = DropDown().then {
        $0.backgroundColor = R.color.background()
        $0.textFont = UIFont.systemFont(ofSize: 15)
        $0.textColor = R.color.accentColor()!
        $0.selectedTextColor = R.color.accentColor()!
        $0.selectionBackgroundColor = R.color.dropDownStroke()!
        $0.cornerRadius = 3
        $0.shadowOpacity = 0.3
        $0.dataSource = SortMethod.allCasesStr()
        $0.selectionAction = { (_: Int, item: String) in
            self.setTitle("\(item) ▾", for: .normal)
        }
        $0.anchorView = self
        $0.bottomOffset = CGPoint(x: 0, y: ($0.anchorView?.plainView.bounds.height) ?? 00)
    }

    // Initialization
    init() {
        super.init(frame: .zero)
        setDropDownButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Private Method
    private func setDropDownButton() {
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        self.contentMode = .right
        self.setTitle("\(SortMethod.allCasesStr()[0]) ▾", for: .normal)
        self.setTitleColor(R.color.accentColor(), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        self.rx.tap.subscribe(onNext: { [weak self] in
            self?.dropDown.show()
        })
        .disposed(by: disposeBag)
    }

}

// MARK: - 정렬 방법 관련 enum
enum SortMethod: String {
    case popularity = "인기순"
    case suggestion = "추천순"
    case lowestPrice = "최저가순"
}

extension SortMethod: CaseIterable {
    static func allCasesStr() -> [String] {
        var arr = [String]()
        for item in self.allCases {
            arr.append(item.rawValue)
        }
        return arr
    }
}
