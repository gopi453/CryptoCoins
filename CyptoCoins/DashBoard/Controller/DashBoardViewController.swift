//
//  ViewController.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import UIKit

class DashBoardViewController: UIViewController {
    private var viewModel: DashBoardViewModel?
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()

    init(viewModel: DashBoardViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "COIN"
        self.setNavigationAppearance()
        self.setRightBarButtonItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: nil, image: .init(systemName: "magnifyingglass"), target: self, action: #selector(searchButtonTapped))
        rightBarButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func searchButtonTapped(_ sender: UIBarButtonItem) {
        showFilterViewControllerInACustomizedSheet()
    }

    func showFilterViewControllerInACustomizedSheet() {
        let filterViewModel = CoinsFilterViewModel()
        let filterController = CoinsFilterViewController(viewModel: filterViewModel, delegate: self)
        let filterNavController = UINavigationController(rootViewController: filterController)

        if let sheet = filterNavController.sheetPresentationController {
            sheet.detents = [.custom(resolver: { [weak self] context in
                (self?.view.frame.size.height ?? 0) * 0.2
            })]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(filterNavController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        registerTableCells()
    }

    private func setup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        viewModel?.setDelegate(delegate: self)
    }

    private func registerTableCells() {
        self.tableView.register(DashboardTableViewCell.self, forCellReuseIdentifier: DashboardTableViewCell.reuseIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.getData()
    }

}
extension DashBoardViewController: ViewModelDelegate {
    func didreceiveSuccessResponse() {
        tableView.reloadData()
    }
    
    func didreceiveFailResponse(with error: any Error) {
        //failure
        print(error)
    }
}

extension DashBoardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel?.dashBoardData.isEmpty == true {
            tableView.setMessage("No data to display")
        } else {
            tableView.clearBackground()
        }
        return viewModel?.dashBoardData.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTableViewCell.reuseIdentifier, for: indexPath) as? DashboardTableViewCell else {
            return .init()
        }
        cell.dashBoardData = viewModel?.dashBoardData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
extension DashBoardViewController: CoinsFilterViewControllerDelegate {
    func didFinishSelectingFilter(with value: [CoinsFilterCollectionData]) {
        self.viewModel?.updateData(for: value)
        tableView.reloadSections(IndexSet(integersIn: 0...tableView.numberOfSections - 1), with: .automatic)
    }
}

