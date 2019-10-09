import XCTest
@testable import VismaSignClient

final class UtilityTests: XCTestCase {

    func testHeaderDateFormatter() {
        let formatter = Date.RFC2822DateFormatter
        // for test purposes
        formatter.timeZone = TimeZone(identifier: "GMT")
        let formattedDate = formatter.date(from: "Tue, 16 May 2017 10:18:18 +0300")
        XCTAssertNotNil(formattedDate)

        let formattedString = formattedDate?.RFC2822String ?? ""
        XCTAssertEqual(formattedString, "Tue, 16 May 2017 10:18:18 +0300")
    }

    #if os(Linux)
    static var allTests = [
        ("testHeaderDateFormatter", testHeaderDateFormatter),
    ]
    #endif
}