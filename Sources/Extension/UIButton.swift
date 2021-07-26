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
    
    func sortList(button: UIButton) {
        
        let dropDown = DropDown()
        
        dropDown.backgroundColor = UIColor.
        dropDown.cornerRadius = 3.0
        dropDown.layer.borderWidth = 0.5
        dropDown.layer.borderColor = UIColor.init(named: "DropDownStroke") as! CGColor
        
        dropDown.dataSource = ["인기순", "추천", "최저가순"]
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            button.setTitle("\(item) ▼", for: .normal)
        }
        
        dropDown.anchorView = button
    }
}
