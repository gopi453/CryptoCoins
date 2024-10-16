//
//  CoinDataModels.swift
//  CyptoCoins
//
//  Created by K Gopi on 16/10/24.
//

import Foundation
enum CoinFilterOptions: Codable, CaseIterable, CustomStringConvertible {
    case activeCoins, inactiveCoins, onlyTokens, onlyCoins, newCoins
    var description: String {
        switch self {
        case .activeCoins: "Active Coins"
        case .inactiveCoins: "Inactive Coins"
        case .onlyTokens: "Only Tokens"
        case .onlyCoins: "Only Coins"
        case .newCoins: "New Coins"
        }
    }
}

struct CoinsFilterCollectionData: Codable, Hashable {
    var isSelected: Bool = false
    let value: CoinFilterOptions
}

protocol Filterable {
    associatedtype Item
    associatedtype Filter
    func applyFilter(for base:[Item], filter: [Filter]) -> [Item]
}

struct CoinFilter: Filterable {
    typealias Item = DashboardData
    typealias Filter = CoinsFilterCollectionData
    func applyFilter(for base:[Item], filter: [Filter]) -> [Item] {
        base.filter { data in
            return filter.contains { options in
                switch options.value {
                case .activeCoins:
                    return data.isActive && data.type == .coin
                case .inactiveCoins:
                    return !data.isActive && data.type == .coin
                case .onlyTokens:
                     return data.type == .token
                case .onlyCoins:
                    return data.type == .coin
                case .newCoins:
                    return data.isNew && data.type == .coin
                }
            }
        }
    }
}
