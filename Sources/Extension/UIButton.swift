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

extension UIButton {
    func setDropDownButton() {
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        self.contentMode = .right
        self.setTitle("인기순 ▾", for: .normal)
        self.setTitleColor(R.color.accentColor(), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.backgroundColor = .clear
    }
    func sortList() {
        let dropDown = DropDown()
        dropDown.backgroundColor = R.color.background()
        dropDown.textColor = R.color.accentColor()!
        dropDown.selectedTextColor = R.color.accentColor()!
        dropDown.selectionBackgroundColor = R.color.dropDownStroke()!
        dropDown.cornerRadius = 3
        dropDown.shadowOpacity = 0.3
        dropDown.dataSource = ["인기순", "추천", "최저가순"]
        dropDown.show()
        dropDown.selectionAction = { (_: Int, item: String) in
            self.setTitle("\(item) ▾", for: .normal)
        }
        dropDown.anchorView = self
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height) ?? 00)
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
    }
}
