import XCTest
@testable import VismaSignClient

final class NetworkingTests: XCTestCase {

    private var apiService: APIServiceManager! = APIServiceManagerImpl()

    func testApiFailure() {
        let exp = expectation(description: "the test is failed")
        let request = MockRequest(clientID: "client", secret: "secret")
        apiService.perform(request: request) { result in
            switch result {
                case .success: XCTAssert(true)
                case .failure: XCTAssert(true)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testOrganizationalHeaders() {
        let contentMD5 = MockBodyData(document: MockInternalBody(name: "Test")).data?.md5
        let date = Date.RFC2822DateFormatter.date(from: "Tue, 16 May 2017 10:18:18 +0300")!

        let request = MockRequest(clientID: "ddf58116-6082-4bfc-a775-0c0bb2f945ce", secret: "jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY=")
        let headers = APIRequestHeaderImpl<MockRequest>(request, .organization("jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY=", "ddf58116-6082-4bfc-a775-0c0bb2f945ce", date)).headers
        XCTAssertNotNil(headers)

        XCTAssertEqual(headers![HeaderType.contentType.rawValue], ContentType.applicationJSON.rawValue)
        XCTAssertEqual(headers![HeaderType.contentMD5.rawValue], Data(bytes: contentMD5!).hexString.base64)
        XCTAssertEqual(headers![HeaderType.date.rawValue], "Tue, 16 May 2017 10:18:18 +0300")
        XCTAssertEqual(headers![HeaderType.authorization.rawValue], "Onnistuu ddf58116-6082-4bfc-a775-0c0bb2f945ce:7s+Vee4VG0pObH/GkFpi4DAP1naaaPrPVzOytzbKRe9TBxB+LNzv03jySVFXeFyNJRUY8HRtdlY4e10QpAIFhg==")
    }

    func testPartnerHeaders() {
        let date = Date.RFC2822DateFormatter.date(from: "Tue, 16 May 2017 10:18:18 +0300")!
        let request = ObtainAccessTokenRequest(clientID: "", clientSecret: "")
        let headers = APIRequestHeaderImpl<ObtainAccessTokenRequest>(request, .partner("Bearer", "90e57138faf35289ca2d40d37f49f0980897a8b7", date)).headers
        XCTAssertNotNil(headers)

        XCTAssertEqual(headers![HeaderType.contentType.rawValue], ContentType.applicationJSON.rawValue)
        XCTAssertEqual(headers![HeaderType.date.rawValue], "Tue, 16 May 2017 10:18:18 +0300")
        XCTAssertEqual(headers![HeaderType.authorization.rawValue], "Bearer 90e57138faf35289ca2d40d37f49f0980897a8b7")
    }

    #if os(Linux)
    static var allTests = [
        ("testApiFailure", testApiFailure),
        ("testOrganizationalHeaders", testOrganizationalHeaders),
        ("testPartnerHeaders", testPartnerHeaders),
    ]
    #endif
}

private struct MockRequest: APIServiceRequest {

    typealias BodyType = MockBodyData
    typealias ReturnType = String

    var path: String = ""
    var httpMethod: HTTPMethod = .post
    var headers: [String:String]?
    var bodyData: BodyType?

    init(clientID: String, secret: String) {
        bodyData = MockBodyData(document: MockInternalBody(name: "Test"))
        headers = APIRequestHeaderImpl<MockRequest>(self, .organization(secret, clientID)).headers
        path = "/api/v1/document/"
    }

}

private struct MockBodyData: Encodable {
    let document: MockInternalBody
}
private struct MockInternalBody: Encodable {
    let name: String
}