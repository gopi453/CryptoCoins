//
//  CoinsFilterViewModelTests.swift
//  CyptoCoinsTests
//
//  Created by K Gopi on 16/10/24.
//

import XCTest
@testable import CyptoCoins

final class CoinsFilterViewModelTests: XCTestCase {

    private var viewModel: CoinsFilterViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = .init()
    }

    func testSetup() {
        XCTAssertFalse(viewModel.filtersData.isEmpty)
        let filters = viewModel.getFilterData()
        XCTAssertEqual(filters, viewModel.filtersData)
    }

    func testWriteOperation() {
        viewModel.writeData(with: [.init(isSelected: true, value: .activeCoins)])
        XCTAssertTrue(Utility.checkFileExists(for: "coinsFilterData", with: "json"), "No file present")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
