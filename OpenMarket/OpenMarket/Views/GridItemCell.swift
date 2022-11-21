//
//  GridItemCell.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/11/21.
//

import UIKit

class GridItemCell: UICollectionViewCell {
    override var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    let itemImageView = UIImageView()
    let itemNameLabel = UILabel()
    let priceLabel = UILabel()
    let bargainPrice = UILabel()
    let stockLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false

        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.textAlignment = .center
        itemNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        itemNameLabel.numberOfLines = 0

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .center

        bargainPrice.translatesAutoresizingMaskIntoConstraints = false
        bargainPrice.textAlignment = .center

        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.textAlignment = .center

        contentView.addSubview(itemImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(bargainPrice)
        contentView.addSubview(stockLabel)
    }

    private func configureConstraints() {
        let inset = CGFloat(5)

        NSLayoutConstraint.activate([
            itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),

            itemNameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: inset),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            itemNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),

            priceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: inset),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),

            bargainPrice.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            bargainPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            bargainPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),

            stockLabel.topAnchor.constraint(equalTo: bargainPrice.bottomAnchor, constant: inset),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
}
