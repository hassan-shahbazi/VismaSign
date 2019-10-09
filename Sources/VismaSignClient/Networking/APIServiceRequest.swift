import Foundation

public enum HTTPMethod: String {
    case get, post, delete, put
}

public protocol APIServiceRequest {
    associatedtype ReturnType: Decodable
    associatedtype BodyType: Encodable

    var host: String! { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String:String]? { get }
    var bodyData: BodyType? { get }

    var body: Data? { get }
}

public extension APIServiceRequest {
    var host: String! {
        return "http://vismasign.com"
    }

    var body: Data? {    
        return bodyData.data
    }
}

extension APIServiceGeneralRequest {
    var headers: [String:String]? {
        return APIRequestHeaderImpl(.noHeader(self)).headers
    } 
}

extension APIServiceOrganizationRequest {
    var headers: [String:String]? {
        return APIRequestHeaderImpl(.organization(self, self.secret, self.clientID)).headers
    }
}

extension APIServicePartnerRequest {
    var headers: [String:String]? {
        return APIRequestHeaderImpl(.partner(self, self.accessTokenModel.tokenType, self.accessTokenModel.accessToken)).headers
    }
}