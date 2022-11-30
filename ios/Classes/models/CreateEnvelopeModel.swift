//
//  CreateEnvelopeModel.swift
//  docusign_flutter
//
//  Created by Scot SCRIVEN on 22/06/2022.
//

struct CreateEnvelopeModel: Decodable {
    let filePath: String;
    let envelopeName: String;
    let envelopeSubject: String;
    let envelopeMessage: String;
    let hostName: String;
    let hostEmail: String;
    let inPersonSignerName: String;
    let inPersonSignerEmail: String;
    let signerName: String;
    let signerEmail: String;
    // let signers: Array<String>;
}
