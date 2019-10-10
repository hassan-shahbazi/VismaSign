import Foundation

public struct AccessTokenRequest: APIServiceRequest {
    public typealias BodyType = String
    public typealias ReturnType = AccessTokenModel

    public var path: String
    public var httpMethod: HTTPMethod = .post
    public var headers: [String:String]?
    public var bodyData: BodyType?

    public init(clientID: String, clientSecret: String) {
        path = "/api/v1/auth/token"
        bodyData = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)&scope=organization_get%20organization_search%20organization_create"
        headers = APIRequestHeaderImpl(.noHeader(self)).headers
    }
}
