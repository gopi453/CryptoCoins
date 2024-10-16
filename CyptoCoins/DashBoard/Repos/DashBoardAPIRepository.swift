//
//  DashBoardAPIRepository.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import Foundation

protocol DashBoardAPIRepository {
    func fetchCryptoCoins(from request: RequestBuilder) async throws -> [DashboardData]
}

struct DashBoardRequest: RequestBuilder {
    var path: String = ""
}

struct DashBoardRepository: DashBoardAPIRepository {
    private let localCache: LocalStorable
    init(localCache: LocalStorable = LocalStorageManager()) {
        self.localCache = localCache
    }

    func fetchCryptoCoins(from request: RequestBuilder) async throws -> [DashboardData] {
        if let data = localCache.readData(for: .dashboard, fileExtension: .json, decodeType: [DashboardData].self), !data.isEmpty {
            return data
        }
        return try await NetworkManager.shared().makeRequest(from: request, decodeType: [DashboardData].self)
    }
}
