//
//  Flow.swift
//  YJLoginSDK
//
//  © 2024 Yahoo Japan Corporation. All rights reserved.
//

import Foundation

/// コード認証フロー。
public enum Flow {
    /// Authentication Codeフロー
    case authenticationCode
    
    /// Implicitフロー。
    case implicit
    
    /// Hybridフロー。
    case hybrid
    
    /// `ResponseType`の配列からコード認証フローを取得する
    /// - Parameter responseTypes: `ResponseType`の配列
    init(responseTypes: [ResponseType]) {        
        var containsCode = false
        var containsToken = false
        for responseType in responseTypes {
            switch responseType {
            case .code:
                containsCode = true
            case .idToken, .token:
                containsToken = true
            }
        }
        
        switch (containsCode, containsToken) {
        case (true, true):
            self = .hybrid
        case (true, false):
            self = .authenticationCode
        case (false, true):
            self = .implicit
        default:
            fatalError("[YJLoginSDK] Invalid case.")
        }
    }
}
