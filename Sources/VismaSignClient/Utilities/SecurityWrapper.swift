import Foundation
import Cryptor

extension Data {
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }

    var bytes: [UInt8] {
        return [UInt8](self)
    }

    var md5: [UInt8]? {
        guard let jsonString = String(data: self, encoding: .utf8) else { return nil }
        return Digest(using: .md5).update(string: jsonString)?.final()
    }

    func hmac_sha512(key: String) -> [UInt8]? {
        guard let hexKey = Data(base64Encoded: key, options: .ignoreUnknownCharacters)?.hexString else { return nil }
        let keyArray = CryptoUtils.byteArray(fromHex: hexKey)

        return HMAC(using: HMAC.Algorithm.sha512, key: keyArray).update(byteArray: self.bytes)?.final()
    }
}

extension String {
    var hexData: Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        guard data.count > 0 else { return nil }

        return data
    }

    var base64: String? {
        return self.hexData?.base64EncodedString(options: [])
    }
}