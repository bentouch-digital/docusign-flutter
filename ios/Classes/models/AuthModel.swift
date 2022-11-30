//
//  AuthModel.swift
//
//  Created by Scot SCRIVEN on 22/06/2022.
//

struct AuthModel: Decodable {
    let accessToken: String;
    let accountId: String;
    let userId: String;
    let userName: String;
    let email: String;
    let host: String;
    let integratorKey: String;
}
