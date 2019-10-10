import Foundation

#if os(Linux)
import FoundationNetworking
#endif

open class VismaSignClientImpl: VismaSignClient {

    enum VismaSignClientError: Error {
        case badURL

        var errorDescription: String {
            switch self {
                case .badURL: return "Cannot parse and build the URL by ginve path"
            }
        }
    }

    private let session = URLSession.shared

    public init() {}

    public func performRequests<T: APIServiceRequest>(_ request: T, completion: @escaping (Result<T.ReturnType>) -> Void) throws {
        let urlRequest = try self.urlRequest(request)
        let task = session.dataTask(with: urlRequest) { [unowned self] responseData, response, responseError in
            if case let .failure(error) = self.validateResponseData(responseData, response: response, responseError: responseError) {
                completion(.failure(error))
                return
            }
            let result: Result<T.ReturnType> = self.parseResponseData(responseData)
            completion(result)
        }

        task.resume()
    }

    private func urlRequest<T: APIServiceRequest>(_ request: T, cache: URLRequest.CachePolicy = .useProtocolCachePolicy) throws -> URLRequest {
        guard let url = URL(string: "\(request.host!)\(request.path)") else {
            throw VismaSignClientError.badURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        urlRequest.cachePolicy = cache

        return urlRequest
    }

    private func validateResponseData(_ responseData: Data?, response: URLResponse?, responseError: Error?) -> Result<Void> {
        if let responseError = responseError {
            return .failure(responseError)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(APIError.noData)
        }

        guard 200 ... 299 ~= httpResponse.statusCode else {
            return .failure(APIError.detailed(httpResponse.statusCode, nil))
        }

        return .success(())
    }

    private func parseResponseData<T: Decodable>(_ data: Data?) -> Result<T> {
        guard let data = data else { return .failure(APIError.noData) }
        do {
            let parsingResult = try JSONDecoder().decode(T.self, from: data)
            return .success(parsingResult)
        } catch {
            return .failure(error)
        }
    }
}

extension VismaSignClientImpl: VismaSignClientOrganization {
    public func performOrganizationRequests<T: APIServiceOrganizationRequest>(_ request: T, completion: @escaping (Result<T.ReturnType>) -> Void) throws {
        try self.performRequests(request, completion: completion)
    }
}

extension VismaSignClientImpl: VismaSignClientPartner {
    public func performPartnerRequests<T: APIServicePartnerRequest>(_ request: T, completion: @escaping (Result<T.ReturnType>) -> Void) throws {
        try self.performRequests(request, completion: completion)
    }

    public func fetchAccessToken(clientID: String, clientSecret: String, completion: @escaping (Result<AccessTokenModel>) -> Void) throws {
        let request = AccessTokenRequest(clientID: clientID, clientSecret: clientSecret)
        try self.performRequests(request, completion: completion)
    }
}

extension Encodable {
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
