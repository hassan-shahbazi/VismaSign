import Foundation

// General protocol for requests that **do not need special headers**
public protocol APIServiceGeneralRequest: APIServiceRequest { }

// Protocol designed for organizational requests
public protocol APIServiceOrganizationRequest: APIServiceRequest {
    var secret: String! { get }
    var clientID: String! { get }
}

// Protocol designed for partner requests
public protocol APIServicePartnerRequest: APIServiceRequest {
    var accessTokenModel: AccessTokenModel! { get }
}
