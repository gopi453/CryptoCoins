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
    private let localFileName = "dashboard"
    private var hasLocalData: Bool {
        fetchLocalData() != nil
    }
    private(set) var dashBoardData: [DashboardData] = []
    init(repo: any Repo) {
        self.repo = repo
    }
    
    convenience init(repo: any Repo, delegate: ViewModelDelegate? = nil, store: LocalStorable) {
        self.init(repo: repo)
        self.delegate = delegate
    }

    func setDelegate(delegate: ViewModelDelegate? = nil) {
        self.delegate = delegate
    }

    func getData() {
        if hasLocalData {
            getLocalData()
        } else {
            Task {
                await getCoinsData()
            }
        }
    }

    func getLocalData() {
        let selectedFilters = Utility.getSelectedFilters()
        self.dashBoardData = self.applyFilter(for: selectedFilters)
        self.delegate?.didreceiveSuccessResponse()
    }

    @MainActor
    func getCoinsData() async {
        do {
            self.dashBoardData = try await repo.fetchCryptoCoins(from: DashBoardRequest())
            self.storeDataLocally()
            self.delegate?.didreceiveSuccessResponse()
        } catch {
            self.delegate?.didreceiveFailResponse(with: error)
        }
    }

    private func storeDataLocally() {
        LocalStorageManager().writeData(dashBoardData, for: localFileName)
    }

    func fetchLocalData() -> [DashboardData]? {
        return Utility.fetchLocalArrayData(for: localFileName, decodeType: [DashboardData].self)
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
