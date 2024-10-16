//
//  DashBoardViewModel.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import Foundation
protocol ViewModel: AnyObject {
    associatedtype Repo
    init(repo: Repo)
}
protocol ViewModelDelegate: AnyObject {
    func didreceiveSuccessResponse()
    func didreceiveFailResponse(with error: Error)
}

final class DashBoardViewModel: ViewModel {
    typealias Repo = DashBoardAPIRepository
    private let repo: Repo
    private weak var delegate: ViewModelDelegate?
    private var localStore: LocalStorable?
    private(set) var dashBoardData: [DashboardData] = []

    init(repo: any Repo) {
        self.repo = repo
    }
    
    convenience init(repo: any Repo, delegate: ViewModelDelegate? = nil, store: LocalStorable? = LocalStorageManager()) {
        self.init(repo: repo)
        self.delegate = delegate
        self.localStore = store
    }

    func setDelegate(delegate: ViewModelDelegate? = nil) {
        self.delegate = delegate
    }

    func setLocalCache(store: LocalStorable? = LocalStorageManager()) {
        self.localStore = store
    }

    @MainActor
    func getCoinsData() async {
        do {
            self.dashBoardData = try await repo.fetchCryptoCoins(from: DashBoardRequest())
            self.storeDataLocally()
            let selectedFilters = getSelectedFilters()
            self.dashBoardData = applyFilter(for: selectedFilters)
            self.delegate?.didreceiveSuccessResponse()
        } catch {
            self.delegate?.didreceiveFailResponse(with: error)
        }
    }

    func applyFilter(for selectedFilters: [CoinsFilterCollectionData]) -> [DashboardData] {
        let nativeData = fetchLocalData() ?? []
        if selectedFilters.isEmpty {
            return nativeData
        }
        let filteredData = CoinFilter().applyFilter(for: nativeData, filter: selectedFilters)
        return filteredData
    }

    func updateData(for selectedFilters: [CoinsFilterCollectionData]) {
        self.dashBoardData = self.applyFilter(for: selectedFilters)
    }
}
private extension DashBoardViewModel {
    func getSelectedFilters() -> [CoinsFilterCollectionData] {
        let filterViewModel = CoinsFilterViewModel()
        return filterViewModel.filtersData.filter({ $0.isSelected == true })
    }

    func fetchLocalData() -> [DashboardData]? {
        guard let data = localStore?.readData(for: .dashboard, fileExtension: .json, decodeType: [DashboardData].self), !data.isEmpty else {
            return nil
        }
        return data
    }

    func storeDataLocally() {
        localStore?.writeData(dashBoardData, for: .dashboard, with: .json)
    }
}
