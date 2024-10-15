//
//  DashBoardAPIRepository.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import Foundation
import Combine
enum CoinType: String, Codable {
    case coin
    case token
}
struct DashboardData: Codable {
    let name: String
    let symbol: String
    let isNew: Bool
    let isActive: Bool
    let type: CoinType
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }

    var coinImage: String {
        if !isActive {
            //dot image with new banner
        }
        if isNew {
            //black with new banner
        }
        switch type {
        case .coin:
            if isActive {
                //yellow coin

            }

        case .token:
            if isActive {
                //black coin

            }
        }
        return ""
    }
}


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
