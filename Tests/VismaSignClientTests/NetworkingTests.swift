import XCTest
@testable import VismaSignClient

final class NetworkingTests: XCTestCase {

    private var apiService: APIServiceManager! = APIServiceManagerImpl()

    func testApiFailure() {
        let exp = expectation(description: "the test is failed")
        let request = MockOrganizationRequest(clientID: "client", secret: "secret")
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
        let request = MockOrganizationRequest(clientID: "ddf58116-6082-4bfc-a775-0c0bb2f945ce", secret: "jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY=")
        XCTAssertNotNil(request.headers)

        XCTAssertEqual(request.headers![HeaderType.contentType.rawValue], ContentType.applicationJSON.rawValue)
        XCTAssertEqual(request.headers![HeaderType.contentMD5.rawValue], Data(bytes: contentMD5!).hexString.base64)
        XCTAssertEqual(request.headers![HeaderType.date.rawValue], "Tue, 16 May 2017 10:18:18 +0300")
        XCTAssertEqual(request.headers![HeaderType.authorization.rawValue], "Onnistuu ddf58116-6082-4bfc-a775-0c0bb2f945ce:7s+Vee4VG0pObH/GkFpi4DAP1naaaPrPVzOytzbKRe9TBxB+LNzv03jySVFXeFyNJRUY8HRtdlY4e10QpAIFhg==")
    }

    func testPartnerHeaders() {
        let request = MockPartnerRequest()
        XCTAssertNotNil(request.headers)

        XCTAssertEqual(request.headers![HeaderType.contentType.rawValue], ContentType.applicationJSON.rawValue)
        XCTAssertEqual(request.headers![HeaderType.date.rawValue], "Tue, 16 May 2017 10:18:18 +0300")
        XCTAssertEqual(request.headers![HeaderType.authorization.rawValue], "Bearer 90e57138faf35289ca2d40d37f49f0980897a8b7")
    }

    #if os(Linux)
    static var allTests = [
        ("testApiFailure", testApiFailure),
        ("testOrganizationalHeaders", testOrganizationalHeaders),
        ("testPartnerHeaders", testPartnerHeaders),
    ]
    #endif
}

private struct MockOrganizationRequest: APIServiceRequest {

    typealias BodyType = MockBodyData
    typealias ReturnType = String

    var path: String
    var httpMethod: HTTPMethod = .post
    var headers: [String:String]?
    var bodyData: BodyType?

    init(clientID: String, secret: String) {
        path = "/api/v1/document/"
        bodyData = MockBodyData(document: MockInternalBody(name: "Test"))
        headers = APIRequestHeaderImpl(.organization(self, secret, clientID, Date.RFC2822DateFormatter.date(from: "Tue, 16 May 2017 10:18:18 +0300")!)).headers
    }

}

private struct MockPartnerRequest: APIServiceRequest {
    typealias BodyType = EmptyModel
    typealias ReturnType = EmptyModel

    var path: String = ""
    var httpMethod: HTTPMethod = .post
    var headers: [String:String]?
    var bodyData: BodyType?

    init() {
        headers = APIRequestHeaderImpl<MockPartnerRequest>(.partner("Bearer", "90e57138faf35289ca2d40d37f49f0980897a8b7", Date.RFC2822DateFormatter.date(from: "Tue, 16 May 2017 10:18:18 +0300")!)).headers
    }
}

private struct MockBodyData: Encodable {
    let document: MockInternalBody
}
private struct MockInternalBody: Encodable {
    let name: String
}