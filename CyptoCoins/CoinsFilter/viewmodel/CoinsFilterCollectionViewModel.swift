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
    private let localJSONFileName = "coinsFilterData.json"
    init(localStorage: LocalStorable) {
        self.localStorage = localStorage
        let filterData: [CoinsFilterCollectionData] = self.readData() ?? CoinFilterOptions.allCases.compactMap({
                CoinsFilterCollectionData.init(value: $0)
            })
        self.filtersData = filterData
    }

    func writeData(_ data: [CoinsFilterCollectionData]) {
        self.localStorage.writeData(data, for: localJSONFileName)
    }

    func readData() -> [CoinsFilterCollectionData]? {
        self.localStorage.readData(for: localJSONFileName) as? [CoinsFilterCollectionData]
    }

}
