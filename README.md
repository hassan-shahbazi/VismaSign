# VismaSign

![Build_Status](https://travis-ci.org/Hassaniiii/VismaSign.svg?branch=master)

## Description

The library is intended to implement an interface for the API documented [here](https://sign.visma.net/api/docs/v1/) and [here](https://sign.visma.net/api/docs/v1/partners/) It is written in *Swift 4.2* on *Fedora* and is useable in both **Linux** and **macOS**.

## Requirements

- Swift >= 4.2
- OpenSSL (*libssl-dev* package should be available on Linux)

## Dependencies

- [BlueCryptor](https://github.com/IBM-Swift/BlueCryptor)

### Build && Test

```
cd path/to/project
swift build
swift test
swift run
```

## Usage

The library introduces the following protocols for making API requests:
- **APIServiceGeneralRequest**: If you have a request which doesn't need any special headers, you can confrim to this protocol in your APIRequest struct
- **APIServiceOrganizationRequest**: The protocol is designed for organizational request where authorization is applied as defined [here](https://sign.visma.net/api/docs/v1/)
- **APIServicePartnerRequest**: The protocol is designed for partner request where the Oath authorization is applied as defiend [here](https://sign.visma.net/api/docs/v1/partners/)

#### APIServiceOrganizationRequest example

You can easily create organizational request by conforming to the protocol. The headers will be applied automatically

```swift
struct OrganizationRequest: APIServiceOrganizationRequest {

    typealias BodyType = RequestBody
    typealias ReturnType = EmptyModel

    var host: String! = "your_host_here" // can be set on *APIServiceRequest* extension for global usages
    var path: String = "API_path_here"
    var httpMethod: HTTPMethod = .post
    var bodyData: BodyType?
    var secret: String!
    var clientID: String!
    
    init(clientID: String, secret: String) {
        self.clientID = clientID
        self.secret = secret
        
        bodyData = RequestBody(name: "name")
    }

    struct RequestBody: Encodable {
        let name: String
    }
}
```

#### APIServicePartnerRequest example

You can easily create partner request by conforming to the protocol. To initiate a new *PartnerRequest* you need to inject *AccessTokenModel* containing required information for Oath authentication.

```swift
struct PartnerRequest: APIServicePartnerRequest {
    typealias BodyType = EmptyModel
    typealias ReturnType = String

    var host: String! = "your_host_here" // can be set on *APIServiceRequest* extension for global usages
    var path: String = "API_path_here"
    var httpMethod: HTTPMethod = .post
    var bodyData: BodyType?
    var accessTokenModel: AccessTokenModel!

    init(accessTokenModel: AccessTokenModel) {
        self.accessTokenModel = accessTokenModel
    }
}
```