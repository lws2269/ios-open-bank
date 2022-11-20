//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum Section: Hashable {
    case main
}

class ViewController: UIViewController {
    let segmentedControl: UISegmentedControl = {
        let item = ["LIST", "GRID"]
        let segmentedController = UISegmentedControl(items: item)
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        return segmentedController
    }()
    /************************/
    // MARK: - 컬렉션 뷰
    private var collectionView: UICollectionView!
    var itemList: [Item] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    /************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        /************************/
        // MARK: - 컬렉션 뷰
        configureCollectionView()
        configureFetchItemList()
        configureDataSource()
        /************************/
    }

    func configureNavigation() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    func configureFetchItemList() {
        guard let dataAsset = NSDataAsset(name: "itemList") else { return }
        let itemList = try? JSONDecoder().decode(ItemList.self, from: dataAsset.data)
        self.itemList = itemList!.pages
    }
}
/******** 컬렉션 뷰 ********/
extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Item> { (cell, indexPath, item) in
            cell.updateWithItem(item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(itemList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("item")
}

extension UICellConfigurationState {
    var item: Item? {
        set { self[.item] = newValue }
        get { return self[.item] as? Item }
    }
}
/************************/
