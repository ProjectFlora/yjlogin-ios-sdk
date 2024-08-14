//
//  ResponseType.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

import Foundation

/// Yahoo! ID連携の認可レスポンスとして取得するパラメーターを指定するために、認可リクエストに設定する値。
public enum ResponseType: String {
    /// Authorization Codeを取得。
    case code
    
    /// Access Tokenを取得。
    case token
    
    /// ID Tokenを取得。
    case idToken = "id_token"
}
