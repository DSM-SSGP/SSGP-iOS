//
//  ProductTableViewCell.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/27.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ProductTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    let isLiked = BehaviorRelay<Bool>(value: false)

    private let pruductImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
    }
    private let priceLabel = UILabel().then {
        $0.textAlignment = .right
    }
    private let lowestPriceTextLabel = UILabel().then {
        $0.text = "원가"
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.textColor = R.color.lowestPrice()
    }
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Roboto-Medium", size: 17)
    }
    private let horizontalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }
    private lazy var fireButton = UIButton().then { button in
        button.setImage(UIImage(systemName: "flame"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = R.color.notSelectedIcon()
    }
    private let likeCounterLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    private let nameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
    }

    // MARK: - Initialization & Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupSubview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
           self.setSelected(false, animated: true)
        }
     }

    // MARK: - public method

    public func bind(title: String, price: String, store: [String]) {
        // 후에 파라미터로 데이터 받아서 바인딩

        // demo data
        self.titleLabel.text = "돼지바"
        self.priceLabel.text = "₩2500"
        self.likeCounterLabel.text = "13"
        self.setStoreList([.cu, .gs25, .emart24])

        self.fireButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleFireButton()
            })
            .disposed(by: disposeBag)

        self.isLiked.subscribe(onNext: {
            self.fireButton.tintColor = $0 ? R.color.fire() : R.color.notSelectedIcon()
        })
        .disposed(by: self.disposeBag)
    }

    public func disposeCell() {
        self.isLiked.accept(false)
        self.disposeBag = DisposeBag()
    }

    // MARK: - private method

    private func setupSubview() {
        self.addSubview(self.contentView)
        self.contentView.addSubview(pruductImageView)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(lowestPriceTextLabel)
        self.contentView.addSubview(horizontalStackView)

        self.horizontalStackView.addArrangedSubview(nameStackView)
        self.nameStackView.addArrangedSubview(titleLabel)
        self.nameStackView.addArrangedSubview(fireButton)
        self.nameStackView.addArrangedSubview(likeCounterLabel)

        pruductImageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.bottom.equalTo(contentView).offset(-20)
            $0.left.equalTo(contentView).offset(14)
            $0.width.equalTo(pruductImageView.snp.height)
        }
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.right.equalTo(contentView).offset(-14)
        }
        lowestPriceTextLabel.snp.makeConstraints {
            $0.centerX.equalTo(priceLabel)
            $0.bottom.equalTo(priceLabel.snp.top)
        }
        horizontalStackView.snp.makeConstraints {
            $0.left.equalTo(pruductImageView.snp.right).offset(15)
            $0.right.equalTo(priceLabel.snp.left)
            $0.top.equalTo(contentView).offset(25)
            $0.bottom.equalTo(contentView).offset(-25)
        }

    }

    private func setStoreList(_ stores: [Brand]) {
        if stores.count > 0 {
            if self.horizontalStackView.arrangedSubviews.count > 1 {
                self.horizontalStackView.arrangedSubviews[1].removeFromSuperview()
            }
            let storeListStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 2
            }
            for store in stores {
                storeListStackView.addArrangedSubview(UIImageView(image: store.fitImage()).then {
                    $0.frame.size.height = 18
                    $0.contentMode = .right
                })
            }
            self.horizontalStackView.addArrangedSubview(storeListStackView)
        }
    }

    private func toggleFireButton() {
        isLiked.accept(!isLiked.value)
    }

}
