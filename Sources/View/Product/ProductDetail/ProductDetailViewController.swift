//
//  ProductDetailViewController.swift
//  SSGP
//
//  Created by 장서영 on 2021/10/25.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class ProductDetailViewController: UIViewController {

    let disposeBag = DisposeBag()
    let getId = PublishSubject<String>()
    var detailViewModel:  ProductDetailViewModel

    var productId = String()

    private let imgView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white // instead demo data
    }

    private let productName = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 35)
    }

    private let countFireLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
    }

    private let fireBarButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "flame")
        $0.tintColor = R.color.notSelectedIcon()
    }

    private let productDetailTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(ProductDetailTableViewCell.self, forCellReuseIdentifier: "productDetailCell")
        $0.rowHeight = 90
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        countFireLabelAttribute()
        setupSubView()
        view.backgroundColor = R.color.background()
        fireRadioButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        bind()
    }

    init(productId: String, name: String) {
        self.detailViewModel = ProductDetailViewModel(productId: productId)
        self.productName.text = name
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setBackButon()
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationItem.title = title
        self.navigationItem.setRightBarButton(fireBarButton, animated: true)
    }

    private func countFireLabelAttribute() {
        let attributeText = NSMutableAttributedString()
        let buttonImg = UIImage(systemName: "flame")
        let redButton = buttonImg?.withTintColor(R.color.fire()!, renderingMode: .alwaysTemplate)
        let img = NSTextAttachment(image: redButton!)
        attributeText.append(NSAttributedString(attachment: img))
        attributeText.append(NSAttributedString(string: "  0"))
        countFireLabel.attributedText = attributeText
        countFireLabel.sizeToFit()
    }

    private func setupSubView() {
        [imgView, productName, countFireLabel, productDetailTableView].forEach({self.view.addSubview($0)})

        imgView.snp.makeConstraints {
            $0.top.equalTo(110)
            $0.width.height.equalTo(170)
            $0.centerX.equalToSuperview()
        }

        productName.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        countFireLabel.snp.makeConstraints {
            $0.top.equalTo(productName.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }

        productDetailTableView.snp.makeConstraints {
            $0.top.equalTo(countFireLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(50)
        }
    }

    private func fireRadioButton() {
        fireBarButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                if fireBarButton.tintColor == R.color.notSelectedIcon() {
                    fireBarButton.tintColor = R.color.fire()
                } else {
                    fireBarButton.tintColor = R.color.notSelectedIcon()
                }
            }).disposed(by: disposeBag)
    }
    private func bind() {
        let input = ProductDetailViewModel.Input.init()

        let output = detailViewModel.transform(input)

        output.productDetail.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)

        output.productDetail.bind(
            to: productDetailTableView.rx.items(
            cellIdentifier: "productDetailCell",
            cellType: ProductDetailTableViewCell.self)) { _, data, cell in
                cell.bind(
                    store: data.brand,
                    eventInfo: data.content,
                    orginalPrice: data.price,
                    eventPrice: data.selling_price)
            }.disposed(by: disposeBag)
    }
}
