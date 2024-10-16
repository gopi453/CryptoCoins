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
    func fetchCryptoCoins(from request: RequestBuilder) async throws -> [DashboardData] {
        try await NetworkManager.shared().makeRequest(from: request, decodeType: [DashboardData].self)
    }
}
