import Foundation

public protocol APIServiceManager {
    
    func perform<T: APIServiceRequest>(request: T, completion: @escaping ((Result<T.ReturnType>) -> Void))
}

public final class APIServiceManagerImpl: APIServiceManager {
    
    public init() { }
    
    public func perform<T: APIServiceRequest>(request: T, completion: @escaping ((Result<T.ReturnType>) -> Void)) {
        completion(.failure(APIError.detailed))
    }
}