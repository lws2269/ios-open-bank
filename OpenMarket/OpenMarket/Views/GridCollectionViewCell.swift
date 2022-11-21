//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/11/21.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
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
        itemNameLabel.text = "상품명"

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.text = "KRW 10000"

        bargainPrice.translatesAutoresizingMaskIntoConstraints = false
        bargainPrice.text = "KRW 8000"

        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.text = "잔여수량 : 0"

        contentView.addSubview(itemImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(bargainPrice)
        contentView.addSubview(stockLabel)
    }

    private func configureConstraints() {
        let inset = CGFloat(10)

        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: inset),

            itemNameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: inset),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: inset),

            priceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: inset),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: inset),

            bargainPrice.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            bargainPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            bargainPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: inset),

            stockLabel.topAnchor.constraint(equalTo: bargainPrice.bottomAnchor, constant: inset),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: inset),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: inset)
        ])
    }
}
