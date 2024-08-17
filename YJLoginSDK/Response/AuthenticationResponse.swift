//
//  AuthorizationResponse.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

import Foundation

fileprivate func parseQueries(url: URL, flow: Flow) throws -> [String: String?] {
    var queries: [String:String?] = [:]
    switch flow {
    case .authenticationCode:
        guard let urlComponent = URLComponents(formUrlencodedString: url.absoluteString) else {
            throw AuthenticationResponseError.unexpectedError
        }
        guard let queryItems = urlComponent.queryItems, !queryItems.isEmpty else {
            throw AuthenticationResponseError.userCancel
        }
        for item in queryItems {
            queries[item.name] = item.value
        }
    default:
        guard let queryString = url.fragment else {
            throw AuthenticationResponseError.unexpectedError
        }
        let queryPairs = queryString.split(separator: "&").map { String($0) }
        for pairString in queryPairs {
            let pair = pairString.split(separator: "=").map { String($0) }
            queries[pair[0]] = pair[1]
        }
    }
    return queries
}

internal struct AuthenticationResponse {
    let responseTypes: [ResponseType]
    let flow: Flow
    
    let authorizationCode: String?
    let tokenType: String?
    let idToken: String?
    let accessToken: String?
    let expiresIn: Int?
    let state: String?

    internal init(url: URL, validatingWith expectedState: String? = nil, responseTypes: [ResponseType]) throws {
        self.responseTypes = responseTypes
        self.flow = Flow(responseTypes: responseTypes)
        
        var authorizationCode: String?
        var tokenType: String?
        var idToken: String?
        var accessToken: String?
        var expiresIn: Int?
        var state: String?
        var error: String?
        var errorDescription: String?
        var errorCode: Int?

        let queries = try! parseQueries(url: url, flow: flow)

        for item in queries {
            switch item.key {
            case "code":
                authorizationCode = item.value
            case "token_type":
                tokenType = item.value
            case "id_token":
                idToken = item.value
            case "access_token":
                accessToken = item.value
            case "expires_in":
                if let value = item.value, let intValue = Int(value) {
                    expiresIn = intValue
                }
            case "state":
                state = item.value
            case "error":
                error = item.value
            case "error_description":
                errorDescription = item.value
            case "error_code":
                if let value = item.value, let intValue = Int(value) {
                    errorCode = intValue
                }
            default: break
            }
        }

        if state != nil && expectedState == nil {
            throw AuthenticationResponseError.invalidState
        }

        if state == nil && expectedState != nil {
            throw AuthenticationResponseError.invalidState
        }

        if state != nil && expectedState != nil {
            guard expectedState == state else {
                throw AuthenticationResponseError.invalidState
            }
        }

        if let error, let errorDescription, let errorCode {
            guard let responseError = AuthenticationResponseError.Error(rawValue: error) else {
                throw AuthenticationResponseError.undefinedError(error: error, description: errorDescription, code: errorCode)
            }

            throw AuthenticationResponseError.serverError(error: responseError, description: errorDescription, code: errorCode)
        }

        self.authorizationCode = authorizationCode
        self.tokenType = tokenType
        self.idToken = idToken
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.state = state
    }
    
    func loginResult() throws -> LoginResult {
        switch flow {
        case .authenticationCode:
            guard let authorizationCode else {
                throw AuthenticationResponseError.emptyAuthorizationCode
            }
            return AuthorizationCodeFlowLoginResult(authorizationCode: authorizationCode, state: state)
        case .hybrid:
            guard let authorizationCode else {
                throw AuthenticationResponseError.emptyAuthorizationCode
            }
            if responseTypes.firstIndex(of: .token) != nil {
                guard accessToken != nil && tokenType != nil else {
                    throw AuthenticationResponseError.emptyAccessToken
                }
            }
            if responseTypes.firstIndex(of: .idToken) != nil {
                guard idToken != nil else {
                    throw AuthenticationResponseError.emptyIdToken
                }
            }
            return HyblidFlowLoginResult(authorizationCode: authorizationCode, tokenType: tokenType, idToken: idToken, accessToken: accessToken, state: state)
        case .implicit:
            if responseTypes.firstIndex(of: .token) != nil {
                guard accessToken != nil && tokenType != nil && expiresIn != nil else {
                    throw AuthenticationResponseError.emptyAccessToken
                }
            }
            if responseTypes.firstIndex(of: .idToken) != nil {
                guard idToken != nil else {
                    throw AuthenticationResponseError.emptyIdToken
                }
            }
            return ImplicitFlowLoginResult(tokenType: tokenType, idToken: idToken, accessToken: accessToken, expiresIn: expiresIn, state: state)

        }
    }
}
