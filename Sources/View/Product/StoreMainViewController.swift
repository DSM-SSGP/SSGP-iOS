//
//  StoreMainViewController.swift
//  SSGP
//
//  Created by 장서영 on 2021/11/18.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import SnapKit
import Then

class StoreMainViewController: UIViewController {
    
    let productModel = [ProductList]()

    let tableView = UITableView().then {
        $0.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        $0.backgroundColor = R.color.background()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpSubViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(375)
            $0.bottom.equalToSuperview()
        }
    }

    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        tableView.tag = index
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoreMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
                as? ProductTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
