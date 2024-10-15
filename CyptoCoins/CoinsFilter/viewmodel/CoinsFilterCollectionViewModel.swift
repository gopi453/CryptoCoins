//
//  CoinsFilterCollectionViewModel.swift
//  CyptoCoins
//
//  Created by K Gopi on 15/10/24.
//

import UIKit

final class CoinsFilterCollectionViewModel {
    private(set) var filtersData: [CoinsFilterCollectionData] = []
    init() {
        self.filtersData = CoinsFilterCollectionData.mockData
    }


}
