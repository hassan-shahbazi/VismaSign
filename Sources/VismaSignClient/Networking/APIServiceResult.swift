import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

public enum APIError: LocalizedError {
    case noData
    case detailed(Int, String?)

    public enum Reason: Int {
        case unauthorized = 401
        case limitSurpassed = 406
        case dataNotUnique = 422
        case invalidCode = 500
    }

    public var reason: Reason? {
        switch self {
        case let .detailed(statusCode, _):
            return Reason(rawValue: statusCode)
        default:
            return nil
        }
    }

    public var errorDescription: String? {
        switch self {
        case let .detailed(_, backendDescription):
            return backendDescription
        default:
            return nil
        }
    }
}