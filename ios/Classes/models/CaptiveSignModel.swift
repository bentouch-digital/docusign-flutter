//
//  CaptiveSignModel.swift
//  docusign_flutter
//
//  Created by Scot SCRIVEN on 22/06/2022.
//

struct CaptiveSignModel: Decodable {
    let envelopeId: String;
    let recipientUserName: String;
    let recipientEmail: String;
    let recipientClientUserId: String;
}
