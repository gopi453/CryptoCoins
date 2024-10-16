//
//  CoinsFilterViewModel.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import UIKit

final class CoinsFilterViewModel {

    private(set) var filtersData: [CoinsFilterCollectionData] = []
    private let localStorage: LocalStorable
    init(localStorage: LocalStorable = LocalStorageManager()) {
        self.localStorage = localStorage
        self.filtersData = getFilterData()
    }

    func getFilterData() -> [CoinsFilterCollectionData] {
        self.getSelectedFilters() ?? getDefaultFilters()
    }

    private func getDefaultFilters() -> [CoinsFilterCollectionData] {
        CoinFilterOptions.allCases.compactMap({
                CoinsFilterCollectionData.init(value: $0)
            })
    }

    func writeData(with data: [CoinsFilterCollectionData]) {
        self.localStorage.writeData(data, for: .coinsFilter, with: .json)
    }

    private func getSelectedFilters() -> [CoinsFilterCollectionData]? {
        guard let data = localStorage.readData(for: .coinsFilter, fileExtension: .json, decodeType: [CoinsFilterCollectionData].self), !data.isEmpty else {
            return nil
        }
        return data
    }

}
