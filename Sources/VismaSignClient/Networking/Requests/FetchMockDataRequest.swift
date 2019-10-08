import Foundation

public struct FetchMockDataRequest: APIServiceRequest {

    public typealias BodyType = EmptyModel
    public typealias ReturnType = String

    public var path: String
    public var httpMethod: HTTPMethod
    public var bodyData: BodyType?

    public init() {
        path = "path"
        httpMethod = .get
    }
}