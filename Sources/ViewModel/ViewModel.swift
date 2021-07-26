//
//  ViewModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
