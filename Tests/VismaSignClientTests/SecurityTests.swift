import XCTest
@testable import VismaSignClient

final class SecurityTests: XCTestCase {

    // The test is validated by 'https://passwordsgenerator.net/md5-hash-generator/'
    func testMD5Calculator() {
        // {"name":"secret"}
        let body = MockBodyData(name: "secret").data
        XCTAssertNotNil(body?.md5)
        XCTAssertGreaterThan(body?.md5?.count ?? 0, 0)

        let md5Data = Data(bytes: body!.md5!)
        XCTAssertNotNil(md5Data.hexString)
        XCTAssertEqual("44E2EAE6125F863485F68395C497F9FA".lowercased(), md5Data.hexString)
    }

    // The test is validated by 'https://base64.guru/converter/decode/hex'
    func testHexToBase64() {
        let secretInHex = "8e9ed28ce3abe1ccd14e27c2a37d2ac74b19008c3d3d6faf569b1b3f4f6941a6"
        XCTAssertEqual(secretInHex.base64, "jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY=")
    }

    // The test is validated by 'https://base64.guru/converter/encode/hex'
    func testBase64ToHex() {
        let secretInBase64 = "jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY="
        XCTAssertEqual(Data(base64Encoded: secretInBase64, options: .ignoreUnknownCharacters)?.hexString ?? "", "8e9ed28ce3abe1ccd14e27c2a37d2ac74b19008c3d3d6faf569b1b3f4f6941a6")
    }

    // The test is validated by 'https://cryptii.com/pipes/hmac'
    func testHMACCalculator() {
        // {"name":"secret"}
        let body = MockBodyData(name: "secret").data
        let secret = "jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY="

        let hmac_sha512 = body?.hmac_sha512(key: secret)
        XCTAssertNotNil(hmac_sha512)
        XCTAssertGreaterThan(hmac_sha512?.count ?? 0, 0)

        let hmacData = Data(bytes: hmac_sha512!)
        XCTAssertNotNil(hmacData.hexString)
        XCTAssertEqual("da6c7c9812ff113514bb701c8b3453088c815c753538fc55a87be7026afc66b5b5a613e97287f367d493fe56e7df632f55c404ddc105083a8a0964417c779e19".lowercased(), hmacData.hexString.lowercased())
        XCTAssertEqual("2mx8mBL/ETUUu3AcizRTCIyBXHU1OPxVqHvnAmr8ZrW1phPpcofzZ9ST/lbn32MvVcQE3cEFCDqKCWRBfHeeGQ==".lowercased(), hmacData.hexString.base64!.lowercased())
    }

    #if os(Linux)
    static var allTests = [
        ("testMD5Calculator", testMD5Calculator),
        ("testHexToBase64", testHexToBase64),
        ("testBase64ToHex", testBase64ToHex),
        ("testHMACCalculator", testHMACCalculator),
    ]
    #endif
}

private struct MockBodyData: Encodable {
    let name: String
}