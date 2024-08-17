//
//  LoginResult.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

public protocol LoginResult {}

/// 認可リクエストが成功した結果。(Authorization Codeフロー)
public struct AuthorizationCodeFlowLoginResult: LoginResult {
    // MARK: Public property
    /// 認可コード。
    public let authorizationCode: String

    /// リクエスト時に指定されたstate値
    public let state: String?
}

/// 認可リクエストが成功した結果。(HybridFlow)
public struct HyblidFlowLoginResult: LoginResult {
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
