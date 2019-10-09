import Foundation

protocol APIRequestHeader {
    associatedtype ServiceRequest: APIServiceRequest

    init(_ headerSet: HeaderSet<ServiceRequest>)
}

public struct APIRequestHeaderImpl<T: APIServiceRequest>: APIRequestHeader {
    typealias ServiceRequest = T
    public var headers: [String:String]! = [:]

    init(_ headerSet: HeaderSet<ServiceRequest>) {
        switch headerSet {
            case .noHeader:
                self.headers = commonHeaders(Date())
            case .organization(let request, let secret, let clientID, let date):
                self.headers = commonHeaders(date)
                self.updateOrganizationHeaders(request, secret, clientID)

            case .partner(let tokenType, let token, let date):
                self.headers = commonHeaders(date)
                self.updatePartnerHeaders(tokenType, token)
        }
    }

    private var commonHeaders: ((Date) -> [String:String]) = { date in
        let contentType = ContentType.applicationJSON.rawValue
        let date = date.RFC2822String!

        return [HeaderType.contentType.rawValue: contentType,
                HeaderType.date.rawValue: date] 
    }

    // MARK: - Organization header methods

    mutating func updateOrganizationHeaders(_ request: ServiceRequest, _ secret: String, _ clientID: String) {
        guard let contentMD5 = request.body?.md5 else { return }
        self.headers[HeaderType.contentMD5.rawValue] = Data(bytes: contentMD5).hexString.base64
        self.headers[HeaderType.authorization.rawValue] = authorization(request, secret, clientID)
    }

    private func authorization(_ request: ServiceRequest, _ secret: String, _ clientID: String) -> String? {
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

    // MARK: - Partners header methods

    mutating func updatePartnerHeaders(_ tokenType: String, _ token: String) {
        self.headers[HeaderType.authorization.rawValue] = "\(tokenType) \(token)"
    }
}

enum HeaderSet<T> {
    case noHeader

    case organization(T, String, String, Date)
    static func organization(_ request: T, _ clientID: String, _ secret: String) -> HeaderSet {
        return .organization(request, clientID, secret, Date())
    }

    case partner(String, String, Date)
    static func partner(_ tokenType: String, _ token: String) -> HeaderSet {
        return .partner(tokenType, token, Date())
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