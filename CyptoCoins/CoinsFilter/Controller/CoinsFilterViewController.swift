//
//  CoinsFilterViewController.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import UIKit
enum CoinsFilterSection: Hashable {
    case all
}

protocol CoinsFilterViewControllerDelegate: AnyObject {
    func didFinishSelectingFilter(with value: [CoinsFilterCollectionData])
}

class CoinsFilterViewController: UIViewController {
    private var viewModel: CoinsFilterViewModel?
    private typealias Snapshot = NSDiffableDataSourceSnapshot<CoinsFilterSection, CoinsFilterCollectionData>
    private typealias DataSource = UICollectionViewDiffableDataSource<CoinsFilterSection, CoinsFilterCollectionData>
    private lazy var dataSource = configureDataSource()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.alwaysBounceVertical = false
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.delegate = self
        return collectionView
    }()
    private weak var delegate: CoinsFilterViewControllerDelegate?

    init(viewModel: CoinsFilterViewModel? = nil, delegate: CoinsFilterViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionView()
        setRightBarButtonItem()
    }

    private func setRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "Done", image: nil, target: self, action: #selector(doneButtonTapped))
        rightBarButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func doneButtonTapped() {
        let items = self.dataSource.snapshot().itemIdentifiers
        self.viewModel?.writeData(with: items)
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.didFinishSelectingFilter(with: items.filter({ $0.isSelected == true }))
        }
    }

}

private extension CoinsFilterViewController {
    func setup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }

    func setupCollectionView() {
        self.collectionView.register(CoinsFilterCollectionViewCell.self, forCellWithReuseIdentifier: CoinsFilterCollectionViewCell.reuseIdentifier)
        self.updateDataSource()
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) in
            if let cell: CoinsFilterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinsFilterCollectionViewCell.reuseIdentifier, for: indexPath) as? CoinsFilterCollectionViewCell {
                cell.filterData = item
                return cell
            }
            return .init()
        }
        return dataSource
    }

    func updateDataSource() {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(viewModel?.filtersData ?? [], toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CoinsFilterViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var snapshot = dataSource.snapshot()
        let selectedItem = snapshot.itemIdentifiers[indexPath.item]
        let updatedItem = CoinsFilterCollectionData(isSelected: !selectedItem.isSelected, value: selectedItem.value)
        // Update the snapshot by deleting the old item and inserting the updated one
        snapshot.insertItems([updatedItem], beforeItem: snapshot.itemIdentifiers[indexPath.item])
        snapshot.deleteItems([selectedItem])
        dataSource.apply(snapshot, animatingDifferences: true)

    }
}

