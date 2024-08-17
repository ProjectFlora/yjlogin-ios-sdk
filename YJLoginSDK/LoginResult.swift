//
//  LoginResult.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

/// 認可リクエストが成功した結果。
public protocol LoginResult {
    /// 認証フロー。
    var flow: Flow { get }
}

/// 認可リクエストが成功した結果。(Authorization Codeフロー)
public struct AuthorizationCodeFlowLoginResult: LoginResult {
    public var flow: Flow { return .authenticationCode }

    /// 認可コード。
    public let authorizationCode: String

    /// リクエスト時に指定されたstate値
    public let state: String?
}

/// 認可リクエストが成功した結果。(HybridFlow)
public struct HyblidFlowLoginResult: LoginResult {
    public var flow: Flow { return .hybrid }

    /// 認可コード。
    public let authorizationCode: String
    
    /// トークン種別。
    public let tokenType: String?
    
    /// IDトークン。
    public let idToken: String?
    
    /// アクセストークン。
    public let accessToken: String?
    
    /// リクエスト時に指定されたstate値
    public let state: String?
}

/// 認可リクエストが成功した結果。(ImplicitFlow)
public struct ImplicitFlowLoginResult: LoginResult {
    public var flow: Flow { return .implicit }

    /// トークン種別。
    public let tokenType: String?
    
    /// IDトークン。
    public let idToken: String?
    
    /// アクセストークン。
    public let accessToken: String?
    
    /// アクセストークンの有効期限。
    public let expiresIn: Int?
    
    /// リクエスト時に指定されたstate値
    public let state: String?
}
