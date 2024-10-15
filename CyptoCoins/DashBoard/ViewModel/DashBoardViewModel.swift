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
    init(repo: any Repo) {
        self.repo = repo
    }
    private(set) var dashBoardData: [DashboardData] = []

    convenience init(repo: any Repo, delegate: ViewModelDelegate? = nil) {
        self.init(repo: repo)
        self.delegate = delegate
    }

    func setDelegate(delegate: ViewModelDelegate? = nil) {
        self.delegate = delegate
    }

    @MainActor
    func getCoinsData() async {
        do {
            self.dashBoardData = try await repo.fetchCryptoCoins(from: DashBoardRequest())
            self.delegate?.didreceiveSuccessResponse()
        } catch {
            self.delegate?.didreceiveFailResponse(with: error)
        }
    }

    func getNumbersOfrows() -> Int {
        self.dashBoardData.count
    }

}
