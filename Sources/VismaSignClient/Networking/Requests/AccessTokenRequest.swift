import Foundation

struct AccessTokenRequest: APIServiceRequest {
    typealias BodyType = String
    typealias ReturnType = AccessTokenModel

    var path: String
    var httpMethod: HTTPMethod = .post
    var headers: [String:String]?
    var bodyData: BodyType?

    init(clientID: String, clientSecret: String) {
        path = "/api/v1/auth/token"
        bodyData = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)&scope=organization_get%20organization_search%20organization_create"
        headers = APIRequestHeaderImpl(.noHeader(self)).headers
    }
}