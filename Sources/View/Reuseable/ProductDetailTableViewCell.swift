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
    
    private let storeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = R.color.background()
    }

    private let eventInfoLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textColor = .white
    }
    
    private let originalPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = R.color.smallTitle()
    }
    
    private let eventPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .white
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupSubView()
        originalPriceLabelAttribute()
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
    
    public func bind() {
        //demo data
        self.storeImageView.image = R.image.storeIcon()
        self.eventInfoLabel.text = "1+1"
        self.originalPriceLabel.text = "1500"
        self.eventPriceLabel.text = "750"
    }
    
    // MARK: - private method
    
    private func originalPriceLabelAttribute() {
        let attributeString = NSMutableAttributedString(string: originalPriceLabel.text!)
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        originalPriceLabel.attributedText = attributeString
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

}
