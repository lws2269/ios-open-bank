//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private let addItemBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "plus")
        return button
    }()

    private let segmentedControl: UISegmentedControl = {
        let items = ["LIST", "GRID"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentTintColor = .systemBlue
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        control.selectedSegmentIndex = 0
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureNavigation()
    }
    
    // MARK: - View 설정
    private func configureView() {
        addItemBarButton.target = self
        addItemBarButton.action = #selector(addItem)

        segmentedControl.addTarget(self, action: #selector(changeItemView), for: .valueChanged)
    }

    // MARK: - 네비게이션 설정
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = addItemBarButton
        navigationItem.titleView = segmentedControl
    }

    @objc private func addItem() {
        print("button pressed.")
    }

    @objc private func changeItemView() {
        print("segmented control value changed.")
    }
}
