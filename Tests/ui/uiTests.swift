import XCTest
@testable import ui

class uiTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let u = ui()
        XCTAssertEqual(u.text, "Hello, World!")

        u.smallStart()
    }


    static var allTests : [(String, (uiTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
