import Foundation

struct ObtainAccessTokenModel: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType, scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
    }
}