//
//  ProductDetailTableViewCell.swift
//  SSGP
//
//  Created by 장서영 on 2021/10/27.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ProductDetailTableViewCell: UITableViewCell {

    let disposeBag = DisposeBag()

    let storeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = R.color.background()
    }

    let eventInfoLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .white
    }

    let originalPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = R.color.smallTitle()
    }

    let eventPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .white
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupSubView()
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

    public func bind(store: String, eventInfo: String, orginalPrice: Int, eventPrice: Int) {
        setStoreIcon(store: store)
        self.eventInfoLabel.text = eventInfo
        self.originalPriceLabel.text = "\(orginalPrice)"
        self.eventPriceLabel.text = String(eventPrice)

        toDollar()
        originalPriceLabelStrikethrough()
    }

    // MARK: - private method

    private func originalPriceLabelStrikethrough() {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(
            string: originalPriceLabel.text ?? "")
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 2,
            range: NSMakeRange(0, attributeString.length)
        )
        originalPriceLabel.attributedText = attributeString
    }

    private func setStoreIcon(store: String) {
        switch store {
        case "GS25":
            self.storeImageView.image = R.image.gs25()
        case "CU":
            self.storeImageView.image = R.image.cU()
        case "SevenEleven":
            self.storeImageView.image = R.image.seveneleveN()
        case "MINISTOP":
            self.storeImageView.image = R.image.ministoP()
        case "Emart24":
            self.storeImageView.image = R.image.emart24()
        default:
            break
        }
    }

    private func setupSubView() {
        self.addSubview(self.contentView)
        [storeImageView, eventInfoLabel, originalPriceLabel, eventPriceLabel].forEach({self.contentView.addSubview($0)})

        storeImageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(25)
            $0.bottom.equalTo(contentView).offset(-25)
            $0.leading.equalTo(contentView).offset(15)
            $0.width.equalTo(70)
            $0.height.equalTo(40)
        }

        eventInfoLabel.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }

        originalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(28)
            $0.trailing.equalTo(contentView).offset(-23)
        }

        eventPriceLabel.snp.makeConstraints {
            $0.top.equalTo(originalPriceLabel.snp.bottom)
            $0.trailing.equalTo(contentView).offset(-23)
        }
    }

    private func toDollar() {
        originalPriceLabel.text = "₩" + (originalPriceLabel.text ?? "")
        eventPriceLabel.text = "₩" + (eventPriceLabel.text ?? "")
    }
}
