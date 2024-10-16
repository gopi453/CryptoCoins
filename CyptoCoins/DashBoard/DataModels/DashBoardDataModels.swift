//
//  DashBoardDataModels.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import Foundation

enum CoinType: String, Codable {
    case coin
    case token
}

struct DashboardData: Codable, Equatable {
    let fileName: String = "dashboard"
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
        switch type {
        case .coin:
                return isActive ? "is_active_coin" : "is_inactive_coin"
        case .token:
            return "is_active_token"
        }
    }

    var bannerImage: String? {
        isNew ? "is_new" : nil
    }
}
