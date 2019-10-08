import Foundation

public enum HTTPMethod: String {
    case get, post, delete, put
}

public protocol APIServiceRequest {

    associatedtype ReturnType: Decodable
    associatedtype BodyType: Encodable

    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var bodyData: BodyType? { get }
}