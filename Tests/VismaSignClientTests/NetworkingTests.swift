import XCTest
@testable import VismaSignClient

final class NetworkingTests: XCTestCase {

    func testOrganizationalHeaders() {
        let request = MockOrganizationRequest(clientID: "ddf58116-6082-4bfc-a775-0c0bb2f945ce", secret: "jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY=")
        XCTAssertNotNil(request.headers)

        XCTAssertEqual(request.headers![HeaderType.contentType.rawValue], ContentType.applicationJSON.rawValue)
        XCTAssertEqual(request.headers![HeaderType.contentMD5.rawValue], Data(bytes: request.body!.md5).hexString.base64)
    }

    func testOrganizationHeaderCalculator() {
        let formatter = Date.RFC2822DateFormatter
        // for test purposes
        formatter.timeZone = TimeZone(identifier: "EEST")

        let request = MockOrganizationRequest(clientID: "ddf58116-6082-4bfc-a775-0c0bb2f945ce", secret: "jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY=")
        let headers = APIRequestHeaderImpl(.organization(request, request.secret, request.clientID, formatter.date(from: "Tue, 16 May 2017 10:18:18 +0000")!)).headers

        XCTAssertEqual(headers![HeaderType.authorization.rawValue], "Onnistuu ddf58116-6082-4bfc-a775-0c0bb2f945ce:erd5F6w7+uLI4QTci9w5MSZqIxXHlOtyFq4Wj5xd9foKSMZVb2v6GAxErV5ZdOMdW5cRghEX3ZmtmShtdHltyg==")
    }

    func testPartnerHeaders() {
        let request = MockPartnerRequest(accessTokenModel: AccessTokenModel(accessToken: "90e57138faf35289ca2d40d37f49f0980897a8b7", expiresIn: 3600, tokenType: "Bearer", scope: "organization_get organization_search organization_create"))
        XCTAssertNotNil(request.headers)

        XCTAssertEqual(request.headers![HeaderType.contentType.rawValue], ContentType.applicationJSON.rawValue)
        XCTAssertEqual(request.headers![HeaderType.authorization.rawValue], "Bearer 90e57138faf35289ca2d40d37f49f0980897a8b7")
    }

    func testVismaSignClientImpl() {
        let request = MockOrganizationRequest(clientID: "ddf58116-6082-4bfc-a775-0c0bb2f945ce", secret: "jp7SjOOr4czRTifCo30qx0sZAIw9PW+vVpsbP09pQaY=")
        let serviceManager: VismaSignClientOrganization = VismaSignClientImpl()

        let expect = expectation(description: "The test should throw an exception")
        do {
            try serviceManager.performOrganizationRequests(request) { _ in }
        } catch {
            XCTAssertTrue(true)
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    #if os(Linux)
    static var allTests = [
        ("testOrganizationalHeaders", testOrganizationalHeaders),
        ("testOrganizationHeaderCalculator", testOrganizationHeaderCalculator),
        ("testVismaSignClientImpl", testVismaSignClientImpl),
        ("testPartnerHeaders", testPartnerHeaders),
    ]
    #endif
}

private struct MockOrganizationRequest: APIServiceOrganizationRequest {

    typealias BodyType = MockBodyData
    typealias ReturnType = String

    var path: String
    var httpMethod: HTTPMethod = .post
    var bodyData: BodyType?
    var secret: String!
    var clientID: String!

    init(clientID: String, secret: String) {
        self.clientID = clientID
        self.secret = secret


        path = "/api/v1/document/"
        bodyData = MockBodyData(document: MockInternalBody(name: "Test"))
    }

    // invalid host
    var host: String! {
        return " ? "
    }
}

private struct MockPartnerRequest: APIServicePartnerRequest {
    typealias BodyType = EmptyModel
    typealias ReturnType = EmptyModel

    var path: String = ""
    var httpMethod: HTTPMethod = .post
    var bodyData: BodyType?
    var accessTokenModel: AccessTokenModel!

    init(accessTokenModel: AccessTokenModel) {
        self.accessTokenModel = accessTokenModel
    }
}

private struct MockBodyData: Encodable {
    let document: MockInternalBody
}
private struct MockInternalBody: Encodable {
    let name: String
}
