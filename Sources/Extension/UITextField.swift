//
//  UITextField.swift
//  SSGP
//
//  Created by 장서영 on 2021/10/18.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit

extension UITextField {

    func underLine() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.width, height: 2)
        border.borderWidth = 2
        border.borderColor = R.color.accentColor()?.cgColor
        self.layer.addSublayer(border)
        self.adjustsFontSizeToFitWidth = true
    }
}
