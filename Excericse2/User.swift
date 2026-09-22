//
//  User.swift
//  Excericse2
//
//  Created by emre on 22.09.26.
//

import Foundation

nonisolated struct User: Decodable{
    let kind: String
    let localId: String
    let email: String
    let displayName: String
    let idToken: String
    let registered: Bool
    let refreshToken: String
    let expiresIn: String
}

nonisolated struct ResponseError: Decodable{
    let code: Int
    let message: String
    struct Error: Decodable{
        let message: String
        let domain: String
        let reason: String
    }
    let errors: [Error]
}
