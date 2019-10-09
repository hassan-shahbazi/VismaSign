import Foundation

protocol APIRequestHeader {
    associatedtype ServiceRequest: APIServiceRequest

    init(_ request: ServiceRequest, _ headerSet: HeaderSet, secret: String)
}

public struct APIRequestHeaderImpl<T: APIServiceRequest>: APIRequestHeader {
    typealias ServiceRequest = T
    private let request: ServiceRequest
    public var headers: [String:String]! = [:]

    init(_ request: ServiceRequest, _ headerSet: HeaderSet, secret: String) {
        self.request = request

        switch headerSet {
            case let .organization(clientID, date):
                self.headers = commonHeaders(date)
                self.updateOrganizationHeaders(secret, clientID)
        }
    }

    private var commonHeaders: ((Date) -> [String:String]) = { date in
        let contentType = ContentType.applicationJSON.rawValue
        let date = date.RFC2822String!

        return [HeaderType.contentType.rawValue: contentType,
                HeaderType.date.rawValue: date] 
    }

    mutating func updateOrganizationHeaders(_ secret: String, _ clientID: String) {
        guard let contentMD5 = request.body?.md5 else { return }
        self.headers[HeaderType.contentMD5.rawValue] = Data(bytes: contentMD5).hexString.base64
        self.headers[HeaderType.authorization.rawValue] = authorization(secret, clientID)
    }

    // MARK: - Utility methods

    private func authorization(_ secret: String, _ clientID: String) -> String? {
        let prefixString: String = "Onnistuu \(clientID):"
        var dataString: String = "\(request.httpMethod.rawValue.uppercased())"
        dataString += "\n\(headers[HeaderType.contentMD5.rawValue] ?? "")"
        dataString += "\n\(headers[HeaderType.contentType.rawValue] ?? "")"
        dataString += "\n\(headers[HeaderType.date.rawValue] ?? "")"
        dataString += "\n\(request.path)"

        guard let data: Data = dataString.data(using: .utf8) else { return nil }
        guard let hmac_sha512 = data.hmac_sha512(key: secret) else { return nil }
        return "\(prefixString)\(Data(bytes: hmac_sha512).hexString.base64!)"
    }
}

enum HeaderSet {
    case organization(String, Date)
    static func organization(_ clientID: String) -> HeaderSet {
        return .organization(clientID, Date())
    }
}

enum HeaderType: String {
    case contentMD5 = "content-md5"
    case contentType = "content-type"
    case date = "date"
    case authorization = "authorization"
}

enum ContentType: String {
    case applicationJSON = "application/json"
}