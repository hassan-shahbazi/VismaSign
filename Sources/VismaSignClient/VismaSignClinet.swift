import Foundation

public protocol VismaSignClient {
    func performRequests<T: APIServiceRequest>(_ request: T, completion: @escaping (Result<T.ReturnType>) -> Void) throws
}

public protocol VismaSignClientOrganization: VismaSignClient {

    func performOrganizationRequests<T: APIServiceOrganizationRequest>(_ request: T, completion: @escaping (Result<T.ReturnType>) -> Void) throws
}

public protocol VismaSignClientPartner: VismaSignClient {

    func performPartnerRequests<T: APIServicePartnerRequest>(_ request: T, completion: @escaping (Result<T.ReturnType>) -> Void) throws

    func fetchAccessToken(clientID: String, clientSecret: String, completion: @escaping (Result<AccessTokenModel>) -> Void) throws
}
