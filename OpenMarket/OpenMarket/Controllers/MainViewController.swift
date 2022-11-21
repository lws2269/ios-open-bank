//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    var addItemBarButton: UIBarButtonItem!
    var segmentedControl: UISegmentedControl!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var collectionView: UICollectionView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureCollectionView()
        configureDataSource()
    }
}

// MARK: - 네비게이션 설정
extension MainViewController {
    private func configureNavigation() {
        addItemBarButton = UIBarButtonItem()
        addItemBarButton.target = self
        addItemBarButton.action = #selector(addItem)
        addItemBarButton.image = UIImage(systemName: "plus")

        let items = ["LIST", "GRID"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeItemView), for: .valueChanged)

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

// MARK: - 콜렉션뷰 설정
extension MainViewController {
    enum Section {
        case main
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func configureDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<GridItemCell, Item> { cell, indexPath, item in
            cell.layer.borderColor = UIColor.darkGray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            cell.itemImageView.image = UIImage(systemName: "person")
            cell.itemNameLabel.text = item.name
            cell.priceLabel.text = "\(item.currency.rawValue) \(item.price)"

            if item.bargainPrice != 0 {
                cell.priceLabel.textColor = .systemRed
                cell.bargainPrice.text = "\(item.currency.rawValue) \(item.bargainPrice)"
            }

            if item.stock == 0 {
                cell.stockLabel.textColor = .systemOrange
                cell.stockLabel.text = "품절"
            } else {
                cell.stockLabel.text = "잔여수량 : \(item.stock)"
            }
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: item)
        })

        var itemList: [Item] = []
        NetworkManager().fetchItemList(pageNo: 1, pageCount: 100) { result in
            switch result {
            case .success(let success):
                itemList = success.pages
                DispatchQueue.main.async {
                    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(itemList)
                    self.dataSource.apply(snapshot, animatingDifferences: false)
                }
            case .failure(_):
                print("fail")
            }
        }
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
}
