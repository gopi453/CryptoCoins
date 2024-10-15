//
//  DashboardTableViewCell.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import UIKit
protocol ReusableCell {
    static var reuseIdentifier: String {get}
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

class DashboardTableViewCell: UITableViewCell, ReusableCell {

    private lazy var containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.alignment = .center
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        return containerStackView
    }()

    private lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 4
        return contentStackView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        return titleLabel
    }()
    private lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.textColor = .black
        return subTitleLabel
    }()
    private lazy var coinImageView: UIImageView = {
        let coinImageView = UIImageView()
        coinImageView.contentMode = .redraw
        return coinImageView
    }()

    private lazy var bannerImageView: UIImageView = {
        let bannerImageView = UIImageView()
        bannerImageView.contentMode = .scaleAspectFit
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        return bannerImageView
    }()

    var dashBoardData: DashboardData? {
        didSet {
            self.setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.bannerImageView.image = nil
        self.coinImageView.image = nil
    }

    private func setup() {
        selectionStyle = .none
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subTitleLabel)
        let spacer: UIView = .spacer(size: .greatestFiniteMagnitude)
        containerStackView.addArrangedSubview(contentStackView)
        containerStackView.addArrangedSubview(spacer)
        containerStackView.addArrangedSubview(coinImageView)
        coinImageView.addSubview(bannerImageView)
        self.contentView.addSubview(containerStackView)
        NSLayoutConstraint.activate([
            self.containerStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.containerStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.containerStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.containerStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            coinImageView.widthAnchor.constraint(equalToConstant: 56),
            coinImageView.heightAnchor.constraint(equalToConstant: 56),
            self.bannerImageView.leadingAnchor.constraint(equalTo: self.coinImageView.leadingAnchor, constant: 0),
            self.bannerImageView.trailingAnchor.constraint(equalTo: self.coinImageView.trailingAnchor, constant: 0),
            self.bannerImageView.topAnchor.constraint(equalTo: self.coinImageView.topAnchor, constant: 0),
            self.bannerImageView.bottomAnchor.constraint(equalTo: self.coinImageView.bottomAnchor, constant: 0),
        ])
    }

    private func setData() {
        guard let dashBoardData else { return }
        self.titleLabel.text = dashBoardData.name
        self.subTitleLabel.text = dashBoardData.symbol
        self.coinImageView.image = UIImage(named: dashBoardData.coinImage)
        self.bannerImageView.isHidden = !dashBoardData.isNew
        if let bannerImage = dashBoardData.bannerImage {
            self.bannerImageView.image = UIImage.init(named: bannerImage)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension UIView {
    static func spacer(size: CGFloat = 10, for layout: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        if layout == .horizontal {
            constraint = spacer.widthAnchor.constraint(equalToConstant: size)
        } else {
            constraint = spacer.heightAnchor.constraint(equalToConstant: size)
        }
        constraint.priority = .defaultLow
        constraint.isActive = true
        return spacer
    }
}
