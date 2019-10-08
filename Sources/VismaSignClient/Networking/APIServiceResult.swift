import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

public enum APIError: LocalizedError {
    case detailed

    public var errorDescription: String? {
        switch self {
            case .detailed: return "error has been occured"
        }
    }
}