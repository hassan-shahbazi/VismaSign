import Foundation

protocol VismaSignClient { }

protocol VismaSignClientOrganization: VismaSignClient {

    func performOrganizationRequests<T: APIServiceOrganizationRequest>(_ request: T, completion: @escaping (Result<T.ReturnType>) -> Void) throws
}

protocol VismaSignClientPartner: VismaSignClient {
    
    func performPartnerRequests<T: APIServicePartnerRequest>(_ request: T, completion: @escaping (Result<T.ReturnType>) -> Void) throws
}