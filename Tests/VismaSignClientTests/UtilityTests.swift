import XCTest
@testable import VismaSignClient

final class UtilityTests: XCTestCase {

    func testHeaderDateFormatter() {
        let mockDateString = "Mon, 07 Dec 2015 22:57:52 +0200"
        let formattedDate = Date.RFC2822DateFormatter.date(from: mockDateString)
        XCTAssertNotNil(formattedDate)

        let formattedString = formattedDate?.RFC2822String ?? ""
        XCTAssertEqual(formattedString, mockDateString)
    }

    #if os(Linux)
    static var allTests = [
        ("testHeaderDateFormatter", testHeaderDateFormatter),
    ]
    #endif
}