//
//  ProductListViewModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/31.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ProductListViewModel: ViewModel {

    let disposeBag = DisposeBag()
    var output = Output()

    struct Input {
        let getPopularLists: Driver<Void>
        let getRecommendLists: Driver<Void>
        let getLowPriceLists: Driver<Void>
       // let likeButtonIsTapped: Driver<Void>

        let searchProductIsTapped: Driver<String>

        let itemSelected: Driver<(String, IndexPath)>
    }

    struct Output {
        var allList = BehaviorSubject<[ProductResponse]>(value: [])
        var gs25Lists = BehaviorSubject<[ProductResponse]>(value: [])
        var cuLists = BehaviorSubject<[ProductResponse]>(value: [])
        var miniStopLists = BehaviorSubject<[ProductResponse]>(value: [])
        var sevenElevenLists = BehaviorSubject<[ProductResponse]>(value: [])
        var emart24Lists = BehaviorSubject<[ProductResponse]>(value: [])

        var likeresult = PublishSubject<Bool>()

        var selectedItem = PublishSubject<ProductResponse>()
    }

    func transform(_ input: Input) -> Output {
        input.searchProductIsTapped.asObservable()
            .subscribe(onNext: { searchWord in
                HTTPClient.shared.networking(
                    api: .searchProduct(searchWord),
                    model: Search.self
                ).subscribe(onSuccess: { response in
                    self.storeFiltering(model: response.application_responses)
                }, onFailure: { error in
                    print(error)
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)

        input.getPopularLists.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(
                api: .popularityList,
                model: [ProductResponse].self
            ).subscribe(onSuccess: { response in
                self.storeFiltering(model: response)
            }, onFailure: { error in
                print(error)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        input.getRecommendLists.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(
                api: .recommendationList,
                model: [ProductResponse].self
            ).subscribe(onSuccess: { response in
                self.storeFiltering(model: response)
            }, onFailure: { error in
                print(error)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        input.getLowPriceLists.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(
                api: .lowestList,
                model: [ProductResponse].self
            ).subscribe(onSuccess: { response in
                self.storeFiltering(model: response)
            }, onFailure: { error in
                print(error)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        input.itemSelected.asObservable().subscribe(onNext: { type, indexPath in
            switch type {
            case "ALL":
                do {
                    let value = try self.output.allList.value()
                    self.output.selectedItem.onNext(value[indexPath.row])
                } catch { break }
            case "CU":
                do {
                    let value = try self.output.cuLists.value()
                    self.output.selectedItem.onNext(value[indexPath.row])
                } catch { break }
            case "GS25":
                do {
                    let value = try self.output.gs25Lists.value()
                    self.output.selectedItem.onNext(value[indexPath.row])
                } catch { break }
            case "MINISTOP":
                do {
                    let value = try self.output.miniStopLists.value()
                    self.output.selectedItem.onNext(value[indexPath.row])
                } catch { break }
            case "SEVENELEVEN":
                do {
                    let value = try self.output.sevenElevenLists.value()
                    self.output.selectedItem.onNext(value[indexPath.row])
                } catch { break }
            case "EMART24":
                do {
                    let value = try self.output.emart24Lists.value()
                    self.output.selectedItem.onNext(value[indexPath.row])
                } catch { break }
            default:
                break
            }
        }).disposed(by: disposeBag)

        return output
    }

    private func storeFiltering(model: [ProductResponse]) {
        var gs25List = [ProductResponse]()
        var cuList = [ProductResponse]()
        var miniStopList = [ProductResponse]()
        var sevenElevenList = [ProductResponse]()
        var emart24List = [ProductResponse]()

        model.forEach { item in
            item.brands?.forEach {
                switch $0 {
                case "GS25":
                    gs25List.append(item)
                case "CU":
                    cuList.append(item)
                case "MIMISTOP":
                    miniStopList.append(item)
                case "Seven Eleven":
                    sevenElevenList.append(item)
                case "emart24":
                    emart24List.append(item)
                default:
                    break
                }
            }
        }

        output.gs25Lists.onNext(gs25List)
        output.cuLists.onNext(cuList)
        output.miniStopLists.onNext(miniStopList)
        output.sevenElevenLists.onNext(sevenElevenList)
        output.emart24Lists.onNext(emart24List)
        output.allList.onNext(model)
    }
}
