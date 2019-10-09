import Foundation

public enum HTTPMethod: String {
    case get, post, delete, put
}

public protocol APIServiceRequest {
    associatedtype ReturnType: Decodable
    associatedtype BodyType: Encodable

    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String:String]? { get }
    var bodyData: BodyType? { get }

    var body: Data? { get }
}

public extension APIServiceRequest {
    var body: Data? {    
        return bodyData.data
    }
}

extension Encodable {
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}