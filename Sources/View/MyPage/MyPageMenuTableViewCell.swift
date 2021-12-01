//
//  MyPageMenuTableViewCell.swift
//  SSGP
//
//  Created by 장서영 on 2021/09/01.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class MyPageMenuTableViewCell: UITableViewCell {

    lazy var menuImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    lazy var menuLabel = UILabel().then {
        $0.font = UIFont(name: "Roboto-Medium", size: 13)
        $0.textColor = .lightGray
    }
    lazy var selectButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = R.color.myPageMenu()
    }
    lazy var notificationSwitch = UISwitch().then {
        $0.isOn = true
        $0.onTintColor = R.color.accentColor()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = R.color.myPage()
        notificationSwitch.isHidden = true
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

    private func setupSubview() {
        self.addSubview(self.contentView)
        self.contentView.addSubview(menuImageView)
        self.contentView.addSubview(menuLabel)
        self.contentView.addSubview(selectButton)
        self.contentView.addSubview(notificationSwitch)

        menuImageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.bottom.equalTo(contentView).offset(-16)
            $0.left.equalTo(contentView).offset(16)
            $0.width.equalTo(menuImageView.snp.height)
        }

        menuLabel.snp.makeConstraints {
            $0.left.equalTo(menuImageView).offset(30)
            $0.centerY.equalTo(contentView)
        }

        selectButton.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.bottom.equalTo(contentView).offset(-16)
            $0.right.equalTo(contentView).offset(-16)
            $0.width.equalTo(selectButton.snp.height)
        }

        notificationSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-13)
        }
    }
    
    private func bind() {
        
    }
}
