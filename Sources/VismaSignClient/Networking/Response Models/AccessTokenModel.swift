import Foundation

public struct AccessTokenModel: Codable {
    public let accessToken: String
    public let expiresIn: Int
    public let tokenType, scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
    }
}
