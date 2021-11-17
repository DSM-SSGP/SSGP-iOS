//
//  MyPageViewModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/31.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxSwift

class MyPageViewModel: ViewModel {

    let disposeBag = DisposeBag()
    let output = Output()

    struct Input {
    }

    struct Output {
    }

    func transform(_ input: Input) -> Output {
        return output
    }
}
