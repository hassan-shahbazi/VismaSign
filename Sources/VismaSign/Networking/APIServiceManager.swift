protocol APIServiceManager {
    
    func perform<T: APIServiceRequest>(request: T, completion: @escaping ((Result<T.ReturnType>) -> Void))
}

final class APIServiceManagerImpl: APIServiceManager {
    
    func perform<T: APIServiceRequest>(request: T, completion: @escaping ((Result<T.ReturnType>) -> Void)) {
        completion(.failure(APIError.detailed))
    }
}