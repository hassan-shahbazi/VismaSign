import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

enum APIError: LocalizedError {
    case detailed

    var errorDescription: String? {
        switch self {
            case .detailed: return "error has been occured"
        }
    }
}