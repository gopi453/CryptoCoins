//
//  DashboardViewModelTests.swift
//  CyptoCoinsTests
//
//  Created by K Gopi on 16/10/24.
//

import XCTest
@testable import CyptoCoins
final class DashboardViewModelTests: XCTestCase {
    private var viewModel: DashBoardViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = .init(repo: DashBoardRepository())
    }

    func testCoinsApi() async throws {
        await viewModel.getCoinsData()
        XCTAssertNotNil(viewModel.dashBoardData)
    }

    func testFilterData() {
        //No filters applied
        viewModel.updateData(for: [])
        XCTAssertEqual(viewModel.applyFilter(for: []), viewModel.dashBoardData)
        //single filters
        let activeCoins: CoinsFilterCollectionData = .init(isSelected: true, value: .activeCoins)
        viewModel.updateData(for: [activeCoins])
        XCTAssertEqual(viewModel.applyFilter(for: [activeCoins]), viewModel.dashBoardData)
        //mulitple filters
        let mulFils: [CoinsFilterCollectionData] = [.init(isSelected: true, value: .inactiveCoins), .init(isSelected: true, value: .onlyTokens)]
        viewModel.updateData(for: mulFils)
        XCTAssertEqual(viewModel.applyFilter(for: mulFils), viewModel.dashBoardData)
    }

    func testWriteOperation() {
        XCTAssertTrue(Utility.checkFileExists(for: .dashboard, with: .json), "No file present")
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
