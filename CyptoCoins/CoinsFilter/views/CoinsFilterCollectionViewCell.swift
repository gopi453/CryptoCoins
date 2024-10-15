//
//  CoinsFilterCollectionViewCell.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import UIKit
enum CoinFilterOptions: CaseIterable, CustomStringConvertible {
    case activeCoins, inactiveCoins, onlyTokens, onlyCoins, newCoins
    var description: String {
        switch self {
        case .activeCoins:
            "Active Coins"
        case .inactiveCoins:
            "Inactive Coins"
        case .onlyTokens:
            "Only Tokens"
        case .onlyCoins:
            "Only Coins"
        case .newCoins:
            "New Coins"
        }
    }
}

struct CoinsFilterCollectionData: Hashable {
    var isSelected: Bool = false
    let value: CoinFilterOptions
    static var mockData: [CoinsFilterCollectionData] {
        CoinFilterOptions.allCases.compactMap({
            CoinsFilterCollectionData.init(value: $0)
        })
    }
}

class CoinsFilterCollectionViewCell: UICollectionViewCell, ReusableCell {

    private lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.spacing = 4
        contentStackView.backgroundColor = .gray
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        return contentStackView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        return titleLabel
    }()
    private lazy var selectedImageView: UIImageView = {
        let selectedImageView = UIImageView()
        return selectedImageView
    }()
    private let selectedBackgroundColor: UIColor = .lightGray
    private let unselectedBackgroundColor: UIColor = .lightText
    var filterData: CoinsFilterCollectionData? {
        didSet {
            self.setupData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }

    private func setup() {
        contentView.isUserInteractionEnabled = true
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(self.titleLabel)
//        contentStackView.addArrangedSubview(self.selectedImageView)
        NSLayoutConstraint.activate([
            self.contentStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.contentStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
//            selectedImageView.widthAnchor.constraint(equalToConstant: 18),
//            selectedImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
private extension CoinsFilterCollectionViewCell {
    private func setupData() {
        guard let filterData else { return }
        self.titleLabel.text = filterData.value.description
        self.contentStackView.backgroundColor = filterData.isSelected ? selectedBackgroundColor : unselectedBackgroundColor
    }
}
