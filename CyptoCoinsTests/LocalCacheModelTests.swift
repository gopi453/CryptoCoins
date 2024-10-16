//
//  LocalCacheModelTests.swift
//  CyptoCoinsTests
//
//  Created by K Gopi on 16/10/24.
//

import XCTest
@testable import CyptoCoins
struct MockJson: Codable {
    let title: String
    let subTitle: String
}

final class LocalCacheModelTests: XCTestCase {
    private var localCache: LocalStorable!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.localCache = LocalStorageManager()
    }

    func testTextFile() {
        let writeData = "hello"
        let fileName: FileName = .custom("testText")
        localCache.writeData(writeData, for: fileName, with: .text)
        let readData = localCache.readData(for: fileName, fileExtension: .text, decodeType: String.self)
        XCTAssertTrue(Utility.checkFileExists(for: fileName, with: .text))
        XCTAssert(writeData == readData, "Data matches with file name")
    }

    func testJsonFile() {
        let writeData: MockJson = .init(title: "testTitle", subTitle: "testSubTitle")
        let fileName: FileName = .custom("testJson")
        localCache.writeData(writeData, for: fileName, with: .json)
        let readData = localCache.readData(for: fileName, fileExtension: .json, decodeType: MockJson.self)
        XCTAssertTrue(Utility.checkFileExists(for: fileName, with: .json))
        XCTAssert(writeData.title == readData?.title, "Title Data matches with file name")
        XCTAssert(writeData.subTitle == readData?.subTitle, "Title Data matches with file name")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        localCache = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
