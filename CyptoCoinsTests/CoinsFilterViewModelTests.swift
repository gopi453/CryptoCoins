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
        XCTAssertTrue(Utility.checkFileExists(for: .coinsFilter, with: .json), "No file present")
        viewModel.writeData(with: [.init(isSelected: true, value: .inactiveCoins), .init(isSelected: false, value: .onlyTokens)])
        XCTAssertFalse(Utility.checkFileExists(for: .custom("CustomValue"), with: .json), "No file present")
    }

    func testFileExistence() {
        XCTAssert(Utility.checkFileExists(for: .custom("//*"), with: .rich) == false)
        XCTAssertFalse(Utility.checkFileExists(for: .coinsFilter, with: .text), "No file present")
        XCTAssertFalse(Utility.checkFileExists(for: .dashboard, with: .text), "No file present")
        XCTAssertFalse(Utility.checkFileExists(for: .dashboard, with: .rich), "No file present")
        XCTAssertFalse(Utility.checkFileExists(for: .dashboard, with: .rich), "No file present")
        XCTAssertFalse(Utility.checkFileExists(for: .dashboard, with: .rich), "No file present")

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
