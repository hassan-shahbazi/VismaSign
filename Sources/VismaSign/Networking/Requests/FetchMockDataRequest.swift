
public struct FetchMockDataRequest: APIServiceRequest {

    typealias BodyType = EmptyModel
    typealias ReturnType = String

    var path: String
    var httpMethod: HTTPMethod
    var bodyData: BodyType?

    init() {
        path = "path"
        httpMethod = .get
    }
}