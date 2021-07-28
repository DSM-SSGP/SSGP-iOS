//
//  UIButton.swift
//  SSGP
//
//  Created by 장서영 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import Then

extension UIButton {
    func setDropDownButton() {
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        self.contentMode = .right
        self.setTitle("인기순 ▾", for: .normal)
        self.setTitleColor(R.color.accentColor(), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.backgroundColor = .clear
        func sortList() {
            _ = DropDown().then {
                $0.backgroundColor = R.color.background()
                $0.textColor = R.color.accentColor()!
                $0.selectedTextColor = R.color.accentColor()!
                $0.selectionBackgroundColor = R.color.dropDownStroke()!
                $0.cornerRadius = 3
                $0.shadowOpacity = 0.3
                $0.dataSource = ["인기순", "추천", "최저가순"]
                $0.show()
                $0.selectionAction = { (_: Int, item: String) in
                    self.setTitle("\(item) ▾", for: .normal)
                }
                $0.anchorView = self
                $0.bottomOffset = CGPoint(x: 0, y: ($0.anchorView?.plainView.bounds.height) ?? 00)
            }
            DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        }
    }
    
}
