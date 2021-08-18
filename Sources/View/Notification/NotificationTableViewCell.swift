//
//  NotificationTableViewCell.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/17.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NotificationTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()

    private let storeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let storeNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = R.color.smallTitle()
    }
    private let receivedTimeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = R.color.smallTitle()
    }
    private let contentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = R.color.noticeTitle()
        $0.numberOfLines = 0
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

    public func bind() {
        // 후에 파라미터로 데이터 받아서 바인딩

        // demo data
        let brand: Brand = .cu
        storeImageView.image = brand.fitImage()
        storeNameLabel.text = "CU"
        receivedTimeLabel.text = "1일 전"
        contentLabel.text = "김수완님! CU에서 수완님이 좋아요를 표시하신 돼지바가 1+1행사를 시작했어요!"
    }

    public func disposeCell() {
        self.disposeBag = DisposeBag()
        self.backgroundColor = .clear
    }

    // MARK: - private method

    private func setupSubview() {
        self.addSubview(self.contentView)
        self.contentView.addSubview(storeImageView)
        self.contentView.addSubview(storeNameLabel)
        self.contentView.addSubview(receivedTimeLabel)
        self.contentView.addSubview(contentLabel)

        storeImageView.snp.makeConstraints {
            $0.height.equalTo(25)
            $0.top.equalToSuperview().offset(9)
            $0.left.equalToSuperview().offset(14)
        }
        storeNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.storeImageView)
            $0.left.equalTo(self.storeImageView.snp.right).offset(5)
        }
        receivedTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.storeImageView)
            $0.right.equalToSuperview().offset(-14)
        }
        contentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(self.storeImageView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-14)
        }
    }

    private func setUnidentified(_ unidentified: Bool) {
        self.contentView.backgroundColor = unidentified ? R.color.unidentified() : .clear
    }

}
