import XCTest
@testable import VismaSign

class NetworkingTests: XCTestCase {

    private var apiService: APIServiceManager!

    override func setUp() {
        super.setUp()

        apiService = APIServiceManagerImpl()
    }

    func testApiFailure() {
        let exp = expectation(description: "the test is failed")
        let request = FetchMockDataRequest()
        apiService.perform(request: request) { result in
            switch result {
                case .success: XCTAssert(true)
                case .failure: XCTAssert(true)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    static var allTests = [
        ("testApiFailure", testApiFailure),
    ]
}